import 'dart:io';

import 'package:arch_gen/src/file_system/file_system_manager.dart';
import 'package:arch_gen/src/file_system/path_calculator.dart';
import 'package:arch_gen/src/file_system/project_finder.dart';
import 'package:arch_gen/src/templates/data_source_impl_template.dart';
import 'package:arch_gen/src/templates/data_source_template.dart';
import 'package:arch_gen/src/templates/dto_template.dart';
import 'package:arch_gen/src/templates/mapper_template.dart';
import 'package:arch_gen/src/templates/model_template.dart';
import 'package:arch_gen/src/templates/repository_impl_template.dart';
import 'package:arch_gen/src/templates/repository_template.dart';
import 'package:arch_gen/src/utils/string_utils.dart';
import 'package:path/path.dart' as path;

/// 모델 관련 파일들을 생성하는 클래스
class FileGenerator {
  final ProjectFinder _projectFinder;
  final FileSystemManager _fileSystemManager;
  final PathCalculator _pathCalculator;

  FileGenerator({
    ProjectFinder? projectFinder,
    FileSystemManager? fileSystemManager,
    PathCalculator? pathCalculator,
  }) :
        _projectFinder = projectFinder ?? ProjectFinder(),
        _fileSystemManager = fileSystemManager ?? FileSystemManager(),
        _pathCalculator = pathCalculator ?? PathCalculator();

  /// 모델 관련 파일들을 생성합니다.
  void generateFiles({
    required String modelName,
    String baseDir = 'lib',
    required bool isFlat,
    required bool useFreezed,
    required bool useJson,
  }) {
    // 모델명 변환
    final String capitalizedModelName = modelName.uppercaseFirst();
    final String snakeCaseModelName = modelName.camelToSnake();

    // 프로젝트 루트 디렉토리 찾기
    final String projectRoot = _projectFinder.findProjectRoot();
    if (projectRoot.isEmpty) {
      print('오류: 프로젝트 루트 디렉토리를 찾을 수 없습니다. pubspec.yaml 파일이 있는 디렉토리에서 실행하세요.');
      exit(1);
    }

    print('프로젝트 루트 디렉토리: $projectRoot');

    // 프로젝트 패키지명 추출
    final String packageName = _projectFinder.getPackageName(projectRoot);

    // 파일 생성 경로 설정
    String baseDirectory;
    if (isFlat) {
      // flat 옵션이 활성화된 경우 현재 디렉토리를 기준으로 함
      baseDirectory = Directory.current.path;
    } else {
      // flat 옵션이 비활성화된 경우 프로젝트 루트의 lib 디렉토리를 기준으로 함
      baseDirectory = path.join(projectRoot, 'lib');
    }

    print('파일 생성 기준 디렉토리: $baseDirectory');

    // 각 파일 타입별 경로 설정
    final String dataSourcePath = isFlat
        ? baseDirectory
        : path.join(baseDirectory, 'data', 'data_source');
    final String dtoPath = isFlat
        ? baseDirectory
        : path.join(baseDirectory, 'data', 'dto');
    final String mapperPath = isFlat
        ? baseDirectory
        : path.join(baseDirectory, 'data', 'mapper');
    final String modelPath = isFlat
        ? baseDirectory
        : path.join(baseDirectory, 'data', 'model');
    final String repositoryPath = isFlat
        ? baseDirectory
        : path.join(baseDirectory, 'data', 'repository');

    // 디렉토리 생성
    _fileSystemManager.createDirectoryIfNotExists(dataSourcePath);
    _fileSystemManager.createDirectoryIfNotExists(dtoPath);
    _fileSystemManager.createDirectoryIfNotExists(mapperPath);
    _fileSystemManager.createDirectoryIfNotExists(modelPath);
    _fileSystemManager.createDirectoryIfNotExists(repositoryPath);

    // 파일명 생성 (snake_case 사용)
    final String dataSourceFile = path.join(dataSourcePath, '${snakeCaseModelName}_data_source.dart');
    final String dataSourceImplFile = path.join(dataSourcePath, '${snakeCaseModelName}_data_source_impl.dart');
    final String dtoFile = path.join(dtoPath, '${snakeCaseModelName}_dto.dart');
    final String mapperFile = path.join(mapperPath, '${snakeCaseModelName}_mapper.dart');
    final String modelFile = path.join(modelPath, '$snakeCaseModelName.dart');
    final String repositoryFile = path.join(repositoryPath, '${snakeCaseModelName}_repository.dart');
    final String repositoryImplFile = path.join(repositoryPath, '${snakeCaseModelName}_repository_impl.dart');

    // 타겟 파일들의 임포트 경로 계산
    Map<String, String> imports = _calculateImports(
      dataSourceFile: dataSourceFile,
      dataSourceImplFile: dataSourceImplFile,
      repositoryFile: repositoryFile,
      repositoryImplFile: repositoryImplFile,
      modelFile: modelFile,
      dtoFile: dtoFile,
      mapperFile: mapperFile,
    );

    // 파일 생성
    _createModelFiles(
      capitalizedModelName: capitalizedModelName,
      imports: imports,
      dataSourceFile: dataSourceFile,
      dataSourceImplFile: dataSourceImplFile,
      dtoFile: dtoFile,
      mapperFile: mapperFile,
      modelFile: modelFile,
      repositoryFile: repositoryFile,
      repositoryImplFile: repositoryImplFile,
      useFreezed: useFreezed,
      useJson: useJson,
    );
  }

