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

  // 항상 프로젝트 루트의 lib을 기준으로 경로 설정
  final String rootDir = path.join(projectRoot, 'lib');

  // 파일 생성 경로 설정
  final String dataSourcePath = isFlat
      ? rootDir
      : path.join(rootDir, 'data', 'data_source');
  final String dtoPath = isFlat
      ? rootDir
      : path.join(rootDir, 'data', 'dto');
  final String mapperPath = isFlat
      ? rootDir
      : path.join(rootDir, 'data', 'mapper');
  final String modelPath = isFlat
      ? rootDir
      : path.join(rootDir, 'data', 'model');
  final String repositoryPath = isFlat
      ? rootDir
      : path.join(rootDir, 'data', 'repository');

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

  // 임포트 경로 설정 (상대 경로가 아닌 패키지 경로 사용)
  String getImportPath(String filePath) {
    // 프로젝트 루트 기준 상대 경로로 변환
    String relativePath = path.relative(filePath, from: projectRoot);

    // 'lib/' 부분 제거 (패키지 임포트에서는 lib이 기본 경로)
    if (relativePath.startsWith('lib/')) {
      relativePath = relativePath.substring(4);
    } else if (relativePath.startsWith('lib\\')) {
      relativePath = relativePath.substring(4);
    }

    return '$packageName/$relativePath';
  }

  // 템플릿에 필요한 변수 설정
  final Map<String, String> imports = {
    'dataSource': getImportPath(dataSourceFile),
    'dto': getImportPath(dtoFile),
    'model': getImportPath(modelFile),
    'repository': getImportPath(repositoryFile),
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