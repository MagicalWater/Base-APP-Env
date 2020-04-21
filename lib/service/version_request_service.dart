import 'package:mx_core/mx_core.dart';
import 'package:mx_env/request/version_request_client.dart';
import 'package:mx_env/request/version_request_interface.api.dart';
import 'package:rxdart/rxdart.dart';

class VersionRequestService {
  VersionRequestClientMixin versionRequestClientMixin = VersionRequestClient.getInstance();

  Observable<ServerResponse> getProduct(String appCode) {
    return versionRequestClientMixin
        .getProduct(
          appCode,
        )
        .connect();
  }

  Observable<ServerResponse> getVersion(String appCode, String buildType) {
    return versionRequestClientMixin
        .getVersion(
          appCode,
          buildType,
        )
        .connect();
  }
}
