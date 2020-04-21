import 'package:json_annotation/json_annotation.dart';
import 'package:type_translator/type_translator.dart';
part 'product.g.dart';

@JsonSerializable()
class ProductBean {
  @JsonKey(
      fromJson: _FromJsonWrapper._fromJsonList$ProductAndroidList0Bean$,
      toJson: _ToJsonWrapper._toJsonList$ProductAndroidList0Bean$)
  List<ProductAndroidList0Bean> android;
  @JsonKey(
      fromJson: _FromJsonWrapper._fromJsonList$ProductAndroidList0Bean$,
      toJson: _ToJsonWrapper._toJsonList$ProductAndroidList0Bean$)
  List<ProductAndroidList0Bean> ios;

  ProductBean({this.android, this.ios});
  factory ProductBean.fromJson(dynamic json) =>
      json != null ? _$ProductBeanFromJson(json) : null;

  dynamic toJson() => _$ProductBeanToJson(this);
}

@JsonSerializable()
class ProductAndroidList0Bean {
  @JsonKey(fromJson: translateString)
  String versionName;
  @JsonKey(fromJson: translateInt)
  int versionCode;

  ProductAndroidList0Bean({this.versionName, this.versionCode});
  factory ProductAndroidList0Bean.fromJson(dynamic json) =>
      json != null ? _$ProductAndroidList0BeanFromJson(json) : null;

  static ProductAndroidList0Bean _fromJson(dynamic json) =>
      ProductAndroidList0Bean.fromJson(json);

  static dynamic _toJson(ProductAndroidList0Bean instance) => instance.toJson();

  dynamic toJson() => _$ProductAndroidList0BeanToJson(this);
}

class _FromJsonWrapper {
  static List<ProductAndroidList0Bean> _fromJsonList$ProductAndroidList0Bean$(
      dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((json) => ProductAndroidList0Bean.fromJson(json))
        .toList();
  }
}

class _ToJsonWrapper {
  static dynamic _toJsonList$ProductAndroidList0Bean$(
          List<ProductAndroidList0Bean> instance) =>
      instance.map((instance) => instance.toJson()).toList();
}
