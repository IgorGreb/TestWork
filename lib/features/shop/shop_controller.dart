import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shop_state.dart';

class ShopKeys {
  static const coins = 'shop_coins';
  static const owned = 'shop_owned';
  static const equipped = 'shop_equipped';
}

const defaultShopItems = [
  ShopItem(
    id: 'chick_small',
    assetPath: 'assets/chick_webp/little_chick.webp',
    price: 200,
  ),
  ShopItem(
    id: 'chick_big',
    assetPath: 'assets/chick_webp/chick.webp',
    price: 350,
  ),
  ShopItem(
    id: 'chick_profile',
    assetPath: 'assets/profile_webp/profile.webp',
    price: 500,
  ),
];

final shopControllerProvider = StateNotifierProvider<ShopController, ShopState>(
  (ref) {
    final controller = ShopController();
    controller.load();
    return controller;
  },
);

class ShopController extends StateNotifier<ShopState> {
  ShopController() : super(const ShopState());

  SharedPreferences? _prefs;

  Future<void> load() async {
    final prefs = await _ensurePrefs();
    final coins = prefs.getInt(ShopKeys.coins) ?? 1000;
    final equipped = prefs.getString(ShopKeys.equipped);
    final ownedList = prefs.getStringList(ShopKeys.owned) ?? [];
    state = state.copyWith(
      coins: coins,
      equippedId: equipped,
      ownedIds: ownedList.toSet(),
    );
  }

  Future<bool> purchase(ShopItem item) async {
    if (state.ownedIds.contains(item.id)) {
      return equip(item.id);
    }

    if (state.coins < item.price) return false;

    final newCoins = state.coins - item.price;
    final newOwned = Set<String>.from(state.ownedIds)..add(item.id);

    final prefs = await _ensurePrefs();
    await prefs.setInt(ShopKeys.coins, newCoins);
    await prefs.setStringList(ShopKeys.owned, newOwned.toList());
    await prefs.setString(ShopKeys.equipped, item.id);

    state = state.copyWith(
      coins: newCoins,
      ownedIds: newOwned,
      equippedId: item.id,
    );
    return true;
  }

  Future<bool> equip(String itemId) async {
    if (!state.ownedIds.contains(itemId)) return false;
    final prefs = await _ensurePrefs();
    await prefs.setString(ShopKeys.equipped, itemId);
    state = state.copyWith(equippedId: itemId);
    return true;
  }

  Future<void> earnCoins(int amount) async {
    if (amount <= 0) return;
    final newCoins = state.coins + amount;
    final prefs = await _ensurePrefs();
    await prefs.setInt(ShopKeys.coins, newCoins);
    state = state.copyWith(coins: newCoins);
  }

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }
}
