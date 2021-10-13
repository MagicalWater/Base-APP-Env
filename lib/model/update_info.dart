import 'package:mx_env/model/project_build.dart';

import 'project_version.dart';

/// 更新行為
enum UpdateAction {
  /// 需要跳出更新, 強制更新, 不可取消
  forceUpdate,

  /// 需要跳出更新, 可以取消
  cancelableUpdate,

  /// 不跳更新
  noUpdate,
}

/// 更新資訊
class UpdateInfo {
  /// 需要執行的更新行為
  /// 1. 有更新, 強制 (不管是否忽略) => 跳出更新, 不可取消
  /// 2. 有更新, 可選, 不忽略 => 跳出更新, 可取消
  /// 3. 有更新, 可選, 忽略 => 不跳更新
  /// 4. 其餘 => 不跳更新
  UpdateAction get action {
    if (haveNew && isForce) {
      return UpdateAction.forceUpdate;
    } else if (haveNew && !isForce) {
      return UpdateAction.cancelableUpdate;
    } else {
      return UpdateAction.noUpdate;
    }
  }

  /// 是否為強制更新
  bool get isForce {
    if (forceVersionCode > current.code) {
      return true;
    }
    return false;
  }

  /// 是否為忽略版本
  final bool isIgnore;

  /// 是否有更新
  bool get haveNew {
    return latest > current;
  }

  /// 連結網址是否為開啟 web, 若不是則為下載
  final bool openWeb;

  /// 更新的連結網址
  final String url;

  /// 更新內容
  final String message;

  /// 自訂義設定檔
  final Map<String, dynamic> configMap;

  /// 強制更新的最新版本號碼
  final int forceVersionCode;

  /// 線上最新版本
  final ProjectVersion latest;

  /// 當前專案版本名稱
  final ProjectVersion current;

  /// 請求API時的buildType
  final ProjectBuild build;

  /// 請求時API的appCode
  final String appCode;

  @override
  String toString() {
    return '''
更新資訊
===
專案代碼 - $appCode
專案環境 - ${build.value}
${_getActionShow()}
更新網址(${openWeb ? '網頁' : '下載'}) - $url
更新內容 - $message
當前版本 - ${current.name}+${current.code}
最新版本 - ${latest.name}+${latest.code}
強制更新的最後版號 - $forceVersionCode
個性化配置 - $configMap
    ''';
  }

  UpdateInfo({
    required this.appCode,
    required this.build,
    required this.isIgnore,
    required this.openWeb,
    required this.url,
    required this.message,
    required this.configMap,
    required this.forceVersionCode,
    required this.latest,
    required this.current,
  });

  String _getActionShow() {
    switch (action) {
      case UpdateAction.forceUpdate:
        return '有新版本 - 強制更新';
      case UpdateAction.cancelableUpdate:
        return '有新版本 - 可選更新';
      case UpdateAction.noUpdate:
        if (haveNew) {
          return '有新版本 - 忽略';
        } else {
          return '無新版本';
        }
    }
  }

  @override
  bool operator ==(other) {
    if (other is UpdateInfo) {
      return isIgnore == other.isIgnore &&
          openWeb == other.openWeb &&
          url == other.url &&
          forceVersionCode == other.forceVersionCode &&
          latest == other.latest;
    }
    return super == other;
  }

  @override
  int get hashCode => super.hashCode;
}
