import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/providers.dart';

class NocturnalApp extends ConsumerStatefulWidget {
  const NocturnalApp({super.key});

  @override
  ConsumerState<NocturnalApp> createState() => _NocturnalAppState();
}

class _NocturnalAppState extends ConsumerState<NocturnalApp> {
  @override
  void initState() {
    super.initState();
    // Sync catalog from API on app launch (non-blocking, offline-safe)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogSyncProvider).syncCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF181B25),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp.router(
      title: 'NOCTURNAL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
