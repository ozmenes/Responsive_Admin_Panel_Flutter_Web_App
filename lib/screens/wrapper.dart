import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/user.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/authenticate.dart';
import 'package:responsive_admin_panel_web_app/screens/main/main_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    debugPrint('wrapper: ' + user.toString());
    //return either Homepage or Authenticate widget

    if (user == null) {

      return const Authenticate();
    } else {
      return const MainScreen();//ProfilePage(context: context,);
    }
  }
}
