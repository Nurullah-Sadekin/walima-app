
class HeightUtils {
  static String formatHeight(String? input) {
    if (input == null || input.isEmpty) return '';

    // Extract numeric value (handle "170", "170 cm", "170cm")
    String cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return '';

    double? cm = double.tryParse(cleaned);
    if (cm == null) return '';

    // Convert cm to feet and inches
    int totalInches = (cm / 2.54).round();
    int feet = totalInches ~/ 12;
    int inches = totalInches % 12;

    return "$feet' $inches\" ($cm cm)";
  }
}
