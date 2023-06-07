


class Formater {

  static String spaceSeparateNumbers(String rawNum) {
    final result = rawNum.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
  }

}