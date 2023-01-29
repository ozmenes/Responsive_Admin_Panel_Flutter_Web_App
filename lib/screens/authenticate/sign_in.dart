import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/reset_email_pass.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool hidePassword = true;
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
          body: SizedBox(
        height: size.height,
        width: size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                Image.asset('assets/images/launcher.png'),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 560,
                  width: 325,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Hello",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Please Login to Your Account",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a valid email.' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                              suffixIcon: const Icon(
                                Icons.email_outlined,
                                size: 17,
                                color: Colors.white70,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          //controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: hidePassword,
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6+ chars long.'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Colors.orangeAccent[700]?.withOpacity(0.5),

                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 40, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () =>_showResetPasswordDialog(const ForgetPassword()),
                              child: Text(
                                "Forget Password?",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(color: Colors.orangeAccent[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                widget.toggleView!();
                              },
                              child: Text(
                                "Register",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _authService
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    "could not sign in with those credentials.";
                                debugPrint(error);
                                loading = false;
                              });
                            }
                            debugPrint(email);
                            debugPrint(password);
                            debugPrint('valid');
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
                              "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        error,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.orangeAccent[700]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Or Login using Social Media",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                dynamic result =
                                    await _authService.signInAnon();
                                if (result == null) {
                                  debugPrint('error signing in');
                                } else {
                                  debugPrint('signed in');
                                  debugPrint('uid: ${result.uid}');
                                }
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                              },
                              icon: Icon(
                                Icons.login,
                                color: Colors.orangeAccent[700],
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.facebook,
                                color: Colors.orangeAccent[700],
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.gite,
                                color: Colors.orangeAccent[700],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                //const Spacer(),
              ],
            ),
          ),
        ),
      ));
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
