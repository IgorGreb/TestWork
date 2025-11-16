class BoardPosition {
  final int row;
  final int col;
  const BoardPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardPosition && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}
