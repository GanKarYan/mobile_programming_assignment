import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'addpostscreen.dart';
import 'coin.dart';
import 'package:http/http.dart' as http;

class CoinDetail extends StatefulWidget {
  final Coin coins;

  const CoinDetail({Key key, this.coins}) : super(key: key);

  @override
  _CoinDetailState createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  List coinList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading...";
  @override
  void initState() {
    loadCoin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coins.ownername),
      ),
      body: Center(
        child: Column(children: [
          Container(
              width: screenWidth / 0.3,
              height: screenHeight / 4,
              child: CachedNetworkImage(
                imageUrl:
                    "http://sopmathpowy2.com/CoinMemoria/images/coinimages/${widget.coins.ownerimages}.jpg",
                fit: BoxFit.fill,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(
                  Icons.broken_image,
                  size: screenWidth / 3,
                ),
              )),
          coinList == null
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
                  children: List.generate(coinList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Card(
                        child: InkWell(
                            //onTap: () => _loadCoinDetail(index),
                            child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(coinList[index]['postname'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20,
                            ),
                            Text(coinList[index]['postdetail']),
                            //Text(coinList[index]['postcomment']),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )),
                      ),
                    );
                  }),
                )),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(children: [
                Tooltip(
                    message: 'add new post',
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          _addPost();
                        })),
              ])
            ],
          )),
        ]),
      ),
    );
  }

  void loadCoin() {
    http.post("http://sopmathpowy2.com/CoinMemoria/php/load_coin.php", body: {
      "ownerid": widget.coins.ownerid,
    }).then((res) {
      print(res.body);
      if (res.body == "no data") {
        coinList = null;
        setState(() {
          titlecenter = "No post a found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          coinList = jsondata["coins"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _addPost() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AddPostScreen()));
  }
}
