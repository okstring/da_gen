/// DataSource 템플릿을 생성합니다.
String generateDataSourceTemplate({required String modelName}) {
  return '''
abstract interface class ${modelName}DataSource {

}
''';
}