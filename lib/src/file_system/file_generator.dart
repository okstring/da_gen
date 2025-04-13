import 'package:arch_gen/src/file_system/arch_gen_file.dart';
import 'package:arch_gen/src/file_system/file_system_manager.dart';
import 'package:arch_gen/src/file_system/project_finder.dart';
import 'package:arch_gen/src/file_system/types/arch_gen_file_type.dart';
import 'package:arch_gen/src/templates/data_source_impl_template.dart';
import 'package:arch_gen/src/templates/data_source_template.dart';
import 'package:arch_gen/src/templates/dto_template.dart';
import 'package:arch_gen/src/templates/mapper_template.dart';
import 'package:arch_gen/src/templates/model_template.dart';
import 'package:arch_gen/src/templates/repository_impl_template.dart';
import 'package:arch_gen/src/templates/repository_template.dart';

/// 파일 생성을 담당하는 클래스
class FileGenerator {
  final ProjectFinder _projectFinder;
  final FileSystemManager _fileSystemManager;
  static const baseDirName = 'lib';

  FileGenerator({
    ProjectFinder? projectFinder,
    FileSystemManager? fileSystemManager,
  })  : _projectFinder = projectFinder ?? ProjectFinder(),
        _fileSystemManager = fileSystemManager ?? FileSystemManager();

  /// 모델 관련 파일들을 생성합니다.
  void generateFiles({
    required String modelName,
    String baseDirName = baseDirName,
    required bool isFlat,
    required bool useFreezed,
    required bool useJson,
  }) {
    // 프로젝트 루트 디렉토리 찾기
    final String projectRoot = _projectFinder.findProjectRoot();

    final archGenFilesType = ArchGenFileType.values
        .map((e) => ArchGenFile(
            type: e,
            modelName: modelName,
            projectRootPath: projectRoot,
            baseDir: baseDirName,
            isFlat: isFlat))
        .toList();

    // 필요한 모든 디렉토리들 선언
    final Set<String> archGenFilesDir =
        archGenFilesType.map((e) => e.directoryPath).toSet();

    // 디렉토리 없으면 생성
    for (var directoryPath in archGenFilesDir) {
      _fileSystemManager.createDirectoryIfNotExists(path: directoryPath);
    }

    for (final archGenFile in archGenFilesType) {
      final String contents;
      final String pascalCaseName = archGenFile.pascalCaseName;
      final String importString = archGenFile.getImportsString((targetType) {
        final targetFilePath =
            archGenFilesType.firstWhere((e) => e.type == targetType).filePath;
        return archGenFile.relativeImportPath(targetFilePath);
      });

      switch (archGenFile.type) {
        case ArchGenFileType.dataSource:
          contents = generateDataSourceTemplate(modelName: pascalCaseName);
          break;
        case ArchGenFileType.dataSourceImpl:
          contents = generateDataSourceImplTemplate(
              modelName: pascalCaseName, importString: importString);
          break;
        case ArchGenFileType.dto:
          contents =
              generateDtoTemplate(modelName: pascalCaseName, useJson: useJson);
          break;
        case ArchGenFileType.mapper:
          contents = generateMapperTemplate(
              modelName: pascalCaseName, importString: importString);
          break;
        case ArchGenFileType.model:
          contents = generateModelTemplate(
              modelName: pascalCaseName, useFreezed: useFreezed);
          break;
        case ArchGenFileType.repository:
          contents = generateRepositoryTemplate(modelName: pascalCaseName);
          break;
        case ArchGenFileType.repositoryImpl:
          contents = generateRepositoryImplTemplate(
              modelName: pascalCaseName, importString: importString);
          break;
      }

      _fileSystemManager.createFile(
          path: archGenFile.filePath, content: contents);
    }
  }
}