  // 타겟 파일들의 임포트 경로 계산
  Map<String, String> _calculateImports({
    required String dataSourceFile,
    required String dataSourceImplFile,
    required String repositoryFile,
    required String repositoryImplFile,
    required String modelFile,
    required String dtoFile,
    required String mapperFile,
  }) {
    Map<String, String> imports = {};

    // DataSourceImpl -> DataSource 임포트
    imports['dataSourceToImpl'] = _pathCalculator.calculateRelativeImportPath(
        dataSourceFile,
        dataSourceImplFile
    );

    // RepositoryImpl -> Repository, DataSource 임포트
    imports['repositoryToImpl'] = _pathCalculator.calculateRelativeImportPath(
        repositoryFile,
        repositoryImplFile
    );
    imports['dataSourceToRepoImpl'] = _pathCalculator.calculateRelativeImportPath(
        dataSourceFile,
        repositoryImplFile
    );

    // Mapper -> Model, DTO 임포트
    imports['modelToMapper'] = _pathCalculator.calculateRelativeImportPath(
        modelFile,
        mapperFile
    );
    imports['dtoToMapper'] = _pathCalculator.calculateRelativeImportPath(
        dtoFile,
        mapperFile
    );

    return imports;
  }

  // 모델 관련 파일들을 생성하는 메서드
  void _createModelFiles({
    required String capitalizedModelName,
    required Map<String, String> imports,
    required String dataSourceFile,
    required String dataSourceImplFile,
    required String dtoFile,
    required String mapperFile,
    required String modelFile,
    required String repositoryFile,
    required String repositoryImplFile,
    required bool useFreezed,
    required bool useJson,
  }) {
    _fileSystemManager.createFile(
      dataSourceFile,
      generateDataSourceTemplate(capitalizedModelName),
    );

    _fileSystemManager.createFile(
      dataSourceImplFile,
      generateDataSourceImplTemplate(
        capitalizedModelName,
        imports['dataSourceToImpl']!,
      ),
    );

    _fileSystemManager.createFile(
      dtoFile,
      generateDtoTemplate(
        capitalizedModelName,
        useJson,
      ),
    );

    _fileSystemManager.createFile(
      mapperFile,
      generateMapperTemplate(
        capitalizedModelName,
        imports['modelToMapper']!,
        imports['dtoToMapper']!,
      ),
    );

    _fileSystemManager.createFile(
      modelFile,
      generateModelTemplate(
        capitalizedModelName,
        useFreezed,
      ),
    );

    _fileSystemManager.createFile(
      repositoryFile,
      generateRepositoryTemplate(capitalizedModelName),
    );

    _fileSystemManager.createFile(
      repositoryImplFile,
      generateRepositoryImplTemplate(
        capitalizedModelName,
        imports['repositoryToImpl']!,
        imports['dataSourceToRepoImpl']!,
      ),
    );
  }
}
