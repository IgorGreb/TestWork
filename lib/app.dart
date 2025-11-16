import 'package:chick_game_prototype/features/audio/background_music_controller.dart';
import 'package:chick_game_prototype/features/settings/settings_controller.dart';
import 'package:chick_game_prototype/features/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_router.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ProviderSubscription<SettingsState>? _musicSubscription;

  @override
  void initState() {
    super.initState();
    _musicSubscription = ref.listenManual<SettingsState>(
      settingsControllerProvider,
      (previous, next) {
        ref
            .read(backgroundMusicControllerProvider)
            .setMusicEnabled(next.musicEnabled);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = ref.read(settingsControllerProvider);
      ref
          .read(backgroundMusicControllerProvider)
          .setMusicEnabled(current.musicEnabled);
    });
  }

  @override
  void dispose() {
    _musicSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(340, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (_, _) => MaterialApp(
            title: 'Chick Game',
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: appRoutes,
            theme: ThemeData(
              fontFamily: GoogleFonts.rubikMonoOne().fontFamily,
              textTheme: GoogleFonts.rubikMonoOneTextTheme(),
              scaffoldBackgroundColor: Colors.black,
            ),
          ),
    );
  }
}
