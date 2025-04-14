/// 파일 생성 종류 열거형 타입
enum DaGenFileType {
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
      case DaGenFileType.dataSource:
        return "data_source";
      case DaGenFileType.dataSourceImpl:
        return "data_source_impl";
      case DaGenFileType.dto:
        return "dto";
      case DaGenFileType.mapper:
        return "mapper";
      case DaGenFileType.model:
        return "model";
      case DaGenFileType.repository:
        return "repository";
      case DaGenFileType.repositoryImpl:
        return "repository_impl";
    }
  }

  String get suffixNameWithExt {
    return '${toString()}.dart';
  }

  String getFileName({required String snakeCaseModelName}) {
    return "${snakeCaseModelName}_$suffixNameWithExt";
  }

  List<DaGenFileType> get dependencies {
    switch (this) {
      case DaGenFileType.dataSourceImpl:
        return [DaGenFileType.dataSource];
      case DaGenFileType.repositoryImpl:
        return [DaGenFileType.repository, DaGenFileType.dataSource];
      case DaGenFileType.mapper:
        return [DaGenFileType.model, DaGenFileType.dto];
      default:
        return [];
    }
  }
}