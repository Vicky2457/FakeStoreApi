import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_7/constant/constant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeScreen> {
  Future<List> _getproduct() async {
    var url = Uri.parse(kProductUrl);
    final responce = await http.get(url);
    final data = jsonDecode(responce.body);
    return data;
  }

  @override
  void initState() {
    _getproduct();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 167, 148, 172),
        shadowColor: const Color.fromARGB(255, 7, 7, 6),
        title: Center(
            child: Text(
          'Fake Store Api',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: FutureBuilder<List>(
        future: _getproduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text("no data"),
            );
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text("data is emptty"),
            );
          }
          return GridView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(9.0),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        product['image'],
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${product['title']}",
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("  \$${product['price']}"),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh),
      ),
    );
  }
}

