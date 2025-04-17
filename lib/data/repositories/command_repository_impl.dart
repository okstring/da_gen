import 'dart:io';

import 'package:da_gen/data/data_sources/command_data_source.dart';
import 'package:da_gen/data/model/command_option.dart';
import 'package:da_gen/data/repositories/command_repository.dart';
import 'package:args/args.dart';

/// 명령어 리포지토리 구현체
class CommandRepositoryImpl implements CommandRepository {
  final CommandDataSource _dataSource;
  final List<CommandOption> _options;
  late final ArgParser _parser;

  CommandRepositoryImpl(this._dataSource, this._options) {
    _parser = _setupParser();
  }

  /// 명령어 인수를 파싱합니다.
  @override
  ArgResults parseArguments(List<String> arguments) {
    try {
      return _dataSource.parseArguments(arguments, _parser);
    } on FormatException catch (e) {
      print('Error: ${e.message}');
      printUsage();
      exit(1);
    }
  }

  /// 모델명이 유효한지 확인합니다.
  @override
  String validateModelName(List<String> rest) {
    if (rest.isEmpty) {
      print('Error: Model name must be specified.');
      printUsage();
      exit(1);
    }
    return rest.first;
  }

  /// 도움말 요청인지 확인합니다.
  @override
  bool isHelpRequested(ArgResults args) {
    return args['help'] as bool;
  }

  /// 사용법을 출력합니다.
  @override
  void printUsage() {
    _dataSource.printUsage(_parser);
  }

  /// ArgParser를 설정합니다.
  ArgParser _setupParser() {
    final parser = _dataSource.createArgParser();
    for (final option in _options) {
      option.addToParser(parser);
    }
    return parser;
  }
}
