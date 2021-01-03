import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/common_widget/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'OK');

  static String _message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD': 'Error weak password',
    'ERROR_EMAIL_ALREADY_IN_USE': 'The email alreadey in use!',
    'ERROR_USER_NOT_FOUND': 'The user not found',
    'ERROR_INVALID_EMAIL': 'The email is invalid',
    'ERROR_WRONG_PASSWORD': 'The Password is invalid',
    'ERROR_USER_DISABLED': 'The user disabled'
  };
}
