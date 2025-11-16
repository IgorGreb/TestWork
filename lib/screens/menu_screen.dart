import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/menu_btn_layout.dart';
import 'package:chick_game_prototype/core/constants/custom_colors.dart';
import 'package:chick_game_prototype/features/audio/background_music_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundMusicControllerProvider).setMenuActive(true);
    });
  }

  @override
  void dispose() {
    ref.read(backgroundMusicControllerProvider).setMenuActive(false);
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleExit() async {
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        await _handleExit();
        return false;
      },
      child: ChickLayout(
        chickShow: 0,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.2),
                          radius: 0.85,
                          colors: [
                            Colors.orange.withOpacity(
                              0.05 + 0.12 * _glowAnimation.value,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenHeight * 0.03,
                      ),
                      child: BackBtnLayout(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: screenWidth * 0.85,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors.some.withOpacity(0.55),
                        border: Border.all(color: CustomColors.pink, width: 2),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/info_webp/Rectangle 7.webp',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MENU',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.07,
                                  ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const MenuBtnLayout(
                              btnText: 'PROFILE',
                              routeName: '/profile',
                            ),
                            const MenuBtnLayout(
                              btnText: 'SETTINGS',
                              routeName: '/settings',
                            ),
                            const MenuBtnLayout(
                              btnText: 'LEADERBOARD',
                              routeName: '/leaderboard',
                            ),
                            const MenuBtnLayout(
                              btnText: 'SHOP',
                              routeName: '/shop',
                            ),
                            const MenuBtnLayout(
                              btnText: 'HOW TO PLAY',
                              routeName: '/howtoplay',
                            ),
                            MenuBtnLayout(
                              btnText: 'EXIT',
                              routeName: '',
                              onTapOverride: _handleExit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
