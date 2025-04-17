import 'package:da_gen/data/model/da_gen_file_type.dart';
import 'package:da_gen/data/model/file_info.dart';
import 'package:da_gen/data/repositories/file_generator_repository.dart';
import 'package:da_gen/data/repositories/file_path_repository.dart';
import 'package:da_gen/data/repositories/file_system_repository.dart';
import 'package:da_gen/data/repositories/project_repository.dart';
import 'package:da_gen/data/repositories/template_repository.dart';

/// 파일 생성 리포지토리 구현체
class FileGeneratorRepositoryImpl implements FileGeneratorRepository {
  final ProjectRepository _projectRepository;
  final FilePathRepository _filePathRepository;
  final FileSystemRepository _fileSystemRepository;
  final TemplateRepository _templateRepository;

  FileGeneratorRepositoryImpl({
    required ProjectRepository projectRepository,
    required FilePathRepository filePathRepository,
    required FileSystemRepository fileSystemRepository,
    required TemplateRepository templateRepository,
  })  : _projectRepository = projectRepository,
        _filePathRepository = filePathRepository,
        _fileSystemRepository = fileSystemRepository,
        _templateRepository = templateRepository;

  /// 모델 관련 파일들을 생성합니다.
  @override
  void generateFiles({
    required String modelName,
    required String baseDirName,
    required bool isFlat,
    required bool useFreezed,
    required bool useJson,
  }) {
    // 프로젝트 루트 디렉토리 찾기
    final String projectRoot = _projectRepository.findProjectRoot();

    // 파일 정보 생성
    final List<FileInfo> fileInfos = _filePathRepository.createFileInfos(
      modelName: modelName,
      projectRootPath: projectRoot,
      baseDir: baseDirName,
      isFlat: isFlat,
    );

    // 필요한 모든 디렉토리들 선언
    final Set<String> directories =
        fileInfos.map((e) => e.directoryPath).toSet();

    // 디렉토리 없으면 생성
    for (var directoryPath in directories) {
      _fileSystemRepository.createDirectoryIfNotExists(path: directoryPath);
    }

    // 파일 유형별 경로 맵 생성
    final Map<DaGenFileType, String> typeToPathMap = {};
    for (var fileInfo in fileInfos) {
      typeToPathMap[fileInfo.type] = fileInfo.filePath;
    }

    // 각 파일 생성
    for (final fileInfo in fileInfos) {
      final String contents;
      final String pascalCaseName = modelName;
      final String importString = _filePathRepository.generateImportsString(
        fileInfo,
        typeToPathMap,
      );

      switch (fileInfo.type) {
        case DaGenFileType.dataSource:
          contents = _templateRepository.generateDataSourceTemplate(
            modelName: pascalCaseName,
          );
          break;
        case DaGenFileType.dataSourceImpl:
          contents = _templateRepository.generateDataSourceImplTemplate(
            modelName: pascalCaseName,
            importString: importString,
          );
          break;
        case DaGenFileType.dto:
          contents = _templateRepository.generateDtoTemplate(
            modelName: pascalCaseName,
            useJson: useJson,
          );
          break;
        case DaGenFileType.mapper:
          contents = _templateRepository.generateMapperTemplate(
            modelName: pascalCaseName,
            importString: importString,
          );
          break;
        case DaGenFileType.model:
          contents = _templateRepository.generateModelTemplate(
            modelName: pascalCaseName,
            useFreezed: useFreezed,
          );
          break;
        case DaGenFileType.repository:
          contents = _templateRepository.generateRepositoryTemplate(
            modelName: pascalCaseName,
          );
          break;
        case DaGenFileType.repositoryImpl:
          contents = _templateRepository.generateRepositoryImplTemplate(
            modelName: pascalCaseName,
            importString: importString,
          );
          break;
      }

      _fileSystemRepository.createFile(
        path: fileInfo.filePath,
        content: contents,
      );
    }
  }
}
