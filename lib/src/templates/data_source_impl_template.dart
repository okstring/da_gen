/// DataSource 구현 템플릿을 생성합니다.
String generateDataSourceImplTemplate({
  required String modelName,
  required String importString,
}) {
  return '''
$importString

class ${modelName}DataSourceImpl implements ${modelName}DataSource {
  
}
''';
}
