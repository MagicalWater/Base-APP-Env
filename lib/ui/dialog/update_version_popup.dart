import 'package:app_updater/app_updater.dart';
import 'package:flutter/material.dart';
import 'package:mx_core/mx_core.dart';
import 'package:mx_env/repository/version_repository.dart';

/// 更新版本dialog
/// 依序顯示titleWidget、progressWidgetBuilder
class UpdateVersionPopup extends StatefulWidget {
  /// 更新data
  final UpdateInfo data;

  /// dialog背景色
  final Color bgColor;

  /// 陰影
  final double elevation;

  /// 外框
  final ShapeBorder dialogShape;

  /// 水波紋容器裝飾
  final WaveStyle waveStyle;

  /// 內容padding
  final EdgeInsetsGeometry contentPadding;

  /// 主要水波紋顏色
  final Color waveColor;

  /// 次要水波紋顏色
  final Color secondWaveColor;

  /// 標題widget
  final Widget titleWidget;

  /// 更新時顯示進度Widget
  final ProgressWidgetBuilder progressWidgetBuilder;

  /// 下載按鈕
  final Widget buttonWidget;

  /// 更新進度Widget Shape
  final BoxShape waveProgressShape;

  const UpdateVersionPopup(
    this.data, {
    Key key,
    this.bgColor,
    this.elevation,
    this.dialogShape,
    this.waveStyle,
    this.contentPadding,
    this.waveColor,
    this.secondWaveColor,
    this.titleWidget,
    this.progressWidgetBuilder,
    this.buttonWidget,
    this.waveProgressShape,
  }) : super(key: key);

  @override
  _UpdateVersionPopupState createState() => _UpdateVersionPopupState();
}

class _UpdateVersionPopupState extends State<UpdateVersionPopup> {
  ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Card(
          color: widget.bgColor,
          elevation: widget.elevation,
          shape: widget.dialogShape,
          child: _bodyWidget(),
        ),
      ),
    );
  }

  /// 內容
  Widget _bodyWidget() {
    return Container(
      padding: widget.contentPadding ??
          EdgeInsets.symmetric(
            vertical: Screen.scaleA(15),
            horizontal: Screen.scaleA(20),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: widget.titleWidget ??
                Padding(
                  padding: EdgeInsets.only(bottom: Screen.scaleA(10)),
                  child: Text(
                    "有新版本：${widget.data.latestVersion}",
                    style: TextStyle(
                      fontSize: Screen.scaleA(20),
                      color: Colors.black,
                    ),
                  ),
                ),
          ),
          _buildBottomWidget(),
        ],
      ),
    );
  }

  /// 更新進度
  Widget _buildBottomWidget() {
    return Container(
      height: Screen.scaleA(45),
      child: StreamBuilder<DownloadData>(
        stream: AppUpdater.downloadStream,
        initialData: DownloadData.progress(0),
        builder: (context, snapshot) {
          if (!AppUpdater.isDownloading) controller?.setProgress(0);

          return IndexedStack(
            alignment: Alignment.center,
            index: AppUpdater.isDownloading ? 0 : 1,
            children: <Widget>[
              _buildWaveProgress(),
              _buildDownloadButton(),
            ],
          );
        },
      ),
    );
  }

  /// 下載進度條
  Widget _buildWaveProgress() {
    return WaveProgress(
      initProgress: 0,
      waveColor: widget.waveColor ?? Colors.redAccent,
      secondWaveColor: widget.secondWaveColor ?? Colors.redAccent,
      shape: widget.waveProgressShape ?? BoxShape.rectangle,
      style: widget.waveStyle ??
          WaveStyle(
            color: Colors.white,
            radius: Screen.scaleA(5),
            borderColor: Colors.redAccent,
            borderWidth: Screen.scaleA(1),
          ),
      onCreated: (controller) => this.controller = controller,
      progressStream:
          AppUpdater.downloadStream.map((o) => o.progress.toDouble()),
      builder: (context, progress, total) {
        if (widget.progressWidgetBuilder != null) {
          return widget.progressWidgetBuilder(context, progress, total);
        }
        return Align(
          alignment: Alignment.center,
          child: Text(
            "${(progress / total * 100).toInt()}%",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Screen.scaleA(18),
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  /// 下載按鈕
  Widget _buildDownloadButton() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialLayer(
        onTap: () {
          AppUpdater.update(
            widget.data.downloadUrl,
            openWeb: widget.data.openWebDownload,
          );
        },
        child: widget.buttonWidget ??
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Screen.scaleA(5)),
                color: Colors.redAccent,
              ),
              child: Text(
                "更新",
                style: TextStyle(
                  fontSize: Screen.scaleA(16),
                  color: Colors.white,
                ),
              ),
            ),
      ),
    );
  }
}
