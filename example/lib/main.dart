import 'package:flutter/material.dart';
import 'package:mx_env/mx_env.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ExamplePage(),
        ),
      ),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  void initState() {
    MxEnv.settingProject(
      appCode: 'futuresApp',
      build: ProjectBuild.release,
      url: Uri(
        scheme: 'https',
        host: 'download.ucx99.com',
      ),
      forceProductIf: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Plugin example app"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MxEnv.getUpdateInfo().then(
            (updateInfo) {
              print('更新資訊: $updateInfo');
            },
          );
        },
      ),
    );
  }
}
