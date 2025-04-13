import 'dart:io';

/// 파일 시스템 작업을 처리하는 클래스
class FileSystemManager {
  /// 디렉토리가 없으면 생성합니다.
  void createDirectoryIfNotExists({required String path}) {
    final Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  /// 파일을 생성합니다.
  void createFile({required String path, required String content}) {
    final File file = File(path);
    file.writeAsStringSync(content);
    print('생성됨: $path');
  }
}
