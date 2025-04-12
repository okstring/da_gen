import 'dart:io';
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
  required String baseDir,
  required bool isFlat,
  required bool useFreezed,
  required bool useJson,
}) {
  // 모델명 변환 (첫 글자 대문자)
  final String capitalizedModelName = capitalize(modelName);

  // 모델명 변환 (첫 글자 소문자)
  final String lowerModelName = uncapitalize(modelName);

  // 프로젝트 패키지명 추출 (현재 디렉토리 기준)
  final String packageName = _getPackageName();

  // baseDir이 상대 경로인지 절대 경로인지 확인
  // 항상 프로젝트 루트의 lib을 기준으로 경로 설정
  final String normalizedBaseDir = baseDir.startsWith('/') ? baseDir : 'lib';

  // 파일 생성 경로 설정
  final String dataSourcePath =
      isFlat ? normalizedBaseDir : '$normalizedBaseDir/data/data_source';
  final String dtoPath =
      isFlat ? normalizedBaseDir : '$normalizedBaseDir/data/dto';
  final String mapperPath =
      isFlat ? normalizedBaseDir : '$normalizedBaseDir/data/mapper';
  final String modelPath =
      isFlat ? normalizedBaseDir : '$normalizedBaseDir/data/model';
  final String repositoryPath =
      isFlat ? normalizedBaseDir : '$normalizedBaseDir/data/repository';

  // 디렉토리 생성
  _createDirectoryIfNotExists(dataSourcePath);
  _createDirectoryIfNotExists(dtoPath);
  _createDirectoryIfNotExists(mapperPath);
  _createDirectoryIfNotExists(modelPath);
  _createDirectoryIfNotExists(repositoryPath);

  // 파일명 생성
  final String dataSourceFile =
      '$dataSourcePath/${lowerModelName}_data_source.dart';
  final String dataSourceImplFile =
      '$dataSourcePath/${lowerModelName}_data_source_impl.dart';
  final String dtoFile = '$dtoPath/${lowerModelName}_dto.dart';
  final String mapperFile = '$mapperPath/${lowerModelName}_mapper.dart';
  final String modelFile = '$modelPath/$lowerModelName.dart';
  final String repositoryFile =
      '$repositoryPath/${lowerModelName}_repository.dart';
  final String repositoryImplFile =
      '$repositoryPath/${lowerModelName}_repository_impl.dart';

  // 임포트 경로 설정
  String getImportPath(String filePath) {
    if (isFlat) {
      // flat 구조일 때는 파일명만 추출하여 import
      final filename = filePath.split('/').last;
      return '$packageName/$baseDir/$filename';
    }
    return '$packageName/${filePath.replaceAll('$baseDir/', '')}';
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

/// 패키지명을 추출합니다.
String _getPackageName() {
  try {
    // 현재 작업 디렉토리에서 pubspec.yaml 파일 찾기
    final File pubspecFile = File('pubspec.yaml');

    if (!pubspecFile.existsSync()) {
      print('경고: 현재 디렉토리에서 pubspec.yaml 파일을 찾을 수 없습니다.');
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
