import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jnm_technical_point/camera/camera_widget.dart';
import 'package:jnm_technical_point/google_locator/google_locator.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [
    {
      'text': '谷歌地图',
      'page': const GoogleLocator(),
    },
    {
      'text': '相机',
      'page': CameraExampleHome(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目录'),
      ),
      body: ListView(
          children: items
              .map<Widget>(
                (e) => ListTile(
                  title: Text(e['text']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => e['page']),
                  ),
                ),
              )
              .toList()),
    );
  }
}
