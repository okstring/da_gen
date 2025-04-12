import 'package:arch_gen/src/utils/string_utils.dart';/// DTO 템플릿을 생성합니다.
String generateDtoTemplate(
    String modelName,
    bool useJson,
    ) {
  final String snakeCaseModelName = camelToSnake(modelName);

  if (useJson) {
    return '''
import 'package:json_annotation/json_annotation.dart';

part '${snakeCaseModelName}_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ${modelName}Dto {
  
  
  ${modelName}Dto();
  
  factory ${modelName}Dto.fromJson(Map<String, dynamic> json) => _\${modelName}DtoFromJson(json);
  
  Map<String, dynamic> toJson() => _\${modelName}DtoToJson(this);
}
''';
  } else {
    return '''
class ${modelName}Dto {

}
''';
  }
}