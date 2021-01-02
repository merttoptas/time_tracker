import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 6.0,
          onPressed: onPressed,
        );
}
