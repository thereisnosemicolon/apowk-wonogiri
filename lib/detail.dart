import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pariwisata_wonogiri/dashboard.dart';

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





class Detail extends StatefulWidget {
  final int id;
  // ignore: prefer_const_constructors_in_immutables
  @override
  Detail({Key? key, required this.id}) : super(key: key);
  
  _DetailState createState() => _DetailState();
  
  
}


class _DetailState extends State<Detail> {
  final int id = 0;
  List _data = [];  

  @override
  void initState() {
        // ignore: todo
        // TODO: implement initState
        super.initState();
        _getData(id);
  }

  Future _getData(int id) async {
    debugPrint("this is id: $id");
    var url = Uri.http('10.0.2.2:8000', 'api/list_tempat/$id');
    var response = await http.get(url);
    final list = json.decode(response.body)['messages'];
    debugPrint("this is response : " + list);
    setState(() {
      //memasukan data yang di dapat dari internet ke variabel _get
      _data = list;
    });

    debugPrint("_data is : $_data");

    // return Future.delayed(loadTime).then((_) {
    //   return _data;
    // });
  }

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
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index){
                  debugPrint("test : " + _data[index]['id']);
                  if (_data.isNotEmpty){
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
                                        _data[index]['nama_destinasi'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ),
                                   Padding(padding: const EdgeInsets.only(top: 10, right: 10), 
                                      child: GestureDetector(
                                        onTap: () {
                                          debugPrint("Peler kontol memek");
                                        },
                                        child: const Text(
                                          "Menuju Lokasi",
                                          style:  TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8
                                          ),
                                        ),
                                      )
                                    )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, bottom:10), 
                                      child: Text(
                                        _data[index]['lokasi'],
                                        style:  const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8
                                        ),
                                      )
                                    ),
                                    const Padding(
                                      padding:  EdgeInsets.only(top: 10, bottom:10, right: 10), 
                                      child: Text(
                                        "DetailDestinasi",
                                        style:  TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8
                                        ),
                                      )
                                    )
                                ],
                              ),
                        ],)
                    );
                  }
                }
              )
          )
        ),
      )
    )
    );
  }
}
