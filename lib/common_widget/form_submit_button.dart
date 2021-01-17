import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/utils/constants.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
          ),
          color: kPrimaryColor,
          onPressed: onPressed,
        );
}
