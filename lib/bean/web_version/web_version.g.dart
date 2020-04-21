// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebVersionBean _$WebVersionBeanFromJson(Map<String, dynamic> json) {
  return WebVersionBean(
    config: WebVersionConfigBean._fromJson(json['config']),
    android: WebVersionAndroidBean._fromJson(json['android']),
    ios: WebVersionAndroidBean._fromJson(json['ios']),
  );
}

Map<String, dynamic> _$WebVersionBeanToJson(WebVersionBean instance) =>
    <String, dynamic>{
      'config': WebVersionConfigBean._toJson(instance.config),
      'android': WebVersionAndroidBean._toJson(instance.android),
      'ios': WebVersionAndroidBean._toJson(instance.ios),
    };

WebVersionAndroidBean _$WebVersionAndroidBeanFromJson(
    Map<String, dynamic> json) {
  return WebVersionAndroidBean(
    message: translateString(json['message']),
    versionName: translateString(json['versionName']),
    versionCode: translateInt(json['versionCode']),
    dev: WebVersionAndroidDevBean._fromJson(json['dev']),
    product: WebVersionAndroidDevBean._fromJson(json['product']),
    ignore: translateBool(json['ignore']),
  );
}

Map<String, dynamic> _$WebVersionAndroidBeanToJson(
        WebVersionAndroidBean instance) =>
    <String, dynamic>{
      'message': instance.message,
      'versionName': instance.versionName,
      'versionCode': instance.versionCode,
      'dev': WebVersionAndroidDevBean._toJson(instance.dev),
      'product': WebVersionAndroidDevBean._toJson(instance.product),
      'ignore': instance.ignore,
    };

WebVersionAndroidDevBean _$WebVersionAndroidDevBeanFromJson(
    Map<String, dynamic> json) {
  return WebVersionAndroidDevBean(
    url: translateString(json['url']),
    openWeb: translateBool(json['openWeb']),
  );
}

Map<String, dynamic> _$WebVersionAndroidDevBeanToJson(
        WebVersionAndroidDevBean instance) =>
    <String, dynamic>{
      'url': instance.url,
      'openWeb': instance.openWeb,
    };

WebVersionConfigBean _$WebVersionConfigBeanFromJson(Map<String, dynamic> json) {
  return WebVersionConfigBean(
    web: translateString(json['web']),
  );
}

Map<String, dynamic> _$WebVersionConfigBeanToJson(
        WebVersionConfigBean instance) =>
    <String, dynamic>{
      'web': instance.web,
    };
