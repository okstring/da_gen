import 'dart:io';

import 'package:da_gen/data/data_sources/file_system_data_source.dart';

/// 파일 시스템 액세스 구현체
class FileSystemDataSourceImpl implements FileSystemDataSource {
  /// 디렉토리가 없으면 생성합니다.
  @override
  void createDirectoryIfNotExists({required String path}) {
    final Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  /// 파일을 생성합니다.
  @override
  void createFile({required String path, required String content}) {
    final File file = File(path);
    file.writeAsStringSync(content);
    print('생성됨: $path');
  }
}
