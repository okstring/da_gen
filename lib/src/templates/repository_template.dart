/// Repository 템플릿을 생성합니다.
String generateRepositoryTemplate({required String modelName}) {
  return '''
abstract interface class ${modelName}Repository {

}
''';
}