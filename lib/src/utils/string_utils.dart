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