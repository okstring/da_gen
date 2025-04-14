/// 파일 생성을 담당하는 리포지토리 인터페이스
abstract interface class FileGeneratorRepository {
  /// 모델 관련 파일들을 생성합니다.
  void generateFiles({
    required String modelName,
    required String baseDirName,
    required bool isFlat,
    required bool useFreezed,
    required bool useJson,
  });
}