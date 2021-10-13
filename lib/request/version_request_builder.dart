/// api
abstract class VersionRequestInterface {
  /// 取得版本號
  /// [appCode] - 專案名稱
  Future<String> getProduct(
    String appCode,
  );

  /// 檢查更新
  /// [appCode] 專案名稱
  /// [buildType] 專案環境
  Future<String> getVersion(
    String appCode,
    String buildType,
  );
}
