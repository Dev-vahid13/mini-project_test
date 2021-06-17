import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:miniproject/CaptionBar.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File image = null;
  final picker = ImagePicker();
  String caption="No image selected";






  @override

  _chooseFromGallery(BuildContext context) async {




    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      image = File(pickedFile.path);
    });
    String base64Image = await base64Encode(image.readAsBytesSync());

    print(base64Image);
    print("1");
    setState(() {
      caption="Generating Caption...";
    });



    var url = Uri.parse('https://imagecaption2021.herokuapp.com/');

    Map <String, dynamic> requestpayload = await {
      'image': base64Image
    };
    print(requestpayload);

    print("2");

    final response = await http.post(
      url,
      body: jsonEncode(requestpayload),

      headers: {'Content-Type': "application/json"},
    );

    print(response);


    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');

    if(response.statusCode == 503){
      setState(() {
        caption = "Timed out ";
      });
    }




    if (response.statusCode == 200){
      final parsedJson = jsonDecode(response.body);
      print('Return Data : ${response.body}');
      setState(() {
        final description = parsedJson["description"];
        caption=description;
      });
    }



  }


  _chooseFromCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    this.setState(() {
      image = File(pickedFile.path);
    });
    String base64Image = base64Encode(image.readAsBytesSync());

    print(base64Image);
    print("1");
    setState(() {
      caption="Generating Caption...";
    });

    Map <String, dynamic> requestpayload = {
      'image': base64Image
    };

    var url = Uri.parse('https://imagecaption2021.herokuapp.com/');
    final response = await http.post(
      url,
      body: jsonEncode(requestpayload),

      headers: {'Content-Type': "application/json"},
    );

    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');



  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              CaptionBar(caption: caption,),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width*.8,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(13))
                ),
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
              Container(
                width: MediaQuery.of(context).size.width*.7,
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap:() {
                        _chooseFromGallery(context);
                      },
                      //onTap: ()=>_chooseFromGallery(context),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Upload from Gallery"),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap:() {
                        _chooseFromCamera(context);
                      },
                      //onTap: ()=>_chooseFromGallery(context),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Take a new Photo"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //ElevatedButton(onPressed: (){
                //_chooseOption(context);
              //},
              //child: Text("upload Image"),
              //)
            ],
          ),
        ),
      ),
    );
  }
}
