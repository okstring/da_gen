
import 'package:arch_gen/src/options/command_option.dart';
import 'package:args/args.dart';

/// 명령어 옵션 관리자 클래스
class CommandOptions {
  final List<CommandOption> options;

  CommandOptions(this.options);

  /// 기본 옵션들을 포함한 CommandOptions 객체를 생성합니다.
  factory CommandOptions.defaults() {
    return CommandOptions([
      DirOption.lib(),
      FlagOption.flat(),
      FlagOption.freezed(),
      FlagOption.json(),
      FlagOption.help(),
    ]);
  }

  /// 모든 옵션을 ArgParser에 추가합니다.
  ArgParser createParser() {
    final ArgParser parser = ArgParser();
    for (final option in options) {
      option.addToParser(parser);
    }
    return parser;
  }
}