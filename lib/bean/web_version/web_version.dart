import 'package:json_annotation/json_annotation.dart';
import 'package:type_translator/type_translator.dart';
part 'web_version.g.dart';

@JsonSerializable()
class WebVersionBean {
  @JsonKey(
      fromJson: WebVersionConfigBean._fromJson,
      toJson: WebVersionConfigBean._toJson)
  WebVersionConfigBean config;
  @JsonKey(
      fromJson: WebVersionAndroidBean._fromJson,
      toJson: WebVersionAndroidBean._toJson)
  WebVersionAndroidBean android;
  @JsonKey(
      fromJson: WebVersionAndroidBean._fromJson,
      toJson: WebVersionAndroidBean._toJson)
  WebVersionAndroidBean ios;

  WebVersionBean({this.config, this.android, this.ios});
  factory WebVersionBean.fromJson(dynamic json) =>
      json != null ? _$WebVersionBeanFromJson(json) : null;

  dynamic toJson() => _$WebVersionBeanToJson(this);
}

@JsonSerializable()
class WebVersionAndroidBean {
  @JsonKey(fromJson: translateString)
  String message;
  @JsonKey(fromJson: translateString)
  String versionName;
  @JsonKey(fromJson: translateInt)
  int versionCode;
  @JsonKey(
      fromJson: WebVersionAndroidDevBean._fromJson,
      toJson: WebVersionAndroidDevBean._toJson)
  WebVersionAndroidDevBean dev;
  @JsonKey(
      fromJson: WebVersionAndroidDevBean._fromJson,
      toJson: WebVersionAndroidDevBean._toJson)
  WebVersionAndroidDevBean product;
  @JsonKey(fromJson: translateBool)
  bool ignore;

  WebVersionAndroidBean(
      {this.message,
      this.versionName,
      this.versionCode,
      this.dev,
      this.product,
      this.ignore});
  factory WebVersionAndroidBean.fromJson(dynamic json) =>
      json != null ? _$WebVersionAndroidBeanFromJson(json) : null;

  static WebVersionAndroidBean _fromJson(dynamic json) =>
      WebVersionAndroidBean.fromJson(json);

  static dynamic _toJson(WebVersionAndroidBean instance) => instance.toJson();

  dynamic toJson() => _$WebVersionAndroidBeanToJson(this);
}

@JsonSerializable()
class WebVersionAndroidDevBean {
  @JsonKey(fromJson: translateString)
  String url;
  @JsonKey(fromJson: translateBool)
  bool openWeb;

  WebVersionAndroidDevBean({this.url, this.openWeb});
  factory WebVersionAndroidDevBean.fromJson(dynamic json) =>
      json != null ? _$WebVersionAndroidDevBeanFromJson(json) : null;

  static WebVersionAndroidDevBean _fromJson(dynamic json) =>
      WebVersionAndroidDevBean.fromJson(json);

  static dynamic _toJson(WebVersionAndroidDevBean instance) =>
      instance.toJson();

  dynamic toJson() => _$WebVersionAndroidDevBeanToJson(this);
}

@JsonSerializable()
class WebVersionConfigBean {
  @JsonKey(fromJson: translateString)
  String web;

  WebVersionConfigBean({this.web});
  factory WebVersionConfigBean.fromJson(dynamic json) =>
      json != null ? _$WebVersionConfigBeanFromJson(json) : null;

  static WebVersionConfigBean _fromJson(dynamic json) =>
      WebVersionConfigBean.fromJson(json);

  static dynamic _toJson(WebVersionConfigBean instance) => instance.toJson();

  dynamic toJson() => _$WebVersionConfigBeanToJson(this);
}
