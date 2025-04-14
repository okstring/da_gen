
import 'package:da_gen/data/data_sources/template_data_source.dart';
import 'package:da_gen/data/utils/string_utils.dart';

/// 템플릿 생성 구현체
class TemplateDataSourceImpl implements TemplateDataSource {
  /// DataSource 템플릿을 생성합니다.
  @override
  String generateDataSourceTemplate({required String modelName}) {
    return '''
abstract interface class ${modelName}DataSource {

}
''';
  }

  /// DataSource 구현 템플릿을 생성합니다.
  @override
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

  /// DTO 템플릿을 생성합니다.
  @override
  String generateDtoTemplate({
    required String modelName,
    required bool useJson,
  }) {
    final String snakeCaseModelName = modelName.pascalOrCamelToSnake();

    if (useJson) {
      return '''
import 'package:json_annotation/json_annotation.dart';

part '${snakeCaseModelName}_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ${modelName}Dto {
  
  
  ${modelName}Dto();
  
  factory ${modelName}Dto.fromJson(Map<String, dynamic> json) => _\$${modelName}DtoFromJson(json);
  
  Map<String, dynamic> toJson() => _\$${modelName}DtoToJson(this);
}
''';
    } else {
      return '''
class ${modelName}Dto {

}
''';
    }
  }

  /// Mapper 템플릿을 생성합니다.
  @override
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

  /// Model 템플릿을 생성합니다.
  @override
  String generateModelTemplate({
    required String modelName,
    required bool useFreezed,
  }) {
    final String snakeCaseModelName = modelName.pascalOrCamelToSnake();

    if (useFreezed) {
      return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$snakeCaseModelName.freezed.dart';

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

  /// Repository 템플릿을 생성합니다.
  @override
  String generateRepositoryTemplate({required String modelName}) {
    return '''
abstract interface class ${modelName}Repository {

}
''';
  }

  /// Repository 구현 템플릿을 생성합니다.
  @override
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
}