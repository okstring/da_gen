import 'package:arch_gen/command_executor.dart';

/// CLI 도구의 메인 함수입니다.
void main(List<String> arguments) {
  final commandExecutor = CommandExecutor();
  commandExecutor.execute(arguments);
}