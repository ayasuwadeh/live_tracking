import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
class Map extends StatefulWidget {
  final Position initialPosition;

  const Map({Key key, this.initialPosition}) : super(key: key);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final GeolocatorService geoService = GeolocatorService();
  List <LatLng> points=[];
  Completer <GoogleMapController> _controller=Completer();

  @override
  void initState() {
    geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: missing_required_param
      body:Center(child: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.satellite,
        initialCameraPosition:CameraPosition(
            target: LatLng(widget.initialPosition.latitude,widget.initialPosition.longitude),
            zoom: 18) ,
        onMapCreated: (GoogleMapController controller)
        {
          _controller.complete(controller);
        },
      ),),
      floatingActionButton: FloatingActionButton(onPressed: draw,) ,
    );
  }
  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
    points.add(LatLng(position.latitude, position.longitude));

  }

  void draw() {

  }
}
