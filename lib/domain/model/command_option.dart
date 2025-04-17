import 'package:args/args.dart';

/// 명령어 옵션의 추상 인터페이스
sealed class CommandOption {
  String get name;

  String get abbr;

  String get help;

  void addToParser(ArgParser parser);
}

/// 디렉토리 옵션 구현체
class DirOption extends CommandOption {
  @override
  final String name;
  @override
  final String abbr;
  @override
  final String help;
  final String defaultsTo;

  DirOption({
    required this.name,
    required this.abbr,
    required this.help,
    required this.defaultsTo,
  });

  DirOption.lib()
      : this(
            name: 'dir',
            abbr: 'd',
            help: 'Base directory path (current version always uses the lib folder in project root)',
            defaultsTo: 'lib');

  @override
  void addToParser(ArgParser parser) {
    parser.addOption(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
    );
  }
}

/// 플래그 옵션 구현체
class FlagOption extends CommandOption {
  @override
  final String name;
  @override
  final String abbr;
  @override
  final String help;
  final bool negatable;

  FlagOption({
    required this.name,
    required this.abbr,
    required this.help,
    required this.negatable,
  });

  /// flat 옵션을 위한 팩토리 생성자
  FlagOption.flat()
      : this(
            name: 'flat', abbr: 'f', help: 'Generate all files in the current directory', negatable: false);

  /// freezed 옵션을 위한 팩토리 생성자
  FlagOption.freezed()
      : this(name: 'freezed', abbr: 'z', help: 'Use freezed', negatable: false);

  /// json 옵션을 위한 팩토리 생성자
  FlagOption.json()
      : this(
            name: 'json',
            abbr: 'j',
            help: 'Use json_serializable',
            negatable: false);

  /// help 옵션을 위한 팩토리 생성자
  FlagOption.help()
      : this(name: 'help', abbr: 'h', help: 'Display help', negatable: false);

  @override
  void addToParser(ArgParser parser) {
    parser.addFlag(
      name,
      abbr: abbr,
      help: help,
      negatable: negatable,
    );
  }
}
