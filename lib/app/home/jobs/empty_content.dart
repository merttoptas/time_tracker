import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;

  const EmptyContent(
      {Key key,
      this.title = 'Nothing here',
      this.message = 'Add a new item to get started'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/empty_content.svg",
            height: size.height * 0.25,
          ),
          SizedBox(height: 10,),
          Text(title, style: TextStyle(fontSize: 32.0, color: Colors.black54),),
          Text(message, style: TextStyle(fontSize: 16.0, color: Colors.black54),)
        ],
      ),
    );
  }
}
