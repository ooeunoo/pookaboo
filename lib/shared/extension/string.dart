extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  // 파일 확장자 제거
  String extractFileNameWithoutExtension() {
    String fileNameWithExtension = split('/').last;
    String fileNameWithoutExtension = fileNameWithExtension.split('.').first;
    return fileNameWithoutExtension;
  }

  String extractValueFromUrl() {
    List<String> parts = split('?');
    String value = parts.first.split('/').last;
    return value;
  }
}
