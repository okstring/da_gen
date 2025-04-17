import 'dart:io';

import 'package:da_gen/domain/repositories/command_repository.dart';
import 'package:da_gen/domain/repositories/file_generator_repository.dart';

/// 명령어 실행을 담당하는 클래스
class CommandExecutor {
  final CommandRepository _commandRepository;
  final FileGeneratorRepository _fileGeneratorRepository;

  CommandExecutor({
    required CommandRepository commandRepository,
    required FileGeneratorRepository fileGeneratorRepository,
  })  : _commandRepository = commandRepository,
        _fileGeneratorRepository = fileGeneratorRepository;

  /// 명령어를 실행합니다.
  void execute(List<String> arguments) {
    try {
      // 인수 파싱
      final args = _commandRepository.parseArguments(arguments);

      // 도움말 표시
      if (_commandRepository.isHelpRequested(args)) {
        _commandRepository.printUsage();
        exit(0);
      }

      // 위치 인수 (모델명) 확인
      final String modelName = _commandRepository.validateModelName(args.rest);

      // 옵션 추출
      final bool isFlat = args['flat'] as bool;
      final bool useFreezed = args['freezed'] as bool;
      final bool useJson = args['json'] as bool;
      final String baseDir = args['dir'] as String;

      // 모델 관련 파일들을 생성합니다.
      _fileGeneratorRepository.generateFiles(
        modelName: modelName,
        baseDirName: baseDir,
        isFlat: isFlat,
        useFreezed: useFreezed,
        useJson: useJson,
      );

      print('$modelName model files have been successfully generated.');
    } catch (e) {
      print('An error occurred: $e');
      exit(1);
    }
  }
}
