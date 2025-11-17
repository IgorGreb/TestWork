import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/features/shop/shop_controller.dart';
import 'package:chick_game_prototype/features/shop/shop_state.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  Future<bool> _handleBack(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopControllerProvider);
    final notifier = ref.read(shopControllerProvider.notifier);

    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackBtnLayout(onPressed: () => _handleBack(context)),
                ),
                const SizedBox(height: 12),
                _CoinsBadge(coins: shopState.coins),
                const SizedBox(height: 12),
                Expanded(
                  child: FlamePanel(
                    title: 'SHOP',
                    child: ListView.separated(
                      itemCount: defaultShopItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = defaultShopItems[index];
                        final owned = shopState.ownedIds.contains(item.id);
                        final equipped = shopState.equippedId == item.id;
                        return _ShopCard(
                          item: item,
                          owned: owned,
                          equipped: equipped,
                          onPressed: () async {
                            final success =
                                owned
                                    ? await notifier.equip(item.id)
                                    : await notifier.purchase(item);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? (owned ? 'Equipped!' : 'Purchased!')
                                      : 'Not enough coins',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoinsBadge extends StatelessWidget {
  const _CoinsBadge({required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC93C), Color(0xFFFF9800)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            coins.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.onPressed,
  });

  final ShopItem item;
  final bool owned;
  final bool equipped;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final statusText = owned ? (equipped ? 'EQUIPPED' : 'EQUIP') : 'BUY';
    final colors =
        owned
            ? (equipped
                ? const [Color(0xFF64FFDA), Color(0xFF26A69A)]
                : const [Color(0xFFFF8BD7), Color(0xFFF144D6)])
            : const [Color(0xFF7E57C2), Color(0xFF512DA8)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF4C1150).withOpacity(0.4),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24, width: 2),
              image: DecorationImage(
                image: AssetImage(item.assetPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price} COINS',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 110,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: colors.first,
                foregroundColor: Colors.white,
              ),
              onPressed: onPressed,
              child: Text(
                statusText,
                style: const TextStyle(letterSpacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
