/// DataSource 구현 템플릿을 생성합니다.
String generateDataSourceImplTemplate(
    String modelName,
    String dataSourceImport,
    ) {
  return '''
import '$dataSourceImport';

class ${modelName}DataSourceImpl implements ${modelName}DataSource {
  
}
''';
}