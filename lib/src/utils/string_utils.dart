extension StringExtensions on String {
  /// 문자열의 첫 글자를 대문자로 변환합니다.
  String uppercaseFirst() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  /// 문자열의 첫 글자를 소문자로 변환합니다.
  String lowercaseFirst() {
    if (isEmpty) {
      return this;
    }
    return this[0].toLowerCase() + substring(1);
  }

  /// PascalCase나 camelCase를 snake_case로 변환합니다.
  /// 예: "UserDetail" -> "user_detail", "userDetail" -> "user_detail"
  String pascalOrCamelToSnake() {
    if (isEmpty) {
      return this;
    }

    // 첫 글자를 소문자로 변환
    String result = this[0].toLowerCase();

    // 나머지 문자열을 순회하면서 대문자 앞에 언더스코어 추가
    for (int i = 1; i < length; i++) {
      final char = this[i];
      if (char == char.toUpperCase() && char != char.toLowerCase()) {
        // 현재 문자가 대문자인 경우
        result += '_${char.toLowerCase()}';
      } else {
        result += char;
      }
    }

    return result;
  }
}