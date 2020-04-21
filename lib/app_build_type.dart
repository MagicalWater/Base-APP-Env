/// 專案環境
class AppBuildType {
  final String _name;

  String get name => _name;

  static List<AppBuildType> get _definitions => [debug, release, product];

  static List<AppBuildType> get values => _definitions;

  static List<String> get names => _definitions.map((o) => o.name);

  const AppBuildType._(this._name);

  bool get isProduct => this == product;

  bool get isRelease => this == release || this == product;

  bool get isDebug => this == debug;

  static const debug = AppBuildType._("debug");

  static const release = AppBuildType._("release");

  static const product = AppBuildType._("product");
}
