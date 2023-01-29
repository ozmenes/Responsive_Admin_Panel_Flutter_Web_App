import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/validator_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String email = '';
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 375,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Reset your password",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 26,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Enter your email and we'll send you instruction on "
              "how to reset your password.",
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: emailController,
                //initialValue: confirmEmail,
                decoration: InputDecoration(
                  labelText: "Reset Password Email Address",
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                validator: (val) => val!.isValidEmail()
                    ? null
                    : "Please enter your current email address.",
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            InkWell(
              onTap: () async {
                FirebaseAuth _auth = FirebaseAuth.instance;
                if (_formKey.currentState!.validate()) {
                  setState(() => loading = true);
                  if (email != '') {
                    resetPassword();
                  } else {}
                } else {
                  return debugPrint('Validation error.');
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: 250,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8A2387),
                          Color(0xFFE94057),
                          Color(0xFFF27121),
                        ])),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Send",
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              error,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      //Utils.showSnackBar('Password rest email sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      //Utils.showSnackBar(e.message);
      debugPrint(e.toString());
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showResetPasswordDialog(Widget widget) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              widget
              // ResetEmailAndPassword(resetEmail: false,)
            ],
          ),
        );
      },
    );
  }
}
