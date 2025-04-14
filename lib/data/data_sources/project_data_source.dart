/// 프로젝트 구조 정보에 접근하기 위한 데이터소스 인터페이스
abstract interface class ProjectDataSource {
  /// 프로젝트 루트 디렉토리(pubspec.yaml이 있는 디렉토리)를 찾습니다.
  String findProjectRoot();

  /// 패키지명을 추출합니다.
  String getPackageName(String projectRoot);
}