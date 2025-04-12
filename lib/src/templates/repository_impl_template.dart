/// Repository 구현 템플릿을 생성합니다.
String generateRepositoryImplTemplate(
    String modelName,
    String repositoryImport,
    String dataSourceImport,
    ) {
  final String lowerModelName = modelName[0].toLowerCase() + modelName.substring(1);

  return '''
import '$repositoryImport';
import '$dataSourceImport';

class ${modelName}RepositoryImpl implements ${modelName}Repository {
  final ${modelName}DataSource _${lowerModelName}DataSource;

  const ${modelName}RepositoryImpl({
    required ${modelName}DataSource ${lowerModelName}DataSource,
  }) : _${lowerModelName}DataSource = ${lowerModelName}DataSource;
}
''';
}