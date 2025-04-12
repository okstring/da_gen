import 'package:arch_gen/src/utils/string_utils.dart';/// Model 템플릿을 생성합니다.
String generateModelTemplate(
    String modelName,
    bool useFreezed,
    ) {
  final String snakeCaseModelName = modelName.camelToSnake();

  if (useFreezed) {
    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$snakeCaseModelName.freezed.dart';

@freezed
abstract class $modelName with _\$modelName {
  const factory $modelName({
    
  }) = _$modelName;
}
''';
  } else {
    return '''
class $modelName {

}
''';
  }
}