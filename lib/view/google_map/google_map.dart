
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:map_location_picker/google_map_location_picker.dart';

import '../../app_config.dart';


class GoogleMapPoliline extends StatefulWidget {
  final double lat;
  final double lng;
  final String address;
  const GoogleMapPoliline({super.key, required this.lat, required this.lng, required this.address});

  @override
  State<GoogleMapPoliline> createState() => _GoogleMapPolilineState();
}

class _GoogleMapPolilineState extends State<GoogleMapPoliline> {
  // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  double? _originLatitude, _originLongitude;
  double? _destLatitude, _destLongitude;
  bool isLoading = false;
  Future<Position> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }


  GoogleMapController? mapController;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = AppConfig.MAP_API;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation().then((value) {
      setState(() {
        _originLatitude = value.latitude;
        _originLongitude = value.longitude;
        _destLatitude = widget.lat;
        _destLongitude = widget.lng;
      });

      print(widget.lat);
      print("value.latitude ${value.latitude}");


      //call all function
      /// origin marker
      _addMarker(LatLng(_originLatitude!, _originLongitude!), "origin",
          BitmapDescriptor.defaultMarker);

      /// destination marker
      _addMarker(LatLng(_destLatitude!, _destLongitude!), "destination",
          BitmapDescriptor.defaultMarkerWithHue(90));
      _getPolyline();
      isLoading = false;
    });


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar( title: Text(widget.address),),
        body: isLoading ? Center(child: CircularProgressIndicator(),) : GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(_originLatitude!, _originLongitude!), zoom: 14),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
        ),

      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude!, _originLongitude!),
        PointLatLng(_destLatitude!, _destLongitude!),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "${widget.address}")]);

    print("result === ${result.points}");
    print("result === ${_originLatitude} ${_originLongitude} ${_destLatitude} ${_destLongitude}");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {

        print("poly lat lng === ${point.latitude} ${point.longitude}");
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
