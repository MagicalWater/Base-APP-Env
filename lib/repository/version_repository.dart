import 'dart:io';

import 'package:app_updater/app_updater.dart';
import 'package:mx_env/app_build_type.dart';
import 'package:mx_env/bean/bean_converter.dart';
import 'package:mx_env/service/version_request_service.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

/// 版本相關倉庫
class VersionRepository {
  final _service = VersionRequestService();

  static final VersionRepository _instance = VersionRepository._();

  VersionRepository._();

  static VersionRepository getInstance() => _instance;

  factory VersionRepository() => getInstance();

  /// 下載更新進度串流
  Stream<DownloadData> get updateStream => AppUpdater.downloadStream;

  /// 取得當前專案環境
  AppBuildType get appBuildType => _buildTypeSubject.value?.appBuildType;

  /// 監聽專案環境Stream
  Stream<AppBuildType> get buildTypeStream =>
      _buildTypeSubject.stream.where((v) => !v.ignore).map((v) => v.appBuildType);

  /// 專案環境Subject
  BehaviorSubject<BuildTypeData> _buildTypeSubject = BehaviorSubject();

  /// 設置專案環境
  /// [ignore] 是否忽略更新subject串流
  void setAppBuildType(AppBuildType buildType, {bool ignore = false}) {
    print("mx_env 檢測到設置專案環境 ${buildType.name}");
    _buildTypeSubject.add(BuildTypeData(ignore, buildType));
  }

  /// 取得更新App資訊
  /// [appCode] 專案名稱 ex：streamFk、streamDo、media
  Observable<UpdateInfo> getUpdateInfo(String appCode) {
    bool isAndroid = Platform.isAndroid;
    Observable<PackageInfo> packageInfoObs = Observable.fromFuture(PackageInfo.fromPlatform());

    if (appBuildType == null) {
      throw "appBuildType為空，請先設置setAppBuildType";
    }

    return Observable.zip2<PackageInfo, ProductBean, CurrentVersionData>(packageInfoObs, _getProduct(appCode),
        (packageInfo, productBean) {
      var targets = isAndroid ? productBean.android : productBean.ios;

      // 判斷是否為product
      bool isProduct = targets.any((target) =>
          target?.versionCode?.toString() == packageInfo.buildNumber &&
          target?.versionName == packageInfo.version);

      if (isProduct && appBuildType.isRelease) {
        setAppBuildType(AppBuildType.product);
      }

      return CurrentVersionData(
        packageInfo: packageInfo,
        buildType: appBuildType,
      );
    }).flatMap((versionData) => _getVersion(appCode, versionData));
  }

  /// 執行下載更新APP
  Future<void> updateApp(String url, {bool openWeb = true}) {
    return AppUpdater.update(url, openWeb: openWeb);
  }

  /// 取得線上版本紀錄
  Observable<ProductBean> _getProduct(String appCode) {
    return _service
        .getProduct(appCode)
        .map((response) => BeanConverter.convert<ProductBean>(response.getString()));
  }

  /// 取得線上版本資訊
  Observable<UpdateInfo> _getVersion(String appCode, CurrentVersionData versionData) {
    bool isAndroid = Platform.isAndroid;

    return _service
        .getVersion(appCode, versionData.buildType.name)
        .map((response) => BeanConverter.convert<WebVersionBean>(response.getString()))
        .map((bean) {
      Map<String, dynamic> configMap = _convertVersionConfigMap(bean);

      // 對應手機系統bean
      var platformBean = isAndroid ? bean?.android : bean?.ios;
      // 線上最後版本
      var latestVersion = platformBean?.versionCode;
      // 是否忽略線上這個版本
      var ignore = platformBean?.ignore ?? false;
      // 更新url
      var downloadUrl;
      // 是否使用web開啟
      var openWebDownload = false;

      if (versionData.buildType.isProduct) {
        downloadUrl = platformBean?.product?.url;
        openWebDownload = platformBean?.product?.openWeb;
      } else {
        downloadUrl = platformBean?.dev?.url;
        openWebDownload = platformBean?.dev?.openWeb;
      }

      return UpdateInfo(
        needUpdate: !ignore && latestVersion > int.tryParse(versionData.packageInfo.buildNumber),
        downloadUrl: downloadUrl,
        configMap: configMap,
        latestVersion: platformBean?.versionName,
        latestVersionCode: platformBean?.versionCode,
        updateMessage: platformBean?.message,
        openWebDownload: openWebDownload,
        buildType: versionData.buildType,
        currentVersionCode: int.tryParse(versionData.packageInfo.buildNumber),
        currentVersionName: versionData.packageInfo.version,
        appCode: appCode,
      );
    });
  }

  /// 轉換自訂義configMap
  Map<String, dynamic> _convertVersionConfigMap(WebVersionBean webVersionBean) {
    if (webVersionBean.config == null) {
      return null;
    }

    var json = webVersionBean.toJson();
    Map<String, dynamic> configMap;

    if (json is Map<String, dynamic> && json.containsKey("config")) {
      configMap = json["config"];
    }
    return configMap;
  }
}

class BuildTypeData {
  /// 是否忽略觸發stream
  final bool ignore;

  /// 專案環境
  final AppBuildType appBuildType;

  BuildTypeData(this.ignore, this.appBuildType);
}

/// 當前版本相關資訊
class CurrentVersionData {
  /// 當前版本資訊
  final PackageInfo packageInfo;

  /// 打包類型
  final AppBuildType buildType;

  CurrentVersionData({this.packageInfo, this.buildType});
}

class UpdateInfo {
  /// 是否需要更新，true為需要更新
  final bool needUpdate;

  /// 是否採取開啟web更新
  final bool openWebDownload;

  /// 下載更新檔案位置
  final String downloadUrl;

  /// 線上最新版本號名稱
  final String latestVersion;

  /// 線上最新版本號
  final int latestVersionCode;

  /// 更新內容
  final String updateMessage;

  /// 自訂義設定檔
  final Map<String, dynamic> configMap;

  /// 當前專案版本號
  final int currentVersionCode;

  /// 當前專案版本名稱
  final String currentVersionName;

  /// 請求API時的buildType
  final AppBuildType buildType;

  /// 請求時API的appCode
  final String appCode;

  UpdateInfo({
    this.needUpdate,
    this.openWebDownload,
    this.downloadUrl,
    this.latestVersion,
    this.latestVersionCode,
    this.updateMessage,
    this.configMap,
    this.currentVersionCode,
    this.currentVersionName,
    this.buildType,
    this.appCode,
  });
}
