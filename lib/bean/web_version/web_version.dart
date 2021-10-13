class WebVersionBean {
  Map<String, dynamic>? config;
  WebVersionAndroidBean? android;
  WebVersionAndroidBean? ios;

  WebVersionBean({
    this.config,
    this.android,
    this.ios,
  });

  WebVersionBean.fromJson(Map<String, dynamic> json) {
    config = json['config'];
    android = json['android'] != null
        ? WebVersionAndroidBean.fromJson(json['android'])
        : null;
    ios = json['ios'] != null
        ? WebVersionAndroidBean.fromJson(json['ios'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'config': config,
      'android': android?.toJson(),
      'ios': ios?.toJson(),
    };
  }
}

class WebVersionAndroidBean {
  String? message;
  String? versionName;
  int? versionCode;
  WebVersionAndroidDevBean? dev;
  WebVersionAndroidDevBean? product;
  bool? ignore;
  int? force;

  WebVersionAndroidBean({
    this.message,
    this.versionName,
    this.versionCode,
    this.dev,
    this.product,
    this.ignore,
    this.force,
  });

  WebVersionAndroidBean.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    versionName = json['versionName']?.toString();
    versionCode = json['versionCode'];
    dev = json['dev'] != null
        ? WebVersionAndroidDevBean.fromJson(json['dev'])
        : null;
    product = json['product'] != null
        ? WebVersionAndroidDevBean.fromJson(json['product'])
        : null;
    ignore = json['ignore'];
    force = json['force'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'versionName': versionName,
      'versionCode': versionCode,
      'dev': dev?.toJson(),
      'product': product?.toJson(),
      'ignore': ignore,
      'force': force,
    };
  }
}

class WebVersionAndroidDevBean {
  String? url;
  bool? openWeb;

  WebVersionAndroidDevBean({
    this.url,
    this.openWeb,
  });

  WebVersionAndroidDevBean.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    openWeb = json['openWeb'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'openWeb': openWeb,
    };
  }
}
