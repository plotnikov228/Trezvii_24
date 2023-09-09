extension DoubleExtension on double {
  double prettify() =>
      // toStringAsFixed guarantees the specified number of fractional
  // digits, so the regular expression is simpler than it would need to
  // be for more general cases.
  double.parse(toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), ''));

}