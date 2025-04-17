import 'package:da_gen/data/data_sources/template_data_source.dart';
import 'package:da_gen/domain/repositories/template_repository.dart';

/// 템플릿 리포지토리 구현체
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateDataSource _dataSource;

  TemplateRepositoryImpl(this._dataSource);

  /// DataSource 템플릿을 생성합니다.
  @override
  String generateDataSourceTemplate({required String modelName}) {
    return _dataSource.generateDataSourceTemplate(modelName: modelName);
  }

  /// DataSource 구현 템플릿을 생성합니다.
  @override
  String generateDataSourceImplTemplate({
    required String modelName,
    required String importString,
  }) {
    return _dataSource.generateDataSourceImplTemplate(
      modelName: modelName,
      importString: importString,
    );
  }

  /// DTO 템플릿을 생성합니다.
  @override
  String generateDtoTemplate({
    required String modelName,
    required bool useJson,
  }) {
    return _dataSource.generateDtoTemplate(
      modelName: modelName,
      useJson: useJson,
    );
  }

  /// Mapper 템플릿을 생성합니다.
  @override
  String generateMapperTemplate({
    required String modelName,
    required String importString,
  }) {
    return _dataSource.generateMapperTemplate(
      modelName: modelName,
      importString: importString,
    );
  }

  /// Model 템플릿을 생성합니다.
  @override
  String generateModelTemplate({
    required String modelName,
    required bool useFreezed,
  }) {
    return _dataSource.generateModelTemplate(
      modelName: modelName,
      useFreezed: useFreezed,
    );
  }

  /// Repository 템플릿을 생성합니다.
  @override
  String generateRepositoryTemplate({required String modelName}) {
    return _dataSource.generateRepositoryTemplate(modelName: modelName);
  }

  /// Repository 구현 템플릿을 생성합니다.
  @override
  String generateRepositoryImplTemplate({
    required String modelName,
    required String importString,
  }) {
    return _dataSource.generateRepositoryImplTemplate(
      modelName: modelName,
      importString: importString,
    );
  }
}
