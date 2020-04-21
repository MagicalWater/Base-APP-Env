// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBean _$ProductBeanFromJson(Map<String, dynamic> json) {
  return ProductBean(
    android: _FromJsonWrapper._fromJsonList$ProductAndroidList0Bean$(
        json['android']),
    ios: _FromJsonWrapper._fromJsonList$ProductAndroidList0Bean$(json['ios']),
  );
}

Map<String, dynamic> _$ProductBeanToJson(ProductBean instance) =>
    <String, dynamic>{
      'android':
          _ToJsonWrapper._toJsonList$ProductAndroidList0Bean$(instance.android),
      'ios': _ToJsonWrapper._toJsonList$ProductAndroidList0Bean$(instance.ios),
    };

ProductAndroidList0Bean _$ProductAndroidList0BeanFromJson(
    Map<String, dynamic> json) {
  return ProductAndroidList0Bean(
    versionName: translateString(json['versionName']),
    versionCode: translateInt(json['versionCode']),
  );
}

Map<String, dynamic> _$ProductAndroidList0BeanToJson(
        ProductAndroidList0Bean instance) =>
    <String, dynamic>{
      'versionName': instance.versionName,
      'versionCode': instance.versionCode,
    };
