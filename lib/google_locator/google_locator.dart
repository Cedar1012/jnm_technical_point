import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleLocator extends StatefulWidget {
  const GoogleLocator({Key? key}) : super(key: key);

  @override
  State<GoogleLocator> createState() => _GoogleLocatorState();
}

class _GoogleLocatorState extends State<GoogleLocator> {
  String _locator = '';
  List<Placemark> _locatorItems = [];
  void _incrementCounter() async {
    /// 校验是否启用了定位服务
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print('定位服务未启用 去设置');
      await Geolocator.openAppSettings();
      return;
    }

    ///  弹窗提醒用户 使用权限 或者 提示去设置
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openLocationSettings();
      print('权限被拒绝');
      return;
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      print('权限被永久拒绝');
      return;
    } else if (permission == LocationPermission.whileInUse) {
      print('只有使用app时间可以定位');
    } else if (permission == LocationPermission.always) {
      print('用户允许可以后台访问');
    }
    Position ps = await _determinePosition();
    print('纬度: ${ps.latitude}, 经度: ${ps.longitude}');

    List<Placemark> placemarks =
        await placemarkFromCoordinates(ps.latitude, ps.longitude);

    print(placemarks);
    setState(() {
      _locator = placemarks.toString();
      _locatorItems = placemarks;
    });
  }

  Future<Position> _determinePosition() async =>
      await Geolocator.getCurrentPosition();

  // administrativeArea:"北京市"
  // country:"中国"
  // isoCountryCode:"CN"
  // locality:"北京市"
  // name:"天元港中心B座"
  // postalCode:""
  // street:"北京市朝阳区天元港中心B座"
  // subAdministrativeArea:"麦子店街道"
  // subLocality:"朝阳区"
  // subThoroughfare:"丙2号"
  // thoroughfare:"东三环北路"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('谷歌定位')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('位置信息'),
            Column(
              children: _locatorItems
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '${_locatorItems.indexOf(e)} ${e.country} - ${e.isoCountryCode} - ${e.locality} - ${e.name} - ${e.street} - ${e.administrativeArea} - ${e.subThoroughfare} -  ${e.thoroughfare} ',
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
