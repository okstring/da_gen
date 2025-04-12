import 'dart:io';
import 'package:args/args.dart';
import 'package:arch_gen/arch_gen.dart';

void main(List<String> arguments) {
  // 인수 파서 설정
  final ArgParser argParser = ArgParser()
    ..addOption(
      'dir',
      abbr: 'd',
      help: '기본 디렉토리 경로 (현재 버전에서는 항상 프로젝트 루트의 lib 폴더 사용)',
      defaultsTo: 'lib',
    )
    ..addFlag(
      'flat',
      abbr: 'f',
      help: '모든 파일을 한 폴더에 생성',
      negatable: false,
    )
    ..addFlag(
      'freezed',
      abbr: 'z',  // 'fr' 대신 단일 문자 약어로 변경
      help: 'freezed 사용',
      negatable: false,
    )
    ..addFlag(
      'json',
      abbr: 'j',
      help: 'json_serializable 사용',
      negatable: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: '도움말 표시',
      negatable: false,
    );

  try {
    // 인수 파싱
    final ArgResults args = argParser.parse(arguments);

    // 도움말 표시
    if (args['help']) {
      _printUsage(argParser);
      exit(0);
    }

    // 위치 인수 (모델명) 확인
    final rest = args.rest;
    if (rest.isEmpty) {
      print('오류: 모델명을 지정해야 합니다.');
      _printUsage(argParser);
      exit(1);
    }

    // 옵션 추출
    final String modelName = rest.first;
    final String dir = args['dir'];
    final bool isFlat = args['flat'];
    final bool useFreezed = args['freezed'];
    final bool useJson = args['json'];

    // 파일 생성 실행
    generateFiles(
      modelName: modelName,
      baseDir: dir,
      isFlat: isFlat,
      useFreezed: useFreezed,
      useJson: useJson,
    );

    print('$modelName 모델 파일들이 성공적으로 생성되었습니다.');
  } on FormatException catch (e) {
    print('오류: ${e.message}');
    _printUsage(argParser);
    exit(1);
  } catch (e) {
    print('오류가 발생했습니다: $e');
    exit(1);
  }
}

void _printUsage(ArgParser argParser) {
  print('사용법: arcgen <모델명> [옵션]');
  print('옵션:');
  print(argParser.usage);
}