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
    super.initState();

    VersionRepository.getInstance().buildTypeStream.listen((v) {
      print("buildTypeStream ${v.name}");
    });
    VersionRepository.getInstance().setAppBuildType(AppBuildType.release, ignore: true);
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
          VersionRepository().getUpdateInfo("streamDo").listen(
            (updateInfo) {
              var a = updateInfo;
              if (updateInfo.needUpdate) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => UpdateVersionPopup(
                    updateInfo,
//                    titleWidget: Column(
//                      children: <Widget>[
//                        Image.asset("assets/images/ic_update_version.png"),
//                        Text(
//                          "${updateInfo.latestVersionCode}",
//                          style: TextStyle(color: Colors.red),
//                        ),
//                      ],
//                    ),
//                    progressWidgetBuilder: (context, progress, total) {
//                      return Align(
//                        alignment: Alignment.center,
//                        child: Text(
//                          "我正在${(progress / total * 100).toInt()}%",
//                        ),
//                      );
//                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
