import 'package:da_gen/data/data_sources/command_data_source.dart';
import 'package:args/args.dart';

/// 명령어 처리 구현체
class CommandDataSourceImpl implements CommandDataSource {
  /// ArgParser 인스턴스를 생성합니다.
  @override
  ArgParser createArgParser() {
    return ArgParser();
  }

  /// 명령어 인수를 파싱합니다.
  @override
  ArgResults parseArguments(List<String> arguments, ArgParser parser) {
    return parser.parse(arguments);
  }

  /// 사용법을 출력합니다.
  @override
  void printUsage(ArgParser parser) {
    print('사용법: dagen <모델명> [옵션]');
    print('옵션:');
    print(parser.usage);
  }
}