enum GameState {
  buildLevel, playing, win, lose
}

extension GameStateExtension on GameState {
  String get status {
    switch (this) {
      case GameState.win:
        return 'Đã WIN!!';
      case GameState.lose:
        return 'GAME OVER!!!';
      default:
        return '';
    }
  }
}