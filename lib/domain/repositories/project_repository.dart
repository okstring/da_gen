/// 프로젝트 구조와 관련된 작업을 위한 리포지토리 인터페이스
abstract interface class ProjectRepository {
  /// 프로젝트 루트 디렉토리(pubspec.yaml이 있는 디렉토리)를 찾습니다.
  String findProjectRoot();

  /// 패키지명을 추출합니다.
  String getPackageName(String projectRoot);
}
