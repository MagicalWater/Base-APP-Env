export 'version_request_impl.dart';

import 'dart:io';

/// api
abstract class VersionRequestInterface {
  /// 取得版本號
  /// [appCode] - 專案名稱
  Future<HttpClientResponse> getProduct(
    String appCode,
  );

  /// 檢查更新
  /// [appCode] 專案名稱
  /// [buildType] 專案環境
  Future<HttpClientResponse> getVersion(
    String appCode,
    String buildType,
  );
}
