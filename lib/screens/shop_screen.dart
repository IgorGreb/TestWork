import 'package:chick_game_prototype/features/shop/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopControllerProvider);
    final notifier = ref.read(shopControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coins: ${shopState.coins}'),
                Text(
                  shopState.equippedId != null
                      ? 'Equipped: ${shopState.equippedId}'
                      : '',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = defaultShopItems[index];
                  final owned = shopState.ownedIds.contains(item.id);
                  final equipped = shopState.equippedId == item.id;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item.assetPath),
                      ),
                      title: Text(item.id),
                      subtitle: Text('${item.price} Coins'),
                      trailing: ElevatedButton(
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
                                    ? 'Item purchased!'
                                    : 'Not enough coins',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          owned ? (equipped ? 'Equipped' : 'Equip') : 'Buy',
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemCount: defaultShopItems.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
