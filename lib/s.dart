import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: aa(),
    );
  }
}

class aa extends StatefulWidget {
  @override
  _aaState createState() => _aaState();
}

class _aaState extends State<aa> {
  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(32.2270189,35.2230851));
    points.add(LatLng(32.22691,35.22428));
    points.add(LatLng(32.22676,35.22451));
    points.add(LatLng(32.22517,35.23126));
    points.add(LatLng(32.22566,35.23633));
    points.add(LatLng(32.22708,35.23907));
    return points;
  }
  // 32.2227,35.2621983
  // I/flutter (21518): 32.2227,35.2621983
  // I/flutter (21518): 32.2308983,35.2413
  // I/flutter (21518): 32.2310219,35.242898
  // I/flutter (21518): 32.2308798,35.24413
  // I/flutter (21518): 32.2301506,35.2475974
  // I/flutter (21518): 32.2300381,35.2478513
  // I/flutter (21518): 32.2298022,35.2484777
  // I/flutter (21518): 32.2295734,35.2490562
  // I/flutter (21518): 32.2293729,35.2494904
  void _add() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 5,
      points: _createPoints(),
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: _add)],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 4.0),
        polylines: Set<Polyline>.of(_mapPolylines.values),
      ),
    );
  }


}

