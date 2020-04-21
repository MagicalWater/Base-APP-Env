import 'package:mx_core/mx_core.dart';
import 'package:mx_env/request/version_request_interface.api.dart';
import 'package:mx_env/request/version_request_interface.dart';

class VersionRequestClient extends RequestClientBase with VersionRequestClientMixin {
  static final _singleton = VersionRequestClient._internal();

  static VersionRequestClient getInstance() => _singleton;

  factory VersionRequestClient() => _singleton;

  VersionRequestClient._internal() : super();

  /// 初始化 request 構建
  @override
  List<RequestBuilderBase> builders() {
    return [
      versionRequestApi = VersionRequestBuilder(),
    ];
  }

  @override
  String scheme() {
    return "https";
  }

  @override
  String host() {
    return "apps99.cc";
  }

  @override
  Map<String, String> headers() {
    return super.headers();
  }

  @override
  Map<String, String> queryParams() {
    return super.queryParams();
  }
}
