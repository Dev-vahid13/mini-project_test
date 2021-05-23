import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File image = null;
  final picker = ImagePicker();




  Future<void> _chooseOption(BuildContext context){
    return showDialog(
      context:context,builder:(BuildContext context){
      return AlertDialog(
        title: Text("Select An Option"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  _chooseFromGallery(context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width*.5,
                    padding: EdgeInsets.all(10),
                    child: Card(child: Center(
                        child: FittedBox(
                          child: Text("Choose from Gallery",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54
                            ),
                          ),
                        )))),
              ),
              GestureDetector(
                onTap: (){
                  _chooseFromCamera(context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width*.5,
                    padding: EdgeInsets.all(10),
                    child: Card(child: Center(
                        child: FittedBox(
                          child: Text("Take a new photo",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54
                          ),
                          ),
                        )))),
              ),
            ],
          ),
        ),
      );
    }
    );

  }

  @override

  _chooseFromGallery(BuildContext context) async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      image = File(pickedFile.path);
    });
    String base64Image = base64Encode(image.readAsBytesSync());

    var url = Uri.parse('http://10.0.2.2:5000/');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'image': base64Image,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');

    Navigator.of(context).pop();

  }


  _chooseFromCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    this.setState(() {
      image = File(pickedFile.path);
    });
    String base64Image = base64Encode(image.readAsBytesSync());

    var url = Uri.parse('http://10.0.2.2:5000/');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'image': base64Image,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');


    Navigator.of(context).pop();


  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*.5,
                child: image==null?
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image,
                      size: 40,
                      color: Colors.black54,),
                      Text("No image selected",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                ):Image.file(image),
                padding: EdgeInsets.all(20),
              ),
              ElevatedButton(onPressed: (){
                _chooseOption(context);
              },
              child: Text("upload Image"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
