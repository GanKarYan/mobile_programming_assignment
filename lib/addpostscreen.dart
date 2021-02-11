import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';

//import 'coin.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

double screenHeight, screenWidth;
String camera = 'assets/images/camera.png';
File _image;
String _postname = "";
String _postdetail = "";

class AddPostScreen extends StatefulWidget {
  get coins => null;

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postnamecontroller = TextEditingController();
  final TextEditingController _postdetailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SingleChildScrollView(
                child: Column(children: [
              GestureDetector(
                  onTap: () => {_onPicSelect()},
                  child: Container(
                    height: screenHeight / 3.0,
                    width: screenWidth / 1.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(camera)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  )),
              SizedBox(height: 5),
              // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  controller: _postnamecontroller,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Post Title',
                      icon: Icon(Icons.wysiwyg_rounded))),
              TextField(
                  controller: _postdetailcontroller,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Post Detail',
                      icon: Icon(Icons.wysiwyg_rounded))),
              SizedBox(height: 10),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Text('Add New POst'),
                color: Colors.orange,
                textColor: Colors.black,
                elevation: 15,
                onPressed: newPostPage,
              ),
              SizedBox(height: 10),
              // ])
            ]))),
      ),
    );
  }
