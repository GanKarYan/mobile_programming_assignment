import 'dart:convert';

import 'package:coinmemoria/coin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'coindetail.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List ownerList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadOwner();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post', style: TextStyle(fontSize: 18)),
      ),
      body: Column(
        children: [
          ownerList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1, //显示东西用的， eg product. 2的话显示两个
                  childAspectRatio: (screenWidth / screenHeight) / 0.5,
                  children: List.generate(ownerList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Card(
                        child: InkWell(
                            onTap: () => _loadCoinDetail(index),
                            child: Column(
                              children: [
                                Container(
                                    width: screenWidth / 1.0,
                                    height: screenHeight / 2.5,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://sopmathpowy2.com/CoinMemoria/images/coinimages/${ownerList[index]['ownerimages']}.jpg",
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 3,
                                      ),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(ownerList[index]['ownername'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                //Text(ownerList[index]['ownerphone']),
                                //Text(ownerList[index]['ownerlocation'])
                              ],
                            )),
                      ),
                    );
                  }),
                ))
        ],
      ),
    );
  }

  void _loadOwner() {
    http.post("http://sopmathpowy2.com/CoinMemoria/php/load_owner.php", body: {
      "location": "Penang",
    }).then((res) {
      print(res.body);
      if (res.body == "no data") {
        ownerList = null;
        setState(() {
          titlecenter = "No post found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          ownerList = jsondata["owner"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCoinDetail(int index) {
    print(ownerList[index]['ownername']);
    Coin coin = new Coin(
        ownerid: ownerList[index]['ownerid'],
        ownername: ownerList[index]['ownername'],
        ownerphone: ownerList[index]['ownerphone'],
        ownerlocation: ownerList[index]['ownerlocation'],
        ownerimages: ownerList[index]['ownerimages']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CoinDetail(coins: coin)));
  }
}
