# arch_gen

단일 명령어로 Flutter/Dart 애플리케이션의 Clean Architecture 중 Data 영역의 폴더, 파일들을 생성합니다.

## 주요 기능

1. **Clean Architecture 구조 중 Data 영역 자동 생성**

    - DataSource, Repository, Model, DTO, Mapper 파일들을 생성
    - 컴포넌트 간 올바른 의존성 관계 설정

2. **freezed 및 json_serializable 선택적 지원**

    * 이 기능들을 활용하려면 프로젝트에 다음 패키지들의 의존성을 추가해야 합니다:

        * [freezed](https://pub.dev/packages/freezed)
        * [freezed_annotation](https://pub.dev/packages/freezed_annotation)
        * [json_serializable](https://pub.dev/packages/json_serializable)
        * [json_annotation](https://pub.dev/packages/json_annotation)
        * [build_runner](https://pub.dev/packages/build_runner):

    * 의존성 추가 예시:

      ```yaml
      dependencies:
        freezed_annotation: ^2.4.1
        json_annotation: ^4.8.1
      
      dev_dependencies:
        build_runner: ^2.4.7
        freezed: ^2.4.6
        json_serializable: ^6.7.1
      ```

    * 코드 생성 명령어: `dart run build_runner build`

    * 자세한 사용법은 각 라이브러리의 공식 문서를 참조하세요

        - freezed: https://pub.dev/packages/freezed
        - json_serializable: https://pub.dev/packages/json_serializable

## 설치

```bash
dart pub global activate arch_gen
```

또는 `pubspec.yaml`에 다음을 추가하세요:

```yaml
dev_dependencies:
  arch_gen: ^0.1.0
```

## 사용법

```bash
archgen <모델명>              # 필수: 모델 이름 (위치 인수)
      -d, --dir <디렉토리>   # 선택: 기본 디렉토리 경로 (현재 버전에서는 항상 프로젝트 루트의 lib 폴더 사용)
      -f, --flat             # 선택: 모든 파일을 한 폴더에 생성
      --freezed, -z          # 선택: freezed 사용
      --json, -j             # 선택: json_serializable 사용
      -h, --help             # 도움말 표시
```

### 예시

#### 기본 생성

```bash
archgen User
```

다음 파일 구조와 코드를 생성합니다:

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
```



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

#### Freezed 사용

```bash
archgen User -z
```

Model 클래스에만 freezed 템플릿을 적용합니다:

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

#### JSON Serializable 사용

```bash
archgen User -j
```

DTO 클래스에만 json_serializable 템플릿을 적용합니다:

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

#### 단일 디렉토리 구조

```bash
archgen User -f
```

중첩된 폴더 대신 현재 디렉토리에 모든 파일을 생성합니다.



## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.