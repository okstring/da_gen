# da_gen

Generate folders and files for the Data layer of MVVM in Flutter/Dart applications with a single command.

## Key Features

1. **Automatic Generation of Data Layer in MVVM**
   - Creates DataSource, Repository, Model, DTO, and Mapper files
   - Sets up proper dependency relationships between components
2. **Optional Support for freezed and json_serializable**
   - To use these features, you need to add the following package dependencies to your project:
     - [freezed](https://pub.dev/packages/freezed)
     - [freezed_annotation](https://pub.dev/packages/freezed_annotation)
     - [json_serializable](https://pub.dev/packages/json_serializable)
     - [json_annotation](https://pub.dev/packages/json_annotation)
     - [build_runner](https://pub.dev/packages/build_runner)
   - Code generation command: `dart run build_runner build`
   - For detailed usage, refer to the official documentation of each library:
     - freezed: https://pub.dev/packages/freezed
     - json_serializable: https://pub.dev/packages/json_serializable

## Installation

```bash
dart pub global activate da_gen
```

Or add the following to your `pubspec.yaml`:

```yaml
dev_dependencies:
  da_gen: ^0.1.5
```

## Environment Variable Setup

To run globally installed Dart packages from anywhere, you need to add Dart's global package execution path to your system's environment variables.

### Windows

1. Search for "Environment Variables" in the Start menu and click on "Edit the system environment variables"

2. Click the "Environment Variables" button

3. In the "User variables" section, select the `Path` variable and click "Edit"

4. Click "New" and add the following path:

   ```
   %LOCALAPPDATA%\Pub\Cache\bin
   ```

5. Click "OK" to save

### macOS/Linux

Run the following command in your terminal to add the path to your `~/.bashrc`, `~/.zshrc`, or appropriate shell profile file:

```bash
# For bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Verify Installation

After setting up environment variables, run the following command to verify that the `dagen` command works properly:

```bash
dagen -h
```

## Usage

```bash
dagen <model_name>           # Required: Model name (positional argument)
      -d, --dir <directory>   # Optional: Base directory path (current version always uses the lib folder in project root)
      -f, --flat              # Optional: Generate all files in a single folder
      --freezed, -z           # Optional: Use freezed
      --json, -j              # Optional: Use json_serializable
      -h, --help              # Display help
```

### Examples

#### Basic Generation

```bash
dagen User
```

This generates the following file structure and code:

```
lib/
└── data/
    ├── data_source/
    │   ├── user_data_source.dart
    │   └── user_data_source_impl.dart
    ├── dto/
    │   └── user_dto.dart
    ├── mapper/
    │   └── user_mapper.dart
    ├── model/
    │   └── user.dart
    └── repository/
        ├── user_repository.dart
        └── user_repository_impl.dart
// lib/data/data_source/user_data_source.dart
abstract interface class UserDataSource {

}

// lib/data/data_source/user_data_source_impl.dart
import './user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  
}

// lib/data/dto/user_dto.dart
class UserDto {

}

// lib/data/mapper/user_mapper.dart
import '../model/user.dart';
import '../dto/user_dto.dart';

extension UserMapper on UserDto {
  User toUser() {
    return User();
  }
}

// lib/data/model/user.dart
class User {

}

// lib/data/repository/user_repository.dart
abstract interface class UserRepository {

}

// lib/data/repository/user_repository_impl.dart
import './user_repository.dart';
import '../data_source/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  const UserRepositoryImpl({
    required UserDataSource userDataSource,
  }) : _userDataSource = userDataSource;
}
```

#### Using Freezed

```bash
dagen User -z
```

This applies the freezed template to the Model class:

```dart
// lib/data/model/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    
  }) = _User;
}
```

#### Using JSON Serializable

```bash
dagen User -j
```

This applies the json_serializable template to the DTO class:

```dart
// lib/data/dto/user_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDto {
  
  
  UserDto();
  
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
```

#### Flat Directory Structure

```bash
dagen User -f
```

This generates all files in the current directory instead of nested folders.

## License

This project is distributed under the MIT License. See the LICENSE file for more details.
