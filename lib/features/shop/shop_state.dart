class ShopItem {
  final String id;
  final String assetPath;
  final int price;

  const ShopItem({
    required this.id,
    required this.assetPath,
    required this.price,
  });
}

class ShopState {
  final int coins;
  final String? equippedId;
  final Set<String> ownedIds;

  const ShopState({
    this.coins = 1000,
    this.equippedId,
    this.ownedIds = const {},
  });

  ShopState copyWith({int? coins, String? equippedId, Set<String>? ownedIds}) {
    return ShopState(
      coins: coins ?? this.coins,
      equippedId: equippedId ?? this.equippedId,
      ownedIds: ownedIds ?? this.ownedIds,
    );
  }
}
