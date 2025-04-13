import 'package:path/path.dart' as path;

/// 경로 계산과 관련된 기능을 제공하는 클래스
class PathCalculator {
  /// 상대 경로를 계산합니다.
  String calculateRelativeImportPath(String targetFile, String fromFile) {
    // TODO: 안쓰는 파일들 제거
    // 대상 파일의 디렉토리와 현재 파일의 디렉토리
    String targetDir = path.dirname(targetFile);
    String fromDir = path.dirname(fromFile);

    // 상대 경로 계산
    String relativePath = path.relative(targetFile, from: fromDir);

    // 시작이 . 또는 .. 이 아니면 ./ 추가
    if (!relativePath.startsWith('.')) {
      relativePath = './$relativePath';
    }

    return relativePath;
  }
}