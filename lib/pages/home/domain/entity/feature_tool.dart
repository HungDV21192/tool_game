enum FeatureTool {
  undo, reUndo, area, clear, clearAll, none
}

extension FeatureToolExtension on FeatureTool {
  String get nameDisplay {
    switch (this) {
      case FeatureTool.undo:
        return 'Undo';
      case FeatureTool.reUndo:
        return 'Re Undo';
      case FeatureTool.area:
        return 'Area';
      case FeatureTool.clear:
        return 'Clear';
      case FeatureTool.clearAll:
        return 'Clear all';
      default:
        return '';
    }
  }
}