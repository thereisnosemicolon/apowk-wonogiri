import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('SIG Pariwisata Wonogiri')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    // center: LatLng(32.91081899999999, -92.734876),
                    center: LatLng(35.611909, -82.440682),
                    zoom: 14.0,
                    plugins: [EsriPlugin()],

                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                      'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    ),
                    FeatureLayerOptions("https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/USA_Congressional_Districts/FeatureServer/0",
                      "polygon",
                      onTap: (dynamic attributes, LatLng location) {
                        print(attributes);
                      },
                      render: (dynamic attributes){
                        // You can render by attribute
                        return const PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 2
                        );
                      },
                    
                    ),
                    FeatureLayerOptions(
                      "https://services.arcgis.com/V6ZHFr6zdgNZuVG0/arcgis/rest/services/Landscape_Trees/FeatureServer/0",
                      "point",
                      render:(dynamic attributes){
                        // You can render by attribute
                        return const PointOptions(
                          width: 30.0,
                          height: 30.0,
                          builder: Icon(Icons.pin_drop),
                        );
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                      },
                    ),
                    FeatureLayerOptions(
                      "https://services.arcgis.com/V6ZHFr6zdgNZuVG0/ArcGIS/rest/services/Denver_Streets_Centerline/FeatureServer/0",
                      "polyline",
                      render:(dynamic attributes){
                        // You can render by attribute
                        return PolygonLineOptions(
                            borderColor: Colors.red,
                            color: Colors.red,
                            borderStrokeWidth: 2
                        );
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}