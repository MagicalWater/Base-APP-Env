class ProjectBuild {
  final String _value;

  const ProjectBuild._internal(this._value);

  String get value => _value;

  static const debug = ProjectBuild._internal(ProjectBuild._debug);
  static const release = ProjectBuild._internal(ProjectBuild._release);
  static const product = ProjectBuild._internal(ProjectBuild._product);

  static const String _debug = "debug";
  static const String _release = "release";
  static const String _product = "product";
}
