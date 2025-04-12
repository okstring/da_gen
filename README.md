# arch_gen

Generate folders and files for the Data layer of Clean Architecture in Flutter/Dart applications with a single command.

## Features

1. **Automatic Data Layer Generation for Clean Architecture**
   - Creates DataSource, Repository, Model, DTO, and Mapper files
   - Establishes correct dependency relationships between components
2. **CamelCase → snake_case Conversion**
   - When model names are in CamelCase (e.g., UserDetail), filenames are automatically converted to snake_case (e.g., user_detail)
3. **Optional Support for freezed and json_serializable**
   - To utilize these features, you need to add the following package dependencies to your project:
     - freezed
     - freezed_annotation
     - json_serializable
     - json_annotation
     - build_runner
   - Example of adding dependencies:

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

- Code generation command: `dart run build_runner build`

## Installation

```bash
dart pub global activate arch_gen
```

Or add this to your `pubspec.yaml`:

```yaml
dev_dependencies:
  arch_gen: ^0.1.0
```

## Usage

```bash
arcgen <ModelName>           # Required: Model name (positional argument)
      -d, --dir <directory>  # Optional: Base directory path (currently always uses lib folder in project root)
      -f, --flat             # Optional: Generate all files in a single folder
      --freezed, -z          # Optional: Use freezed for models
      --json, -j             # Optional: Use json_serializable for DTOs
      -h, --help             # Display help
```

## Examples

### Basic Generation

```bash
arcgen User
```

This creates the following file structure and code:

```dart
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
import './user_dto.dart';

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

### Using Freezed

```bash
arcgen User --freezed
```

Applies the freezed template to the Model class:

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

### Using JSON Serializable

```bash
arcgen User --json
```

Applies json_serializable template to the DTO class:

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

### Flat Structure

```bash
arcgen User --flat
```

Creates all files in the current directory instead of nested folders.

## License

This project is distributed under the MIT License. See the LICENSE file for more details.