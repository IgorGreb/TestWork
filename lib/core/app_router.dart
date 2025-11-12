import 'package:flutter/material.dart';
import '../screens/loading_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/levels_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/how_to_play_screen.dart';
import '../screens/game_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/loading': (_) => const LoadingScreen(),
  '/menu': (_) => const MenuScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/settings': (_) => const SettingsScreen(),
  '/levels': (_) => const LevelsScreen(),
  '/leaderboard': (_) => const LeaderboardScreen(),
  '/shop': (_) => const ShopScreen(),
  '/howtoplay': (_) => const HowToPlayScreen(),
  '/game': (_) => const GameScreen(),
};
