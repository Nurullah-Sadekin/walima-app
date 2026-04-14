
class CamelCaseUtils {
  static String formatCamelCase(String? input) {
    if (input == null || input.isEmpty) return '';

    String cleaned = input.replaceAll('_', ' ');
    return cleaned.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
