/// Model 템플릿을 생성합니다.
String generateModelTemplate(
    String modelName,
    bool useFreezed,
    ) {
  if (useFreezed) {
    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${modelName.toLowerCase()}.freezed.dart';

@freezed
abstract class $modelName with _\$$modelName {
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