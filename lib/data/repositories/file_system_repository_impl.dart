import 'package:da_gen/data/data_sources/file_system_data_source.dart';
import 'package:da_gen/domain/repositories/file_system_repository.dart';

/// 파일 시스템 리포지토리 구현체
class FileSystemRepositoryImpl implements FileSystemRepository {
  final FileSystemDataSource _dataSource;

  FileSystemRepositoryImpl(this._dataSource);

  /// 디렉토리가 없으면 생성합니다.
  @override
  void createDirectoryIfNotExists({required String path}) {
    _dataSource.createDirectoryIfNotExists(path: path);
  }

  /// 파일을 생성합니다.
  @override
  void createFile({required String path, required String content}) {
    _dataSource.createFile(path: path, content: content);
  }
}
