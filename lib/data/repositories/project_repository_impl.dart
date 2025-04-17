import 'package:da_gen/data/data_sources/project_data_source.dart';
import 'package:da_gen/domain/repositories/project_repository.dart';

/// 프로젝트 리포지토리 구현체
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource _dataSource;

  ProjectRepositoryImpl(this._dataSource);

  /// 프로젝트 루트 디렉토리(pubspec.yaml이 있는 디렉토리)를 찾습니다.
  @override
  String findProjectRoot() {
    return _dataSource.findProjectRoot();
  }

  /// 패키지명을 추출합니다.
  @override
  String getPackageName(String projectRoot) {
    return _dataSource.getPackageName(projectRoot);
  }
}
