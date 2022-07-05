import 'dart:convert';
import 'dart:io';

import 'version_request_interface.dart';

class VersionRequest implements VersionRequestInterface {
  String host = '';
  String scheme = '';

  Uri _getUrl(String path) => Uri(scheme: scheme, host: host, path: path);

  @override
  Future<HttpClientResponse> getProduct(String appCode) {
    final path = '/web/$appCode/product.json';
    final url = _getUrl(path);
    print('開始取得發布文件 - [GET] $url');
    return HttpClient().getUrl(url).then((value) => value.close());
  }

  @override
  Future<HttpClientResponse> getVersion(String appCode, String buildType) {
    final platformTag = Platform.isAndroid ? 'android' : 'ios';
    final path = '/web/$appCode/$buildType/$platformTag/version.json';
    final url = _getUrl(path);
    print('開始取得版本文件 - [GET] $url');
    return HttpClient().getUrl(url).then((value) => value.close());
  }
}
