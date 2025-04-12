import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:arch_gen/src/templates/data_source_template.dart';
import 'package:arch_gen/src/templates/data_source_impl_template.dart';
import 'package:arch_gen/src/templates/dto_template.dart';
import 'package:arch_gen/src/templates/mapper_template.dart';
import 'package:arch_gen/src/templates/model_template.dart';
import 'package:arch_gen/src/templates/repository_template.dart';
import 'package:arch_gen/src/templates/repository_impl_template.dart';
import 'package:arch_gen/src/utils/string_utils.dart';

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
  final String projectRoot = _findProjectRoot();
  if (projectRoot.isEmpty) {
    print('오류: 프로젝트 루트 디렉토리를 찾을 수 없습니다. pubspec.yaml 파일이 있는 디렉토리에서 실행하세요.');
    exit(1);
  }

  print('프로젝트 루트 디렉토리: $projectRoot');

  // 프로젝트 패키지명 추출
  final String packageName = _getPackageName(projectRoot);

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
  _createDirectoryIfNotExists(dataSourcePath);
  _createDirectoryIfNotExists(dtoPath);
  _createDirectoryIfNotExists(mapperPath);
  _createDirectoryIfNotExists(modelPath);
  _createDirectoryIfNotExists(repositoryPath);

  // 파일명 생성 (snake_case 사용)
  final String dataSourceFile = path.join(dataSourcePath, '${snakeCaseModelName}_data_source.dart');
  final String dataSourceImplFile = path.join(dataSourcePath, '${snakeCaseModelName}_data_source_impl.dart');
  final String dtoFile = path.join(dtoPath, '${snakeCaseModelName}_dto.dart');
  final String mapperFile = path.join(mapperPath, '${snakeCaseModelName}_mapper.dart');
  final String modelFile = path.join(modelPath, '$snakeCaseModelName.dart');
  final String repositoryFile = path.join(repositoryPath, '${snakeCaseModelName}_repository.dart');
  final String repositoryImplFile = path.join(repositoryPath, '${snakeCaseModelName}_repository_impl.dart');

  // 임포트 경로 생성에 필요한 함수
  String calculateImportPath(String filePath) {
    // 모든 경우에 상대 경로 사용
    String targetFile = path.basename(filePath);
    String targetDir = path.dirname(filePath);

    // 현재 계산 중인 파일이 어떤 파일인지 확인
    String currentDir;
    if (filePath.contains('data_source_impl')) {
      currentDir = dataSourcePath;
    } else if (filePath.contains('repository_impl')) {
      currentDir = repositoryPath;
    } else if (filePath.contains('mapper')) {
      currentDir = mapperPath;
    } else {
      // 기타 파일의 경우
      currentDir = path.dirname(filePath);
    }

    // 대상 파일로의 상대 경로 계산
    String relativePath = path.relative(filePath, from: currentDir);

    // 같은 디렉토리에 있는 파일은 그냥 파일명만 반환
    if (path.dirname(relativePath) == '.') {
      return targetFile;
    }

    // 다른 디렉토리에 있는 파일은 상대 경로 반환 (필요한 경우 './'를 추가)
    if (!relativePath.startsWith('.')) {
      relativePath = './$relativePath';
    }

    return relativePath;
  }

  // 템플릿에 필요한 임포트 경로 설정
  final Map<String, String> imports = {
    'dataSource': calculateImportPath(dataSourceFile),
    'dto': calculateImportPath(dtoFile),
    'model': calculateImportPath(modelFile),
    'repository': calculateImportPath(repositoryFile),
  };

  // 파일 생성
  _createFile(
    dataSourceFile,
    generateDataSourceTemplate(capitalizedModelName),
  );

  _createFile(
    dataSourceImplFile,
    generateDataSourceImplTemplate(
      capitalizedModelName,
      imports['dataSource']!,
    ),
  );

  _createFile(
    dtoFile,
    generateDtoTemplate(
      capitalizedModelName,
      useJson,
    ),
  );

  _createFile(
    mapperFile,
    generateMapperTemplate(
      capitalizedModelName,
      imports['model']!,
      imports['dto']!,
    ),
  );

  _createFile(
    modelFile,
    generateModelTemplate(
      capitalizedModelName,
      useFreezed,
    ),
  );

  _createFile(
    repositoryFile,
    generateRepositoryTemplate(capitalizedModelName),
  );

  _createFile(
    repositoryImplFile,
    generateRepositoryImplTemplate(
      capitalizedModelName,
      imports['repository']!,
      imports['dataSource']!,
    ),
  );
}

/// 프로젝트 루트 디렉토리(pubspec.yaml이 있는 디렉토리)를 찾습니다.
/// 현재 디렉토리부터 상위 디렉토리로 올라가며 pubspec.yaml 파일을 찾습니다.
String _findProjectRoot() {
  Directory current = Directory.current;

  // 최대 10번 상위 디렉토리까지 검색 (무한 루프 방지)
  for (int i = 0; i < 10; i++) {
    if (File(path.join(current.path, 'pubspec.yaml')).existsSync()) {
      return current.path;
    }

    // 상위 디렉토리가 없으면 검색 종료
    Directory parent = Directory(path.dirname(current.path));
    if (parent.path == current.path) {
      break;
    }

    current = parent;
  }

  // 프로젝트 루트를 찾지 못한 경우
  return '';
}

/// 패키지명을 추출합니다.
String _getPackageName(String projectRoot) {
  try {
    // 프로젝트 루트 디렉토리의 pubspec.yaml 파일 찾기
    final File pubspecFile = File(path.join(projectRoot, 'pubspec.yaml'));

    if (!pubspecFile.existsSync()) {
      print('경고: pubspec.yaml 파일을 찾을 수 없습니다.');
      return 'app'; // 기본값
    }

    final String content = pubspecFile.readAsStringSync();
    final RegExp nameRegex = RegExp(r'name:\s*([^\s]+)');
    final Match? match = nameRegex.firstMatch(content);

    final String packageName = match != null ? match.group(1)! : 'app';
    print('패키지명: $packageName');
    return packageName;
  } catch (e) {
    print('경고: 패키지명을 추출하는 중 오류가 발생했습니다: $e');
    return 'app'; // 오류 발생 시 기본값
  }
}

/// 디렉토리가 없으면 생성합니다.
void _createDirectoryIfNotExists(String path) {
  final Directory directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}

/// 파일을 생성합니다.
void _createFile(String path, String content) {
  final File file = File(path);
  file.writeAsStringSync(content);
  print('생성됨: $path');
}