import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../service/api_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'hxz7cc3je7');
  runApp(const NaverAPI());
}

class NaverAPI extends StatefulWidget {
  const NaverAPI({Key? key}) : super(key: key);

  @override
  State<NaverAPI> createState() => _NaverAPIState();
}

class _NaverAPIState extends State<NaverAPI> {
  late NaverMapApi navermapAPI;

  @override
  void initState() {
    super.initState();
    navermapAPI = NaverMapApi(context);
    navermapAPI.determineLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: navermapAPI.initialCameraPosition,
        ),
        onMapReady: onMapReady,
        onCameraChange: onCameraChange,
      ),
    );
  }

  Future<void> onMapReady(NaverMapController controller) async {
    navermapAPI.mapController = controller;
    navermapAPI.determineLocation();
    NLocationOverlay locationOverlay =
        await navermapAPI.mapController.getLocationOverlay();
    locationOverlay.setIsVisible(true);
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    _onCameraChangeStreamController.sink.add(null);
  }

  final _onCameraChangeStreamController = StreamController<void>.broadcast();
}
