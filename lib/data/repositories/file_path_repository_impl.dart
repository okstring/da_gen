import 'dart:io';

import 'package:da_gen/data/model/da_gen_file_type.dart';
import 'package:da_gen/data/model/file_info.dart';
import 'package:da_gen/data/repositories/file_path_repository.dart';
import 'package:da_gen/data/utils/string_utils.dart';
import 'package:path/path.dart' as path;

/// 파일 경로 리포지토리 구현체
class FilePathRepositoryImpl implements FilePathRepository {
  /// 주어진 모델명과 유형에 따른 파일 정보를 생성합니다.
  @override
  List<FileInfo> createFileInfos({
    required String modelName,
    required String projectRootPath,
    required String baseDir,
    required bool isFlat,
  }) {
    return DaGenFileType.values.map((type) {
      final String directoryPath = _calculateDirectoryPath(
        type: type,
        isFlat: isFlat,
        projectRootPath: projectRootPath,
        baseDir: baseDir,
      );

      final String snakeCaseModelName = modelName.pascalOrCamelToSnake();
      final String fileName =
          type.getFileName(snakeCaseModelName: snakeCaseModelName);
      final String filePath = path.join(directoryPath, fileName);

      return FileInfo(
        type: type,
        modelName: modelName,
        directoryPath: directoryPath,
        filePath: filePath,
        dependencies: type.dependencies,
      );
    }).toList();
  }

  /// 주어진 파일 경로에 대한 상대 경로를 계산합니다.
  @override
  String calculateRelativeImportPath(String fromPath, String toPath) {
    // 현재 파일의 디렉토리
    String fromDir = path.dirname(fromPath);

    // 상대 경로 계산
    String relativePath = path.relative(toPath, from: fromDir);

    // 시작이 . 또는 .. 이 아니면 ./ 추가
    if (!relativePath.startsWith('.')) {
      relativePath = './$relativePath';
    }

    return relativePath;
  }

  /// 의존성 파일들에 대한 import 문자열을 생성합니다.
  @override
  String generateImportsString(
    FileInfo fileInfo,
    Map<DaGenFileType, String> typeToPathMap,
  ) {
    if (fileInfo.dependencies.isEmpty) {
      return '';
    }

    return fileInfo.dependencies.map((dependencyType) {
      final String dependencyPath = typeToPathMap[dependencyType] ?? '';
      final String relativePath = calculateRelativeImportPath(
        fileInfo.filePath,
        dependencyPath,
      );
      return "import '$relativePath';";
    }).join('\n');
  }

  /// 파일 유형에 따른 디렉토리 경로를 계산합니다.
  String _calculateDirectoryPath({
    required DaGenFileType type,
    required bool isFlat,
    required String projectRootPath,
    required String baseDir,
  }) {
    String directoryPath;

    if (isFlat) {
      // flat 옵션이 활성화된 경우 현재 디렉토리를 기준으로 함
      directoryPath = Directory.current.path;
    } else {
      // flat 옵션이 비활성화된 경우 프로젝트 루트의 lib 디렉토리를 기준으로 함
      directoryPath = path.join(projectRootPath, baseDir);
    }

    if (isFlat) {
      return directoryPath;
    }

    switch (type) {
      // DataSource 폴더
      case DaGenFileType.dataSource:
      case DaGenFileType.dataSourceImpl:
        return path.join(directoryPath, 'data', 'data_source');

      // Dto 폴더
      case DaGenFileType.dto:
        return path.join(directoryPath, 'data', 'dto');

      // Mapper 폴더
      case DaGenFileType.mapper:
        return path.join(directoryPath, 'data', 'mapper');

      // Model 폴더
      case DaGenFileType.model:
        return path.join(directoryPath, 'data', 'model');

      // Repository 폴더
      case DaGenFileType.repository:
        return path.join(directoryPath, 'data', 'repository');

      // Repository 구현체 폴더
      case DaGenFileType.repositoryImpl:
        return path.join(directoryPath, 'data', 'repository');
    }
  }
}
