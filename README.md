# arch_gen

명령어 하나로 Clean Architecture 구조 중 Data 부분들의 파일들을 자동 생성하는 Dart CLI 도구입니다. 최소한의 의존성(args 패키지만)으로 사용법을 매우 간단하게 구현합니다.

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
arcgen <모델명>              # 필수: 모델 이름 (위치 인수)
      -d, --dir <디렉토리>   # 선택: 생성할 파일들의 기본 경로 (항상 프로젝트 루트의 lib 폴더 기준)
      -f, --flat             # 선택: 모든 파일을 한 폴더에 생성
      --freezed, -z          # 선택: freezed 사용
      --json, -j             # 선택: json_serializable 사용
      -h, --help             # 도움말 표시
```

### 예시

#### 기본 생성

```bash
arcgen User
```

다음 파일 구조와 코드를 생성합니다:

```
// lib/data/data_source/user_data_source.dart
abstract interface class UserDataSource {

}

// lib/data/data_source/user_data_source_impl.dart
import 'package:your_app/data/data_source/user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  
}

// lib/data/dto/user_dto.dart
class UserDto {

}

// lib/data/mapper/user_mapper.dart
import 'package:your_app/data/model/user.dart';

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
import 'package:your_app/data/data_source/user_data_source.dart';
import 'package:your_app/data/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  const UserRepositoryImpl({
    required UserDataSource userDataSource,
  }) : _userDataSource = userDataSource;
}
```

#### Freezed 사용

```bash
arcgen User --freezed
```

Model 클래스에 freezed 템플릿을 적용합니다.

#### JSON Serializable 사용

```bash
arcgen User --json
```

DTO 클래스에 json_serializable 템플릿을 적용합니다.

## 기여하기

이슈와 풀 리퀘스트를 환영합니다.

## 라이센스

MIT