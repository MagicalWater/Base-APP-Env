import 'package:mx_env/model/project_build.dart';

class ProjectVersion {
  final String name;
  final int code;
  final ProjectBuild build;

  bool get isProduct => build == ProjectBuild.product;

  ProjectVersion({
    required this.name,
    required this.code,
    required this.build,
  });

  bool operator <(ProjectVersion other) {
    return code < other.code;
  }

  bool operator <=(ProjectVersion other) {
    return code <= other.code;
  }

  bool operator >(ProjectVersion other) {
    return code > other.code;
  }

  bool operator >=(ProjectVersion other) {
    return code >= other.code;
  }

  @override
  bool operator ==(other) {
    if (other is ProjectVersion) {
      return code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
