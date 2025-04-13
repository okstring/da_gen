/// Mapper 템플릿을 생성합니다.
String generateMapperTemplate({
  required String modelName,
  required String importString,
}) {
  return '''
$importString

extension ${modelName}Mapper on ${modelName}Dto {
  $modelName to$modelName() {
    return $modelName();
  }
}
''';
}
