import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:pariwisata_wonogiri/dashboard.dart';
import 'package:pariwisata_wonogiri/maps.dart';

Duration get loadTime => const Duration(milliseconds: 2250);

class Destination{
    dynamic id;
    dynamic namaDestinasi;
    dynamic deskripsi;
    dynamic lokasi;
    dynamic latitude;
    dynamic longitude;
    dynamic link;

    Destination._({ this.id, this.namaDestinasi, this.deskripsi, this.lokasi, this.latitude, this.longitude, this.link});

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination._(
      id: json['id'],
      namaDestinasi: json['nama_destinasi'],
      deskripsi: json['deskripsi'],
      lokasi: json['lokasi'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      link: json['link'],
    );
  }

} 

Future listData(int id) async {
    debugPrint("id : $id");
    var url = Uri.http('10.0.2.2:8000', 'api/list_tempat/$id');
    var response = await http.get(url);
    var list = json.decode(response.body)['messages'].map((data) => Destination.fromJson(data)).toList();
    return Future.delayed(loadTime).then((_) {
      return list;
    });
  }



class Detail extends StatefulWidget {
  final int id;
  // ignore: prefer_const_constructors_in_immutables
  @override
  Detail({Key? key, required this.id}) : super(key: key);
  
  _DetailState createState() => _DetailState();
  
  
}


class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        centerTitle:true, 
        title: const Text('Detail Destinasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(title:''),)),
        ), 
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            width: 360,
            child: FutureBuilder(
              future: listData(widget.id),
              builder: (BuildContext context, AsyncSnapshot snapshot){
              return  ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index){
                  if (snapshot.hasData){
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top : 10, right: 10),
                                  child: Image.asset('assets/image_example.png'),  
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10), 
                                      child: Text(
                                        snapshot.data[index].namaDestinasi,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, bottom:10, top:5), 
                                      child: Text(
                                        snapshot.data[index].lokasi,
                                        style:  const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11
                                        ),
                                      )
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, bottom:10, top:5), 
                                      child:  ConstrainedBox(
                                          constraints: const BoxConstraints(
                                          minWidth: 300.0,
                                          maxWidth: 300.0,
                                          minHeight: 30.0,
                                          maxHeight: 100.0,
                                        ), 
                                          child: AutoSizeText(
                                            snapshot.data[index].deskripsi,
                                            style:  const TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11
                                          ),
                                      )
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, bottom:10, top:5), 
                                      child: TextButton.icon(
                                        style: const ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll(Color(0xff68B569))
                                        ),
                                        onPressed: () { Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Maps(latitude: snapshot.data[index].latitude, longitude: snapshot.data[index].longitude )), (route) => false); }, 
                                        label: const Text(
                                          "Menuju Lokasi",
                                          style:  TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11
                                          ),
                                        ),
                                        icon:  const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white,
                                        ), 
                                      )
                                    ),
                                ],
                              ),
                        ],)
                    );
                  }
                }
                );
              }
            )
          )
        ),
      )
    )
    );
  }
}
