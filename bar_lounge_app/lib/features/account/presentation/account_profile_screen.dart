import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_colors.dart';
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
  static const _avatarStorageKey = 'account_avatar_path';
  final _picker = ImagePicker();
  final _storage = const FlutterSecureStorage();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _loadAvatar();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAvatar() async {
    final path = await _storage.read(key: _avatarStorageKey);
    if (!mounted) return;
    if (path != null && File(path).existsSync()) {
      setState(() => _avatarPath = path);
    }
  }

  Future<void> _pickAvatar() async {
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
      'nocturnal_avatar_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    await File(image.path).copy(targetPath);
    await _storage.write(key: _avatarStorageKey, value: targetPath);

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

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
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
    if (_nameCtrl.text.isEmpty && displayName != 'Loading...') {
      _nameCtrl.text = displayName;
    }
    if (_emailCtrl.text.isEmpty && email.isNotEmpty) {
      _emailCtrl.text = email;
    }

    return AccountPageScaffold(
      title: 'Account Profile',
      brandText: 'Nocturnal',
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
            onTap: _pickAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHighest,
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: ClipOval(
                    child:
                        _avatarPath == null
                            ? const Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: 64,
                            )
                            : Image.file(
                              File(_avatarPath!),
                              width: 112,
                              height: 112,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => const Icon(
                                    Icons.person_outline,
                                    color: AppColors.primary,
                                    size: 64,
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
              const SizedBox(height: 10),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'No email on file',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Divider(color: Colors.white.withValues(alpha: 0.06)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        accountSectionLabel('SECURITY'),
                        const SizedBox(height: 4),
                        Text(
                          'Update your access credentials',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.onSurface,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/reset-password'),
                    icon: const Icon(Icons.lock_reset, size: 20),
                    label: const Text('Change\nPassword'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurface,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      textStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        GradientButton(
          text: 'SAVE CHANGES',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Profile changes saved locally.',
                  style: GoogleFonts.manrope(),
                ),
                backgroundColor: AppColors.surfaceContainerHigh,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              _nameCtrl.text = displayName;
              _emailCtrl.text = email;
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
