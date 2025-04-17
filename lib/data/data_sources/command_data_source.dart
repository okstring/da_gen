import 'package:args/args.dart';

/// 명령어 처리를 위한 데이터소스 인터페이스
abstract interface class CommandDataSource {
  /// ArgParser 인스턴스를 생성합니다.
  ArgParser createArgParser();

  /// 명령어 인수를 파싱합니다.
  ArgResults parseArguments(List<String> arguments, ArgParser parser);

  /// 사용법을 출력합니다.
  void printUsage(ArgParser parser);
}
