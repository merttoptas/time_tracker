import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({ 
    this.child, 
    this.borderRadius: 2.0, 
    this.onPressed, 
    this.height :50.0,
    this.color});
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height:50.0,
        child: RaisedButton(
        onPressed: onPressed,
              child: child,
              color: color,
              disabledColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius))
            ),
            ),
    );
  }
}