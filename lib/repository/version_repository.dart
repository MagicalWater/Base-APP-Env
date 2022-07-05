part of 'package:mx_env/mx_env.dart';

/// 版本相關倉庫
class _VersionRepository {
  final _request = VersionRequest();

  // 發布列表本地的快取key
  final _productListKey = 'productList';

  void _setUrl(Uri url) {
    _request.host = url.host;
    _request.scheme = url.scheme;
  }

  /// 取得專案版本
  /// 當專案版本為 [ProjectBuild.release] 時, 會再檢查版本號是否為 product 版本
  Future<ProjectVersion> getProjectVersion(String appCode, ProjectBuild build) {
    /// 檢查版本是否為product版本
    bool isProductVersion({
      required ProductBean productBean,
      required String verName,
      required int verCode,
    }) {
      if (build == ProjectBuild.debug) {
        return false;
      }

      final webProducts =
          (Platform.isAndroid ? productBean.android : productBean.ios) ?? [];

      // 專案是否為 product
      final isProduct = webProducts.any((product) {
        var code = product.versionCode;
        var name = product.versionName;
        return code == verCode && name == verName;
      });

      return isProduct;
    }

    /// 取得版本的發布列表
    Future<ProductBean> _getProductList() {
      HttpClientResponse? response;
      return _request
          .getProduct(appCode)
          .then((value) {
            response = value;
            return value.transform(utf8.decoder).single;
          })
          .then((value) => BeanConverter.convert<ProductBean>(value)!)
          .onError((error, stackTrace) {
            if (response?.statusCode != 200) {
              final errorText =
                  '${response?.statusCode}(${response?.reasonPhrase})';
              print('錯誤: 獲取發布文件出錯 - $errorText');
            }
            return Future.error(error!, stackTrace);
          })
          .then((value) {
            print('將發布版本資料存入本地');
            print('${value.ios?.map((e) => '${e.versionName}+${e.versionCode}')}');
            // 將資料存入本地
            final jsonData = value.toJson();
            final jsonString = json.encode(jsonData);

            return SharedPreferences.getInstance().then((preference) {
              return preference.setString(_productListKey, jsonString);
            }).then((_) => value);
          })
          .onError((error, stackTrace) {
            // 嘗試從本地取出
            print('更改為嘗試從本地取出發布列表');
            return SharedPreferences.getInstance().then((preference) {
              return preference.getString(_productListKey);
            }).then((value) {
              if (value != null && value.isNotEmpty) {
                final jsonData = json.decode(value);
                final bean = ProductBean.fromJson(jsonData);
                print('成功取出本地發布列表');
                print('${bean.ios?.map((e) => '${e.versionName}+${e.versionCode}')}');
                return bean;
              } else {
                print('本地無快取, 直接拋出錯誤');
              }
              return Future.error(error!, stackTrace);
            });
          });
    }

    final infoFuture = PackageInfo.fromPlatform();

    final productFuture = _getProductList();

    return Future.wait([
      infoFuture,
      productFuture,
    ]).then((value) {
      final packageInfo = value[0] as PackageInfo;
      final productBean = value[1] as ProductBean;

      // 當前專案的版本
      final currentVersionName = packageInfo.version;
      final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      // 專案是否為 product
      final isProduct = isProductVersion(
        productBean: productBean,
        verName: currentVersionName,
        verCode: currentVersionCode,
      );

      return ProjectVersion(
        name: packageInfo.version,
        code: int.tryParse(packageInfo.buildNumber) ?? 0,
        build: isProduct ? ProjectBuild.product : build,
      );
    });
  }

  /// 檢查線上版本, 並且取得更新資訊
  Future<UpdateInfo> getUpdateInfoFromWeb(
    String appCode,
    ProjectVersion projectVersion,
  ) {
    HttpClientResponse? response;
    return _request
        .getVersion(appCode, projectVersion.build.value)
        .then((value) {
          response = value;
          return value.transform(utf8.decoder).single;
        })
        .then((value) => BeanConverter.convert<WebVersionBean>(value)!)
        .onError((error, stackTrace) {
          if (response?.statusCode != 200) {
            final errorText =
                '${response?.statusCode}(${response?.reasonPhrase})';
            print('錯誤: 獲取版本文件出錯 - $errorText');
          }
          return Future.error(error!, stackTrace);
        })
        .then((value) => _convertToUpdateInfo(
              appCode: appCode,
              currentVersion: projectVersion,
              bean: value,
            ));
  }

  /// ===================== 以下為資料轉換 =====================
  UpdateInfo _convertToUpdateInfo({
    required String appCode,
    required ProjectVersion currentVersion,
    required WebVersionBean bean,
  }) {
    Map<String, dynamic> configMap = bean.config ?? {};

    final platformBean = bean.package;

    // 取得最新強制更新的版本號碼
    final forceVersionCode = platformBean?.force ?? 0;

    // 此版本是否忽略
    final ignore = platformBean?.ignore ?? false;

    // 更新url
    String updateUrl;

    // 是否使用web開啟
    bool isUrlOpenWeb;

    if (currentVersion.isProduct) {
      updateUrl = platformBean?.product?.url ?? '';
      isUrlOpenWeb = platformBean?.product?.openWeb ?? true;
    } else {
      updateUrl = platformBean?.dev?.url ?? '';
      isUrlOpenWeb = platformBean?.dev?.openWeb ?? true;
    }

    final latestVersionName = platformBean?.versionName ?? '0.0.0';
    final latestVersionCode = platformBean?.versionCode ?? 0;

    return UpdateInfo(
      appCode: appCode,
      forceVersionCode: forceVersionCode,
      isIgnore: ignore,
      url: updateUrl,
      configMap: configMap,
      message: platformBean?.message ?? '',
      openWeb: isUrlOpenWeb,
      build: currentVersion.build,
      current: currentVersion,
      latest: ProjectVersion(
        name: latestVersionName,
        code: latestVersionCode,
        build: currentVersion.build,
      ),
    );
  }
}
