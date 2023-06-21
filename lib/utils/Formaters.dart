


class Formater {

  static String spaceSeparateNumbers(String rawNum) {
    final result = rawNum.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
  }

}

extension FormatSpace on double{

  String spaceSeparateNumbers() {
    final result = '$this'.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
  }

  String toMonetaryString(){
    final result = toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
  }
}

extension FormatOrderCounter on int {

  String formatOrderCounter(){
    return "ORD${toRadixString(16).padLeft(6, '0')}";
  }
}