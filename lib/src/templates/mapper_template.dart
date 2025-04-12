/// Mapper 템플릿을 생성합니다.
String generateMapperTemplate(
    String modelName,
    String modelImport,
    String dtoImport,
    ) {
  return '''
import 'package:$modelImport';
import 'package:$dtoImport';

extension ${modelName}Mapper on ${modelName}Dto {
  ${modelName} to${modelName}() {
    return ${modelName}();
  }
}
''';
}