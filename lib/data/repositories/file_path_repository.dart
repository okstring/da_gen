
import 'package:da_gen/data/model/da_gen_file_type.dart';
import 'package:da_gen/data/model/file_info.dart';

/// 파일 경로 관리를 담당하는 리포지토리 인터페이스
abstract interface class FilePathRepository {
  /// 주어진 모델명과 유형에 따른 파일 정보를 생성합니다.
  List<FileInfo> createFileInfos({
    required String modelName,
    required String projectRootPath,
    required String baseDir,
    required bool isFlat,
  });

  /// 주어진 파일 경로에 대한 상대 경로를 계산합니다.
  String calculateRelativeImportPath(String fromPath, String toPath);

  /// 의존성 파일들에 대한 import 문자열을 생성합니다.
  String generateImportsString(
    FileInfo fileInfo,
    Map<DaGenFileType, String> typeToPathMap,
  );
}
