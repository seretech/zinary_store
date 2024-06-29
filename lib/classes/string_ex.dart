extension CapExtension on String {
  String get inCaps => length > 1 ? '${this[0].toUpperCase()}${substring(1)}' : this;
  String get allInCaps => toUpperCase();
}