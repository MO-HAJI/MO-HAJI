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
  late NaverMapController mapController;
  late NCameraPosition initialCameraPosition = NCameraPosition(
    target: NLatLng(36.372935, 127.357785),
    zoom: 12.5,
  );
  late List<NMarker> markers = [];
  final HtmlUnescape htmlUnescape = HtmlUnescape();

  final String GPTmenu = "돈까스";

  @override
  void initState() {
    super.initState();
    determineLocation();
  }

  void determineLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Current Location: ${position.latitude}, ${position.longitude}");

      // Reverse geocoding to get the address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks.first;
        String city = firstPlacemark.subAdministrativeArea ?? "";
        String district = firstPlacemark.administrativeArea ?? "";
        String thoroughfare = firstPlacemark.thoroughfare ?? "";

        String addressDetails = "$city $district $thoroughfare";
        print("Current Address Details: $addressDetails");
        searchRestaurants("$addressDetails $GPTmenu");
      }
      ;

      setState(() {
        initialCameraPosition = NCameraPosition(
          target: NLatLng(position.latitude, position.longitude),
          zoom: 12.5,
        );
      });
    } catch (e) {
      print("Error getting location: $e");
      // Handle the exception, show a user-friendly message, or take appropriate action.
    }
  }

  Future<void> searchRestaurants(String menu) async {
    // Replace YOUR_CLIENT_ID and YOUR_CLIENT_SECRET with your Naver API credentials
    final clientId = "CNUovP26XK8Rq5om5db2";
    final clientSecret = "wNHLbFlkZJ";
    final apiUrl =
        "https://openapi.naver.com/v1/search/local.json"; // Updated endpoint

    final response = await http.get(
      Uri.parse(
        "$apiUrl?query=$menu&display=5",
      ),
      headers: {
        "X-Naver-Client-Id": clientId,
        "X-Naver-Client-Secret": clientSecret,
      },
    );

    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Extract restaurant information
      final List<dynamic> results = jsonResponse['items'];

      String id = '1';

      // Process the restaurant information as needed (e.g., display on the map)
      for (var result in results) {
        final String name = htmlUnescape.convert(result['title']);
        final String link = result['link'];
        final String category = result['category'];
        final String roadAddress = result['roadAddress'];
        final double lat = double.parse(result['mapy']);
        final double lng = double.parse(result['mapx']);
        final double Lat = lat / 10000000;
        final double Lng = lng / 10000000;

        // Add marker to the list with an ID
        final marker = NMarker(
          id: id,
          position: NLatLng(Lat, Lng),
        );

        marker.setOnTapListener((NMarker marker) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 1,
                minChildSize: 0.2,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Updated smaller handle centered at the top with reduced top margin
                        Center(
                          child: Container(
                            height: 4.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Html(
                            data:
                                '<div style="font-size: 18px; font-weight: bold;">$name</div>',
                          ),
                        ),
                        ListTile(
                          title: Text('Category:'),
                          subtitle: Text(category),
                        ),
                        ListTile(
                          title: Text('Road Address:'),
                          subtitle: Text(roadAddress),
                        ),
                        ListTile(
                          title: Text('Link:'),
                          subtitle: InkWell(
                            onTap: () {
                              // Open the link when tapped
                              launch(link);
                            },
                            child: Text(
                              link,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        });

        markers.add(marker);

        int nextId = int.parse(id) + 1;
        id = nextId.toString();

        // Add your logic to display or store restaurant information
        print(
            "Restaurant: $name, Category: $category, RoadAddress: $roadAddress, Link: $link, Location: $Lat, $Lng");
      }
      await mapController.addOverlayAll(
          {markers[0], markers[1], markers[2], markers[3], markers[4]});
    } else {
      print("Failed to fetch restaurants. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naver Map Example'),
      ),
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: initialCameraPosition,
        ),
        onMapReady: onMapReady,
        onCameraChange: onCameraChange,
      ),
    );
  }

  Future<void> onMapReady(NaverMapController controller) async {
    mapController = controller;
    determineLocation();
    NLocationOverlay locationOverlay = await mapController.getLocationOverlay();
    locationOverlay.setIsVisible(true);
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    _onCameraChangeStreamController.sink.add(null);
  }

  final _onCameraChangeStreamController = StreamController<void>.broadcast();
}
