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
      home: LiveMap(title: 'Flutter Map Home Page'),
    );
  }
}

class LiveMap extends StatefulWidget {
  LiveMap({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Map <double,double> trackPoints;

 // Marker marker;
  Circle circle;
  GoogleMapController _controller;



  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(32.222879347475896, 35.262176899589406),
    zoom: 14.4746,
  );

  // Future<Uint8List> getMarker() async {
  //   ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
  //   return byteData.buffer.asUint8List();
  // }

  void updateMarkerAndCircle(LocationData newLocalData, //Uint8List imageData
      ) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {

      print(""+newLocalData.latitude.toString()+","+newLocalData.longitude.toString());

      // marker = Marker(
      //     markerId: MarkerId("home"),
      //     position: latlng,
      //     rotation: newLocalData.heading,
      //     draggable: false,
      //     zIndex: 2,
      //     flat: true,
      //     anchor: Offset(0.5, 0.5),
      //     icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

     // Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      _locationTracker.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 500,
        //distanceFilter: distanceFilter,
      );

      updateMarkerAndCircle(location //imageData
      );

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }



      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {

          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, //imageData
          );
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: initialLocation,
       // markers: Set.of((marker != null) ? [marker] : []),
        //circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
            print(trackPoints);
          }),
    );
  }
}
