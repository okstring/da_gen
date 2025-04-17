import 'package:da_gen/core/di/dependency_injector.dart';
import 'package:da_gen/presentation/command_executor.dart';

/// CLI 도구의 메인 함수입니다.
void main(List<String> arguments) {
  // 의존성 주입을 통해 CommandExecutor 인스턴스 생성
  final CommandExecutor commandExecutor = DependencyInjector.provideCommandExecutor();

  // 명령어 실행
  commandExecutor.execute(arguments);
}