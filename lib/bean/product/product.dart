class ProductBean {
  List<ProductAndroidBean>? android;
  List<ProductAndroidBean>? ios;

  ProductBean({
    this.android,
    this.ios,
  });

  ProductBean.fromJson(Map<String, dynamic> json) {
    if (json['android'] != null) {
      android = (json['android'] as List)
          .map((e) => ProductAndroidBean.fromJson(e))
          .toList();
    }
    if (json['ios'] != null) {
      ios = (json['ios'] as List)
          .map((e) => ProductAndroidBean.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'android': android?.map((e) => e.toJson()).toList(),
      'ios': ios?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductAndroidBean {
  String? versionName;
  int? versionCode;

  ProductAndroidBean({
    this.versionName,
    this.versionCode,
  });

  ProductAndroidBean.fromJson(Map<String, dynamic> json) {
    versionName = json['versionName']?.toString();
    versionCode = json['versionCode'];
  }

  Map<String, dynamic> toJson() {
    return {
      'versionName': versionName,
      'versionCode': versionCode,
    };
  }
}
