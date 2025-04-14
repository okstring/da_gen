import 'package:da_gen/domain/model/da_gen_file_type.dart';

/// 파일 정보를 담는 엔티티 클래스
class FileInfo {
  final DaGenFileType type;
  final String modelName;
  final String directoryPath;
  final String filePath;
  final List<DaGenFileType> dependencies;

  FileInfo({
    required this.type,
    required this.modelName,
    required this.directoryPath,
    required this.filePath,
    required this.dependencies,
  });
}