import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
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
      appBar: AppBar(
        title: const Text('Naver Map Example'),
      ),
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
    NLocationOverlay locationOverlay = await navermapAPI.mapController.getLocationOverlay();
    locationOverlay.setIsVisible(true);
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    _onCameraChangeStreamController.sink.add(null);
  }

  final _onCameraChangeStreamController = StreamController<void>.broadcast();
}
