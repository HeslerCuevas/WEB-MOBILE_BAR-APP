import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';
import 'widgets/account_page_scaffold.dart';

class AccountProfileScreen extends ConsumerStatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  ConsumerState<AccountProfileScreen> createState() =>
      _AccountProfileScreenState();
}

class _AccountProfileScreenState extends ConsumerState<AccountProfileScreen> {
  final _picker = ImagePicker();
  final _storage = const FlutterSecureStorage();
  late final TextEditingController _nameCtrl;
  String? _avatarPath;
  String? _loadedAvatarKey;
  bool _saving = false;
  String? _saveError;
  String? _saveSuccess;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _avatarStorageKey({required int? clienteId, required String email}) {
    if (clienteId != null) return 'account_avatar_path_$clienteId';
    if (email.isNotEmpty) return 'account_avatar_path_${email.toLowerCase()}';
    return 'account_avatar_path_guest';
  }

  Future<void> _loadAvatar({required int? clienteId, required String email}) async {
    final storageKey = _avatarStorageKey(clienteId: clienteId, email: email);
    final path = await _storage.read(key: storageKey);
    if (!mounted) return;
    setState(() {
      _loadedAvatarKey = storageKey;
      _avatarPath = path != null && File(path).existsSync() ? path : null;
    });
  }

  Future<void> _pickAvatar({required int? clienteId, required String email}) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      maxHeight: 900,
      imageQuality: 88,
    );
    if (image == null) return;

    final validationError = await _validateImage(image);
    if (validationError != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError, style: GoogleFonts.manrope()),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final extension = p.extension(image.path).toLowerCase();
    final targetPath = p.join(
      docsDir.path,
      'nocturnal_avatar_${clienteId ?? email.hashCode}_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    await File(image.path).copy(targetPath);
    await _storage.write(
      key: _avatarStorageKey(clienteId: clienteId, email: email),
      value: targetPath,
    );

    if (!mounted) return;
    setState(() => _avatarPath = targetPath);
  }

  Future<String?> _validateImage(XFile image) async {
    final allowedExtensions = {'.jpg', '.jpeg', '.png', '.webp', '.heic'};
    final extension = p.extension(image.path).toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return 'Choose a JPG, PNG, WEBP, or HEIC image.';
    }

    final bytes = await image.readAsBytes();
    const maxBytes = 6 * 1024 * 1024;
    if (bytes.length > maxBytes) {
      return 'Choose an image smaller than 6 MB.';
    }

    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      frame.image.dispose();
      codec.dispose();
    } catch (_) {
      return 'That file could not be read as an image.';
    }

    return null;
  }

  Future<void> _saveChanges() async {
    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) {
      setState(() {
        _saveError = 'Name cannot be empty.';
        _saveSuccess = null;
      });
      return;
    }
    if (newName.length > 100) {
      setState(() {
        _saveError = 'Name must be 100 characters or fewer.';
        _saveSuccess = null;
      });
      return;
    }

    setState(() {
      _saving = true;
      _saveError = null;
      _saveSuccess = null;
    });

    try {
      final result = await ref.read(apiServiceProvider).actualizarPerfil(newName);
      await ref.read(sesionDaoProvider).updateNombre(result.nombre_completo);
      if (mounted) {
        setState(() => _saveSuccess = 'Profile updated successfully!');
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _saveError = ErrorHandler.getMessage(
            e,
            fallback: 'Could not save changes. Please try again.',
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saveError = ErrorHandler.getMessage(
            e,
            fallback: 'Could not save changes. Please try again.',
          );
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
    final sessionData = session.maybeWhen(data: (s) => s, orElse: () => null);
    final displayName = session.when(
      data: (s) => s?.nombreDisplay ?? 'Guest',
      loading: () => 'Loading...',
      error: (_, __) => 'Guest',
    );
    final email = session.when(
      data: (s) => s?.email ?? '',
      loading: () => '',
      error: (_, __) => '',
    );
    final clienteId = sessionData?.clienteId;
    final avatarKey = _avatarStorageKey(clienteId: clienteId, email: email);

    if (email.isNotEmpty && _loadedAvatarKey != avatarKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadAvatar(clienteId: clienteId, email: email);
        }
      });
    }

    if (_nameCtrl.text.isEmpty && displayName != 'Loading...') {
      _nameCtrl.text = displayName;
    }

    return AccountPageScaffold(
      title: 'Account Profile',
      brandText: normalizeBrandText(),
      children: [
        Text(
          'Manage your elite credentials and preferences.',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 26),
        Center(
          child: GestureDetector(
            onTap: () => _pickAvatar(clienteId: clienteId, email: email),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.amberGlow,
                  ),
                ),
                CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.background,
                  child:
                      _avatarPath == null
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'G',
                              style: GoogleFonts.epilogue(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                                File(_avatarPath!),
                                width: 104,
                                height: 104,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Text(
                                      displayName.isNotEmpty
                                          ? displayName[0].toUpperCase()
                                          : 'G',
                                      style: GoogleFonts.epilogue(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                      ),
                                    ),
                              ),
                            ),
                ),
                Positioned(
                  right: -2,
                  bottom: 4,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHigh,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      color: AppColors.primaryContainer,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        AccountGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              accountSectionLabel('FULL NAME'),
              const SizedBox(height: 10),
              TextField(
                controller: _nameCtrl,
                maxLength: 100,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter full name',
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              accountSectionLabel('EMAIL ADDRESS'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.surfaceVariant.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.mail_outline,
                        color: AppColors.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        email.isEmpty ? 'No email available' : email,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Divider(color: Colors.white.withValues(alpha: 0.06)),
              const SizedBox(height: 14),
              accountSectionLabel('SECURITY'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.surfaceVariant.withValues(alpha: 0.45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage password, email changes, and account protection settings.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: _profileActionButton(
                        label: 'Open Security Settings',
                        icon: Icons.shield_outlined,
                        onPressed: () => context.push('/account/security'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_saveError != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _saveError!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_saveSuccess != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF4CAF50),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _saveSuccess!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 26),
        GradientButton(
          text: _saving ? 'SAVING...' : 'SAVE CHANGES',
          onPressed: _saving ? null : _saveChanges,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              _nameCtrl.text = displayName;
              setState(() {
                _saveError = null;
                _saveSuccess = null;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              side: BorderSide(
                color: AppColors.surfaceVariant.withValues(alpha: 0.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'DISCARD',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

Widget _profileActionButton({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.65)),
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      textStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
