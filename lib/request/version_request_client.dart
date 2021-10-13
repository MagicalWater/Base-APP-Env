import 'dart:convert';
import 'dart:io';

import 'version_request_builder.dart';

export 'version_request_builder.dart';

class VersionRequestClient implements VersionRequestInterface {
  String host = '';
  String scheme = '';

  Uri _getUrl(String path) => Uri(scheme: scheme, host: host, path: path);

  @override
  Future<String> getProduct(String appCode) {
    var path = '/web/$appCode/product.json';
    var url = _getUrl(path);
    print('開始取得發布文件 - [GET] $url');
    return HttpClient().getUrl(url).then((value) {
      return value.close();
    }).then((value) {
      if (value.statusCode != 200) {
        var errorText = '${value.statusCode}(${value.reasonPhrase})';
        print('錯誤: 獲取發布文件出錯 - $errorText');
        throw errorText;
      } else {
        return value.transform(utf8.decoder).single;
      }
    });
  }

  @override
  Future<String> getVersion(String appCode, String buildType) {
    var path = '/web/$appCode/$buildType/version.json';
    var url = _getUrl(path);
    print('開始取得版本文件 - [GET] $url');
    return HttpClient().getUrl(url).then((value) {
      return value.close();
    }).then((value) {
      if (value.statusCode != 200) {
        var errorText = '${value.statusCode}(${value.reasonPhrase})';
        print('錯誤: 獲取版本文件出錯 - $errorText');
        throw errorText;
      } else {
        return value.transform(utf8.decoder).single;
      }
    });
  }
}
