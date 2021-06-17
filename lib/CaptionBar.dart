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
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width*.85,
      height: 70,
      alignment: Alignment.center,
      child: Card(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*.65,
              child:Center(child: Text(widget.caption))
            ),
            Container(
              color: Colors.black26,
              width: 2,
              height:85,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*.15-2,
              child: Center(child: Icon(Icons.multitrack_audio))
            )
          ],
        ),
      ),
    );
  }
}
