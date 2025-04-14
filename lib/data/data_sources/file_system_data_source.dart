/// 파일 시스템 액세스를 위한 데이터소스 인터페이스
abstract interface class FileSystemDataSource {
  /// 디렉토리가 없으면 생성합니다.
  void createDirectoryIfNotExists({required String path});

  /// 파일을 생성합니다.
  void createFile({required String path, required String content});
}