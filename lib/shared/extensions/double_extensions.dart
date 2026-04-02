extension DoubleX on double {
  String toAmountString({int decimalPlaces = 2}) =>
      toStringAsFixed(decimalPlaces);

  bool get isNegative => this < 0;
  bool get isPositive => this > 0;

  double get absolute => abs();
}
