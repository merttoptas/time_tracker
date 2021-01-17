import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:time_tracker/app/home/sign_in/sign_in_manager.dart';
import 'package:time_tracker/common_widget/or_divider.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/common_widget/social_icon.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:flutter/services.dart';
import '../../../common_widget/background.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    // ignore: missing_required_param
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
          // ignore: missing_required_param
          builder: (_, isLoading, __) => Provider<SignInManager>(
                builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
                child: Consumer<SignInManager>(
                  builder: (context, manager, _) => SignInPage(
                    manager: manager,
                    isLoading: isLoading.value,
                  ),
                ),
              )),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Background(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "images/icons/signup.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            EmailSignInFormChangeNotifier.create(context),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  iconSrc: "images/icons/facebook.svg",
                  press: isLoading ? null : () => _signInWithFacebook(context),
                ),
                SocialIcon(
                  iconSrc: "images/icons/twitter.svg",
                  press: isLoading ? null : () => _signInAnonymously(context),
                ),
                SocialIcon(
                  iconSrc: "images/icons/google-plus.svg",
                  press: isLoading ? null : () => _signInWithGoogle(context),
                ),
              ],
            )
          ],
        )),
    );
  }
}
