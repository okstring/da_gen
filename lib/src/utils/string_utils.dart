/// 문자열의 첫 글자를 대문자로 변환합니다.
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

/// 문자열의 첫 글자를 소문자로 변환합니다.
String uncapitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toLowerCase() + text.substring(1);
}

/// CamelCase를 snake_case로 변환합니다.
/// 예: "UserDetail" -> "user_detail"
String camelToSnake(String text) {
  if (text.isEmpty) return text;

  // 첫 글자를 소문자로 변환
  String result = text[0].toLowerCase();

  // 나머지 문자열을 순회하면서 대문자 앞에 언더스코어 추가
  for (int i = 1; i < text.length; i++) {
    final char = text[i];
    if (char == char.toUpperCase() && char != char.toLowerCase()) {
      // 현재 문자가 대문자인 경우
      result += '_${char.toLowerCase()}';
    } else {
      result += char;
    }
  }

  return result;
}