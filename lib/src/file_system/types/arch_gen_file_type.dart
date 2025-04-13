/// 파일 생성 종류 열거형 타입
enum ArchGenFileType {
  dataSource,
  dataSourceImpl,
  dto,
  mapper,
  model,
  repository,
  repositoryImpl;

  @override
  String toString() {
    switch (this) {
      case ArchGenFileType.dataSource:
        return "data_source";
      case ArchGenFileType.dataSourceImpl:
        return "data_source_impl";
      case ArchGenFileType.dto:
        return "dto";
      case ArchGenFileType.mapper:
        return "mapper";
      case ArchGenFileType.model:
        return "model";
      case ArchGenFileType.repository:
        return "repository";
      case ArchGenFileType.repositoryImpl:
        return "repository_impl";
    }
  }

  String get suffixNameWithExt {
    return '${toString()}.dart';
  }

  String getFileName({required String snakeCaseModelName}) {
    return "${snakeCaseModelName}_$suffixNameWithExt";
  }

  List<ArchGenFileType> get dependencies {
    switch (this) {
      case ArchGenFileType.dataSourceImpl:
        return [ArchGenFileType.dataSource];
      case ArchGenFileType.repositoryImpl:
        return [ArchGenFileType.repository, ArchGenFileType.dataSource];
      case ArchGenFileType.mapper:
        return [ArchGenFileType.model, ArchGenFileType.dto];
      default:
        return [];
    }
  }
}