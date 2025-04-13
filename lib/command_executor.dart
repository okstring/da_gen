import 'dart:io';

import 'package:arch_gen/src/file_system/file_generator.dart';
import 'package:arch_gen/src/options/command_options.dart';
import 'package:args/args.dart';

class CommandExecutor {
  final CommandOptions _commandOptions;
  final ArgParser _argParser;
  final FileGenerator _fileGenerator;

  CommandExecutor(
      {CommandOptions? commandOptions,
      ArgParser? argParser,
      FileGenerator? fileGenerator})
      : _commandOptions = commandOptions ?? CommandOptions.defaults(),
        _argParser = argParser ?? ArgParser(),
        _fileGenerator = fileGenerator ?? FileGenerator();

  void execute(List<String> arguments) {
    try {
      _commandOptions.addAllToParser(_argParser);
      // 인수 파싱
      final ArgResults args = _argParser.parse(arguments);

      // 도움말 표시
      _checkForHelpOption(args);

      // 위치 인수 (모델명) 확인
      List<String> rest = _checkForModelName(args);

      // 옵션 추출
      final String modelName = rest.first;
      final bool isFlat = args['flat'];
      final bool useFreezed = args['freezed'];
      final bool useJson = args['json'];

      // 모델 관련 파일들을 생성합니다.
      _fileGenerator.generateFiles(
        modelName: modelName,
        isFlat: isFlat,
        useFreezed: useFreezed,
        useJson: useJson,
      );

      print('$modelName 모델 파일들이 성공적으로 생성되었습니다.');
    } on FormatException catch (e) {
      print('오류: ${e.message}');
      _printUsage(_argParser);
      exit(1);
    } catch (e) {
      print('오류가 발생했습니다: $e');
      exit(1);
    }
  }

  /// 위치 인수 (모델명) 확인
  List<String> _checkForModelName(ArgResults args) {
    final rest = args.rest;
    if (rest.isEmpty) {
      print('오류: 모델명을 지정해야 합니다.');
      _printUsage(_argParser);
      exit(1);
    }
    return rest;
  }

  /// 도움말 표시
  void _checkForHelpOption(ArgResults args) {
    if (args['help']) {
      _printUsage(_argParser);
      exit(0);
    }
  }

  /// 사용법을 출력합니다.
  void _printUsage(ArgParser argParser) {
    print('사용법: archgen <모델명> [옵션]');
    print('옵션:');
    print(argParser.usage);
  }
}
