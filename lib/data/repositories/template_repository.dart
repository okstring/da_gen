/// 템플릿 생성을 담당하는 리포지토리 인터페이스
abstract interface class TemplateRepository {
  /// DataSource 템플릿을 생성합니다.
  String generateDataSourceTemplate({required String modelName});

  /// DataSource 구현 템플릿을 생성합니다.
  String generateDataSourceImplTemplate({
    required String modelName,
    required String importString,
  });

  /// DTO 템플릿을 생성합니다.
  String generateDtoTemplate({
    required String modelName,
    required bool useJson,
  });

  /// Mapper 템플릿을 생성합니다.
  String generateMapperTemplate({
    required String modelName,
    required String importString,
  });

  /// Model 템플릿을 생성합니다.
  String generateModelTemplate({
    required String modelName,
    required bool useFreezed,
  });

  /// Repository 템플릿을 생성합니다.
  String generateRepositoryTemplate({required String modelName});

  /// Repository 구현 템플릿을 생성합니다.
  String generateRepositoryImplTemplate({
    required String modelName,
    required String importString,
  });
}
