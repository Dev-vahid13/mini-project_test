import 'package:flutter/material.dart';

class CaptionBar extends StatefulWidget {
  String caption;
  CaptionBar({this.caption});

  @override
  _CaptionBarState createState() => _CaptionBarState();
}

class _CaptionBarState extends State<CaptionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.7,
      height: 50,
      child: Card(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.caption==null?"No image selected":widget.caption
              ),
            ),
            SizedBox(
              child: Container(
                width: 1,
                color: Colors.black26,
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: (){

                },
                child: Icon(
                  Icons.multitrack_audio,
                  color: Colors.lightBlue,
                ),
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}
