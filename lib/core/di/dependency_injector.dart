import 'package:da_gen/data/data_sources/command_data_source_impl.dart';
import 'package:da_gen/data/data_sources/file_system_data_source_impl.dart';
import 'package:da_gen/data/data_sources/project_data_source_impl.dart';
import 'package:da_gen/data/data_sources/template_data_source_impl.dart';
import 'package:da_gen/data/repositories/command_repository_impl.dart';
import 'package:da_gen/data/repositories/file_generator_repository_impl.dart';
import 'package:da_gen/data/repositories/file_path_repository_impl.dart';
import 'package:da_gen/data/repositories/file_system_repository_impl.dart';
import 'package:da_gen/data/repositories/project_repository_impl.dart';
import 'package:da_gen/data/repositories/template_repository_impl.dart';
import 'package:da_gen/data/repositories/command_repository.dart';
import 'package:da_gen/data/repositories/file_generator_repository.dart';
import 'package:da_gen/data/repositories/file_path_repository.dart';
import 'package:da_gen/data/repositories/file_system_repository.dart';
import 'package:da_gen/data/repositories/project_repository.dart';
import 'package:da_gen/data/repositories/template_repository.dart';
import 'package:da_gen/presentation/command_executor.dart';
import 'package:da_gen/presentation/command_options.dart';

/// 의존성 주입을 담당하는 클래스
class DependencyInjector {
  /// CommandExecutor 인스턴스를 생성합니다.
  static CommandExecutor provideCommandExecutor() {
    // DataSources
    final fileSystemDataSource = FileSystemDataSourceImpl();
    final projectDataSource = ProjectDataSourceImpl();
    final templateDataSource = TemplateDataSourceImpl();
    final commandDataSource = CommandDataSourceImpl();

    // Repositories
    final FileSystemRepository fileSystemRepository =
        FileSystemRepositoryImpl(fileSystemDataSource);
    final ProjectRepository projectRepository =
        ProjectRepositoryImpl(projectDataSource);
    final TemplateRepository templateRepository =
        TemplateRepositoryImpl(templateDataSource);
    final FilePathRepository filePathRepository = FilePathRepositoryImpl();
    final CommandRepository commandRepository = CommandRepositoryImpl(
      commandDataSource,
      CommandOptions.getDefaultOptions(),
    );

    // FileGeneratorRepository
    final FileGeneratorRepository fileGeneratorRepository =
        FileGeneratorRepositoryImpl(
      projectRepository: projectRepository,
      filePathRepository: filePathRepository,
      fileSystemRepository: fileSystemRepository,
      templateRepository: templateRepository,
    );

    // CommandExecutor
    return CommandExecutor(
      commandRepository: commandRepository,
      fileGeneratorRepository: fileGeneratorRepository,
    );
  }
}
