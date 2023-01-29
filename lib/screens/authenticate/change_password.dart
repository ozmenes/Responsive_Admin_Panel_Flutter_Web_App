import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/validator_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: const [

          ChangePassword(),
        ],
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  String error = '';
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
  String confirmEmail = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Change User Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 10,
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
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: emailController,
              //initialValue: confirmEmail,
              decoration: InputDecoration(
                labelText: "Email address",
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
                  confirmEmail = val;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: 250,
            child: TextFormField(
              //controller: _password,
              decoration: InputDecoration(
                labelText: "Current password",
                labelStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
              validator: (val) => val!.length < 6
                  ? 'Please enter your current password.'
                  : null,
              onChanged: (val) {
                setState(() {
                  currentPassword = val;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: "New password",
                labelStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
              validator: (val) =>
                  val!.length < 6 ? 'Enter a password 6+ chars long.' : null,
              onChanged: (val) {
                setState(() {
                  newPassword = val;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: 250,
            child: TextFormField(
              //controller: _password,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                labelStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
              validator: (val) => val!.length < 6
                  ? 'Enter a password 6+ chars long.'
                  : null,
              onChanged: (val) {
                setState(() {
                  confirmNewPassword = val;
                });
              },
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          InkWell(
            onTap: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              if (_formKey.currentState!.validate()) {
                setState(() => loading = true);
                var email = auth.currentUser?.email.toString();
                if (confirmEmail == email){
                  auth.authStateChanges().listen((User? user) async {
                    if (user == null) {
                      debugPrint('User is currently signed out!');
                    } else {
                      debugPrint('User is already signed in!');
                      if(currentPassword == newPassword){
                        setState(() {
                          error ='New password is same as your current password';
                        });
                        debugPrint('New password is same as your current password');
                      }else{
                        if (newPassword == confirmNewPassword) {
                          dynamic change = await _authService.changePassword(
                              confirmEmail, currentPassword, newPassword);
                          if (change == null) {
                            setState(() {
                              setState(() {
                                error = 'Password could not changed!';
                              });
                              debugPrint(error);
                              loading = false;
                            });
                          }else{
                            Navigator.pop(context);
                            _authService.signOut();
                          }
                          //
                        }else{
                          error = 'Please confirm your new password';
                          debugPrint('try to type new password in confirm password');
                        }
                      }
                      //Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  });
                  debugPrint(confirmEmail);
                  debugPrint(currentPassword);
                  debugPrint('tes');
                } else {
                  setState(() {
                    error ='email address is not correct';
                  });
                  debugPrint('email address is not correct');
                }
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
                  "Save",
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
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

