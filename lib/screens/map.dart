import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
class LiveMap extends StatefulWidget {
  final Position initialPosition;

  const LiveMap({Key key, this.initialPosition}) : super(key: key);
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  final GeolocatorService geoService = GeolocatorService();
  List <LatLng> points=[];
  List <int> seq=[];
  Completer <GoogleMapController> _controller=Completer();
  Map <PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  int _pointId=0;
  Set<Marker> markers = {};
  Marker startMarker;
  StreamSubscription streamSubscription;
// Destination Location Marker
//   Marker destinationMarker = Marker(
//     markerId: MarkerId('destination'),
//     position: LatLng(
//       destinationCoordinates.latitude,
//       destinationCoordinates.longitude,
//     ),
//     infoWindow: InfoWindow(
//       title: 'Destination',
//       snippet: _destinationAddress,
//     ),
//     icon: BitmapDescriptor.defaultMarker,
//   );


  @override
  void initState() {
    _setInitialMarker(geoService.getInitialLocation());

    streamSubscription=geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: missing_required_param
      body:Center(child: GoogleMap(
        polylines: Set<Polyline>.of(_mapPolylines.values),
        myLocationEnabled: true,
        mapType: MapType.satellite,
        markers: markers != null ? Set<Marker>.from(markers) : null,
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
    //// adding positions and sequences
    points.add(LatLng(position.latitude, position.longitude));
    seq.add(_pointId);
    // print(position);
    if(_pointId>0)
    draw();

    _pointId++;

  }

  void draw() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);
    LatLng firstPoint=points[_pointId-1];
    LatLng secondPoint=points[_pointId];
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.deepOrange,
      width: 3,
      points: [firstPoint,secondPoint],
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  void _setInitialMarker(Future<Position> initialLocation) async {
    // Start Location Marker
     startMarker = Marker(
      markerId: MarkerId('start'),
      position: LatLng(
        widget.initialPosition.latitude,
        widget.initialPosition.longitude
      ),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: "initial point",
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
markers.add(startMarker);
  }
}
