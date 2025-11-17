import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/menu_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/score_layout.dart';
import 'package:chick_game_prototype/features/shop/shop_controller.dart';
import 'package:chick_game_prototype/widgets/menu_panel.dart';
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
  }

  @override
  void dispose() {
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
    final coins = ref.watch(shopControllerProvider).coins;

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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackBtnLayout(onPressed: () => Navigator.pop(context)),
                      ScoreLayout(width: 200, height: 60, score: coins),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    alignment: Alignment.topCenter,
                    child: MenuPanel(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MENU',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const MenuBtnLayout(
                              btnText: 'PLAY',
                              routeName: '/levels',
                            ),
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
                            const MenuBtnLayout(
                              btnText: 'PRIVACY POLICY',
                              routeName: '/privacy',
                            ),
                            const MenuBtnLayout(
                              btnText: 'TERMS OF USE',
                              routeName: '/terms',
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
