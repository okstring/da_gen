import 'package:args/args.dart';

/// 명령어 처리를 담당하는 리포지토리 인터페이스
abstract interface class CommandRepository {
  /// 명령어 인수를 파싱합니다.
  ArgResults parseArguments(List<String> arguments);

  /// 모델명이 유효한지 확인합니다.
  String validateModelName(List<String> rest);

  /// 도움말 요청인지 확인합니다.
  bool isHelpRequested(ArgResults args);

  /// 사용법을 출력합니다.
  void printUsage();
}
