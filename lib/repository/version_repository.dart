part of 'package:mx_env/mx_env.dart';

/// 版本相關倉庫
class _VersionRepository {
  final _request = VersionRequestClient();

  ProductBean? _productListCache;

  /// 檢查版本是否為product版本
  bool _isReleaseVersionProduct(
      {required String verName, required int verCode}) {
    var webProducts = (Platform.isAndroid
            ? _productListCache!.android
            : _productListCache!.ios) ??
        [];

    // 專案是否為 product
    bool isProduct = webProducts.any((product) {
      var code = product.versionCode;
      var name = product.versionName;
      return code == verCode && name == verName;
    });

    return isProduct;
  }

  void _setUrl(Uri url) {
    _request.host = url.host;
    _request.scheme = url.scheme;
  }

  /// 更新專案環境
  /// 當專案版本為 [ProjectBuild.release] 時, 檢查版本號是否為 product 版本
  /// 若檢查為 product, 則會自動更改 [MxEnv.build] 的值
  Stream<ProjectVersion> updateProjectBuild() {
    Stream<PackageInfo> infoStream =
        Stream.fromFuture(PackageInfo.fromPlatform());

    Stream<ProductBean> productStream = _getProductList();

    return ZipStream.zip2<PackageInfo, ProductBean, ProjectVersion>(
      infoStream,
      productStream,
      (packageInfo, productBean) {
        // 伺服器上的 product 版本列表
        _productListCache = productBean;

        // 當前專案的版本
        var currentVersionName = packageInfo.version;
        var currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

        // 專案是否為 product
        bool isProduct = _isReleaseVersionProduct(
          verName: currentVersionName,
          verCode: currentVersionCode,
        );

        return ProjectVersion(
          name: packageInfo.version,
          code: int.tryParse(packageInfo.buildNumber) ?? 0,
          build: isProduct ? ProjectBuild.product : MxEnv.build,
        );
      },
    ).doOnData((event) {
      if (MxEnv.build != event.build) {
        MxEnv._build = event.build;
        MxEnv._buildChangeController.add(event.build);
      }
    });
  }

  /// 取得更新App資訊
  Stream<UpdateInfo> getUpdateInfo() {
    return updateProjectBuild().flatMap((value) => _getVersionInfo(value));
  }

  /// 取得版本的發布列表
  Stream<ProductBean> _getProductList() {
    var requestFuture = _request.getProduct(MxEnv.appCode);
    return Stream.fromFuture(requestFuture)
        .map((response) => BeanConverter.convert<ProductBean>(response)!);
  }

  /// 取得線上版本資訊
  Stream<UpdateInfo> _getVersionInfo(ProjectVersion currentVersion) {
    var requestFuture = _request.getVersion(MxEnv.appCode, MxEnv.build.value);
    return Stream.fromFuture(requestFuture)
        .map((response) => BeanConverter.convert<WebVersionBean>(response)!)
        .map((bean) =>
            _convertToUpdateInfo(currentVersion: currentVersion, bean: bean));
  }

  /// ===================== 以下為資料轉換 =====================
  ///
  UpdateInfo _convertToUpdateInfo(
      {required ProjectVersion currentVersion, required WebVersionBean bean}) {
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

    var latestVersionName = platformBean?.versionName ?? '0.0.0';
    var latestVersionCode = platformBean?.versionCode ?? 0;

    // 專案是否為 product
    late ProjectBuild lastBuild;

    if (currentVersion.build == ProjectBuild.debug) {
      lastBuild = currentVersion.build;
    } else {
      var isProduct = _isReleaseVersionProduct(
        verName: latestVersionName,
        verCode: latestVersionCode,
      );
      lastBuild = isProduct ? ProjectBuild.product : ProjectBuild.release;
    }

    return UpdateInfo(
      appCode: MxEnv.appCode,
      forceVersionCode: forceVersionCode,
      isIgnore: ignore,
      url: updateUrl,
      configMap: configMap,
      message: platformBean?.message ?? '',
      openWeb: isUrlOpenWeb,
      build: MxEnv.build,
      current: currentVersion,
      latest: ProjectVersion(
        name: latestVersionName,
        code: latestVersionCode,
        build: lastBuild,
      ),
    );
  }
}
