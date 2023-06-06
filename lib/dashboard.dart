import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pariwisata_wonogiri/detail.dart';

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

Future listData() async {
    var url = Uri.http('10.0.2.2:8000', 'api/list_tempat');
    var response = await http.get(url);
    var list = json.decode(response.body)['messages'].map((data) => Destination.fromJson(data)).toList();
    return Future.delayed(loadTime).then((_) {
      return list;
    });
  }

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 3,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];

    for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;

    return batch;
  }
}

void main() => runApp(Dashboard(title: ''));


class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ExampleItemPager pager = ExampleItemPager();
  TextEditingController textController = TextEditingController();
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
        title: const Text('Home')
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, left: 10, right:10),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 350,
              child: PaginatedSearchBar<ExampleItem>(
                maxHeight: 300,
                hintText: 'Search',
                emptyBuilder: (context) {
                  return const Text("I'm an empty state!");
                },
                paginationDelegate: EndlessPaginationDelegate(
                  pageSize: 20,
                  maxPages: 3,
                ),
                onSearch: ({
                  required pageIndex,
                  required pageSize,
                  required searchQuery,
                }) async {
                  return Future.delayed(const Duration(milliseconds: 1300), () {
                    if (searchQuery == "empty") {
                      return [];
                    }

                    if (pageIndex == 0) {
                      pager = ExampleItemPager();
                    }

                    return pager.nextBatch();
                  });
                },
                itemBuilder: (
                  context, {
                  required item,
                  required index,
                }) {
                  return Text(item.title);
                },
              ),
            ),
          ),
          Container( 
            padding: const EdgeInsets.only(top: 30, left: 10, right:10),
            width: 360,
            alignment: Alignment.topCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.shade200,
            ),
            child: Row(
                children: [ 
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 20, right:10),
                    child:  Image.asset('assets/dashboard_logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child:  Image.asset('assets/dashboard_text.png'),
                  )
                ],
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, left: 10, right:10),
            width: 360,
            child: const Text(
              "Wisata Populer",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            width: 360,
            child: FutureBuilder(
              future: listData(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
              return  ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ),
                                   Padding(padding: const EdgeInsets.only(top: 10, right: 10), 
                                      child: GestureDetector(
                                        onTap: () {
                                          debugPrint("kontol memek");
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
                                        snapshot.data[index].lokasi,
                                        style:  const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 10, bottom:10, right: 10), 
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Detail(id: snapshot.data[index].id,)), (route) => false);
                                        },
                                        child: const Text(
                                          "Detail Destinasi",
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
                        ],)
                    );
                  }
                }
                );
              }
            )
          )
        ],
      ),)
    )
    );
  }
}