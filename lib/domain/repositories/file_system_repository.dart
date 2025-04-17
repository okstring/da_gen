/// 파일 시스템 작업을 처리하는 리포지토리 인터페이스
abstract interface class FileSystemRepository {
  /// 디렉토리가 없으면 생성합니다.
  void createDirectoryIfNotExists({required String path});

  /// 파일을 생성합니다.
  void createFile({required String path, required String content});
}
