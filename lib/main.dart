import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import './screens/map.dart';
import './services/geolocator_service.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final geoService= GeolocatorService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: ( context)=> geoService.getInitialLocation() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Maps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:Consumer<Position>(
          builder: (context, position, widget) {
            return (position != null)
                ? Map(initialPosition: position)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

