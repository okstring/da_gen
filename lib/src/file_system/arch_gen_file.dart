import 'dart:io';

import 'package:arch_gen/src/file_system/types/arch_gen_file_type.dart';
import 'package:arch_gen/src/utils/string_utils.dart';
import 'package:path/path.dart' as path;

/// 파일 생성 정보를 담는 클래스
class ArchGenFile {
  final ArchGenFileType _type;
  final String _modelName;
  final String _projectRootPath;
  final String _baseDirName;
  final bool _isFlat;

  ArchGenFile({
    required ArchGenFileType type,
    required String modelName,
    required String projectRootPath,
    required String baseDir,
    required bool isFlat,
  })  : _type = type,
        _modelName = modelName,
        _projectRootPath = projectRootPath,
        _baseDirName = baseDir,
        _isFlat = isFlat;

  ArchGenFileType get type => _type;

  String get pascalCaseName => _modelName.uppercaseFirst();

  String get snakeCaseModelName => _modelName.pascalOrCamelToSnake();

  /// 파일 생성 경로 설정
  String get directoryPath {
    String directoryPath;

    if (_isFlat) {
      // flat 옵션이 활성화된 경우 현재 디렉토리를 기준으로 함
      directoryPath = Directory.current.path;
    } else {
      // flat 옵션이 비활성화된 경우 프로젝트 루트의 lib 디렉토리를 기준으로 함
      directoryPath = path.join(_projectRootPath, _baseDirName);
    }

    switch (_type) {
      // DataSource 폴더
      case ArchGenFileType.dataSource:
      case ArchGenFileType.dataSourceImpl:
        return _isFlat
            ? directoryPath
            : path.join(directoryPath, 'data', 'data_source');

      // Dto 폴더
      case ArchGenFileType.dto:
        return _isFlat
            ? directoryPath
            : path.join(directoryPath, 'data', 'dto');

      // Mapper 폴더
      case ArchGenFileType.mapper:
        return _isFlat
            ? directoryPath
            : path.join(directoryPath, 'data', 'mapper');

      // Model 폴더
      case ArchGenFileType.model:
        return _isFlat
            ? directoryPath
            : path.join(directoryPath, 'data', 'model');

      // Repository 폴더
      case ArchGenFileType.repository:
      case ArchGenFileType.repositoryImpl:
        return _isFlat
            ? directoryPath
            : path.join(directoryPath, 'data', 'repository');
    }
  }

  String get fileName =>
      _type.getFileName(snakeCaseModelName: snakeCaseModelName);

  String get filePath => path.join(directoryPath, fileName);

  /// 상대 경로를 계산합니다.
  String relativeImportPath(String targetFilePath) {
    // 현재 파일의 디렉토리
    String fromDir = directoryPath;

    // 상대 경로 계산
    String relativePath = path.relative(targetFilePath, from: fromDir);

    // 시작이 . 또는 .. 이 아니면 ./ 추가
    if (!relativePath.startsWith('.')) {
      relativePath = './$relativePath';
    }

    return relativePath;
  }

  String getImportsString(
      String Function(ArchGenFileType targetType) pathGenerator) {
    if (type.dependencies.isEmpty) {
      return '';
    } else {
      return type.dependencies
          .map((targetType) => 'import \'${pathGenerator(targetType)}\';')
          .join('\n');
    }
  }
}
