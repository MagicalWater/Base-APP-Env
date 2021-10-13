import 'dart:async';
import 'dart:io';

import 'package:mx_env/bean/bean_converter.dart';
import 'package:mx_env/model/project_version.dart';
import 'package:mx_env/model/update_info.dart';
import 'package:mx_env/request/version_request_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

import 'model/project_build.dart';

export 'model/project_build.dart';
export 'model/update_info.dart';

part 'package:mx_env/repository/version_repository.dart';

class MxEnv {
  MxEnv._();

  /// 構建類型
  static ProjectBuild get build => _build;

  /// app的代碼
  static String get appCode => _appCode;

  /// 上次更新的暫存資訊
  static UpdateInfo? get latestInfo => _latestInfo;

  /// 構建類型
  static ProjectBuild _build = ProjectBuild.debug;

  /// app的代碼
  static String _appCode = '';

  /// 上次更新的暫存資訊
  static UpdateInfo? _latestInfo;

  static _VersionRepository _repository = _VersionRepository();

  // ignore: close_sinks
  static StreamController<ProjectBuild> _buildChangeController =
      StreamController();

  /// [build] 賦值時的串流
  static final Stream<ProjectBuild> buildStream =
      _buildChangeController.stream.asBroadcastStream();

  /// 設置專案
  /// [url] - 可以獲取到 product 與 version 文件的網址
  /// 後續根據下載的文件完整網址如下
  /// product文件 - [url]/web/[appCode]/[build.value]/version.json
  /// version文件 - [url]/web/[appCode]/product.json
  static void settingProject({
    required String appCode,
    required ProjectBuild build,
    required Uri url,
  }) {
    print('配置專案環境 $appCode(${build.value}) - $url');
    _appCode = appCode;
    _build = build;
    _repository._setUrl(url);
    _buildChangeController.add(_build);
  }

  /// 取得更新資訊
  static Stream<UpdateInfo> getUpdateInfo() {
    return _repository.getUpdateInfo().doOnData((event) {
      _latestInfo = event;
    });
  }
}
