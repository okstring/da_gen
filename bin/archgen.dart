import 'package:arch_gen/command_executor.dart';
import 'package:arch_gen/src/options/command_options.dart';
import 'package:args/args.dart';

/// CLI 도구의 메인 함수입니다.
void main(List<String> arguments) {
  final commandOptions = CommandOptions.defaults();
  final ArgParser argParser = commandOptions.createParser();
  final commandExecutor = CommandExecutor(commandOptions: commandOptions, argParser: argParser);
  commandExecutor.execute(arguments);
}