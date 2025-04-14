import 'package:da_gen/domain/model/command_option.dart';

/// 명령어 옵션 제공자 클래스
class CommandOptions {
  /// 기본 옵션들을 제공합니다.
  static List<CommandOption> getDefaultOptions() {
    return [
      DirOption.lib(),
      FlagOption.flat(),
      FlagOption.freezed(),
      FlagOption.json(),
      FlagOption.help(),
    ];
  }
}