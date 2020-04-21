import 'package:mx_core/mx_core.dart';
import 'package:mx_env/request/version_request_interface.api.dart';

/// 推廣相關api
@Api()
abstract class VersionRequestInterface {
  /// ---
  /// 取得版本號
  /// <h2>Get - /{appCode}/product.json </h2>
  /// + String appCode 專案名稱
  ///
  @Get("/{appCode}/product.json")
  HttpContent getProduct(
    @Path('appCode') String appCode,
  );

  /// ---
  /// 檢查更新
  /// <h2>Get - /{flavor}/{buildType}/version.json </h2>
  /// + String appCode 專案名稱
  /// + String buildType 專案環境
  ///
  @Get("/{appCode}/{buildType}/version.json")
  HttpContent getVersion(
    @Path('appCode') String appCode,
    @Path('buildType') String buildType,
  );
}

class VersionRequestBuilder extends VersionRequestApi {}
