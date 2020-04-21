// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ApiGenerator
// **************************************************************************

import 'dart:io' show ContentType;
import 'package:meta/meta.dart';
import 'package:mx_core/mx_core.dart';
import 'package:rxdart/rxdart.dart';
import 'version_request_interface.dart';

abstract class VersionRequestApi extends RequestBuilderBase
    implements VersionRequestInterface {
  @override
  HttpContent getProduct(String appCode) {
    var content =
        generator.generate('/$appCode/product.json', method: HttpMethod.get);

    return content;
  }

  @override
  HttpContent getVersion(String appCode, String buildType) {
    var content = generator.generate('/$appCode/$buildType/version.json',
        method: HttpMethod.get);

    return content;
  }
}

abstract class VersionRequestClientMixin implements VersionRequestInterface {
  VersionRequestApi versionRequestApi;

  @override
  HttpContent getProduct(String appCode) {
    return versionRequestApi.getProduct(
      appCode,
    );
  }

  @override
  HttpContent getVersion(String appCode, String buildType) {
    return versionRequestApi.getVersion(
      appCode,
      buildType,
    );
  }
}

abstract class VersionRequestServicePattern {
  VersionRequestClientMixin versionRequestClientMixin;

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
