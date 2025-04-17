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
            help: '기본 디렉토리 경로 (현재 버전에서는 항상 프로젝트 루트의 lib 폴더 사용)',
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
            name: 'flat', abbr: 'f', help: '모든 파일을 한 폴더에 생성', negatable: false);

  /// freezed 옵션을 위한 팩토리 생성자
  FlagOption.freezed()
      : this(name: 'freezed', abbr: 'z', help: 'freezed 사용', negatable: false);

  /// json 옵션을 위한 팩토리 생성자
  FlagOption.json()
      : this(
            name: 'json',
            abbr: 'j',
            help: 'json_serializable 사용',
            negatable: false);

  /// help 옵션을 위한 팩토리 생성자
  FlagOption.help()
      : this(name: 'help', abbr: 'h', help: '도움말 표시', negatable: false);

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
