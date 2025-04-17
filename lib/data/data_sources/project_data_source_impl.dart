import 'dart:io';

import 'package:da_gen/data/data_sources/project_data_source.dart';
import 'package:path/path.dart' as path;

/// 프로젝트 구조 정보 접근 구현체
class ProjectDataSourceImpl implements ProjectDataSource {
  /// 프로젝트 루트 디렉토리(pubspec.yaml이 있는 디렉토리)를 찾습니다.
  @override
  String findProjectRoot() {
    Directory current = Directory.current;

    // 최대 20번 상위 디렉토리까지 검색
    for (int i = 0; i < 20; i++) {
      if (File(path.join(current.path, 'pubspec.yaml')).existsSync()) {
        print('프로젝트 루트 디렉토리: ${current.path}');
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
    print('오류: 프로젝트 루트 디렉토리를 찾을 수 없습니다. pubspec.yaml 파일이 있는 디렉토리에서 실행하세요.');
    exit(1);
  }

  /// 패키지명을 추출합니다.
  @override
  String getPackageName(String projectRoot) {
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
}
