import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pariwisata_wonogiri/dashboard.dart';


class Maps extends StatefulWidget{
 
  //  final String? latitude;
  //  final String? longitude;
  String latitude = "";
  String longitude = "";
    @override
   Maps({Key? key, required this.latitude, required this.longitude}) : super(key: key);
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDh4ivj6ei7xdx2SCfKzQSd2h-XlqqbQEA";
  
  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  String latitude = "";
  String longitude = "";
  LatLng startLocation = const LatLng(-7.837485711182153, 110.89955274010913);  
  LatLng endLocation = const LatLng(-7.854320361584187, 110.9104510598748);         

  @override
  void initState() {
    latitude = widget.latitude;
    longitude = widget.longitude;
    var newLatitude = double.parse(widget.latitude);
    var newLongitude = double.parse(widget.longitude);

    startLocation = const LatLng(-7.837485711182153, 110.89955274010913);  
    endLocation =  LatLng(newLongitude, newLatitude); 
  
     markers.add(Marker( //add start location marker
        markerId: MarkerId(startLocation.toString()),
        position: startLocation, //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Starting Point ',
          snippet: 'Your Location',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add distination location marker
        markerId: MarkerId(endLocation.toString()),
        position: endLocation, //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Destination Point ',
          snippet: 'Destination Marker',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      
      getDirections(); //fetch direction polylines from Google API
      
    super.initState();
  }

  getDirections() async {
      latitude = widget.latitude;
      longitude = widget.longitude;
      var newLatitude = double.parse(widget.latitude);
      var newLongitude = double.parse(widget.longitude);

      startLocation = const LatLng(-7.837485711182153, 110.89955274010913);  
      endLocation = LatLng(newLongitude, newLatitude); 
      List<LatLng> polylineCoordinates = [];
     
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPiKey,
          PointLatLng(startLocation.latitude, startLocation.longitude),
          PointLatLng(endLocation.latitude, endLocation.longitude),
          travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
            result.points.forEach((PointLatLng point) {
                polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
      } else {
         print(result.errorMessage);
      }
      addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    debugPrint("this is new location : $endLocation");
    return
        MaterialApp(
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                    fontFamily: 'Inter',
                    bodyColor: Colors.black,
                    displayColor: Colors.black),
            primarySwatch: Colors.green 
          ),
          home: Scaffold(
              backgroundColor: Colors.green.shade50 ,
              appBar: AppBar( 
                title: const Text("Map Routes"),
                centerTitle:true,
                leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(title:''),)),
        ), 
              ),
              body: GoogleMap( //Map widget from google_maps_flutter package
                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                        initialCameraPosition: CameraPosition( //innital position in map
                          target: startLocation, //initial position
                          zoom: 16.0, //initial zoom level
                        ),
                        markers: markers, //markers to show on map
                        polylines: Set<Polyline>.of(polylines.values), //polylines
                        mapType: MapType.normal, //map type
                        onMapCreated: (controller) { //method called when map is created
                          setState(() {
                            mapController = controller; 
                          });
                        },
                  ),
          )
        );
  }
}