import 'package:arch_gen/src/utils/string_utils.dart';

/// Repository 구현 템플릿을 생성합니다.
String generateRepositoryImplTemplate({
  required String modelName,
  required String importString,
}) {
  final String camelCaseName = modelName.lowercaseFirst();

  return '''
$importString

class ${modelName}RepositoryImpl implements ${modelName}Repository {
  final ${modelName}DataSource _${camelCaseName}DataSource;

  const ${modelName}RepositoryImpl({
    required ${modelName}DataSource ${camelCaseName}DataSource,
  }) : _${camelCaseName}DataSource = ${camelCaseName}DataSource;
}
''';
}