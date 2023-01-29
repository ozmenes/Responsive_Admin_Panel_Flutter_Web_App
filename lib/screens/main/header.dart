import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/change_password.dart';
import 'package:responsive_admin_panel_web_app/screens/main/main_screen.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/components/profile_card.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';

import '../../utils/components/search_field.dart';
import '../authenticate/authenticate.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    uid = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        //if(Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
        if (!Responsive.isMobile(context))
          Spacer(
            flex: Responsive.isDesktop(context) ? 2 : 1,
          ),
        const Expanded(child: SearchField()),
        const CustomMenu()
      ],
    );
  }
}

class CustomMenu extends StatefulWidget {
  const CustomMenu({Key? key}) : super(key: key);

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  late String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    uid = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final users = Provider.of<List<UserInformation?>?>(context);
    return StreamBuilder<UserInformation>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserInformation? userData = snapshot.data;
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              style: const TextStyle(color: Colors.white70),
              hint: ProfileCard(userData: userData),
              icon: const SizedBox(),
              //underline: Container(color: Colors.transparent),
              items: [
                if (Responsive.isMobile(context))
                  DropdownMenuItem(
                    value: 0,
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding/2,),
                        Row(
                          children: [

                            Text(
                              '${userData?.fullName}',
                              style: TextStyle(
                                fontSize: 14,
                                  color: Colors.orangeAccent[700],
                                  fontWeight: FontWeight.w600),
                            ),
                            //const Divider(color: Colors.white70,height: 12,thickness: 5,)
                          ],
                        ),
                        const Divider(color: Colors.white70,thickness: 1,)
                      ],
                    ),
                  ),
                if (Responsive.isMobile(context))
                  DropdownMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.dashboard,
                            color: Colors.white70,
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                            width: defaultPadding / 2,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      )),
                DropdownMenuItem(
                  value: 2,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.white70,
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                        width: defaultPadding / 2,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_attributes_outlined,
                        color: Colors.white70,
                      ),
                      SizedBox(
                          height: defaultPadding / 2,
                          width: defaultPadding / 2),
                      Text(
                        'Edit User',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        color: Colors.white70,
                      ),
                      SizedBox(
                          height: defaultPadding / 2,
                          width: defaultPadding / 2),
                      Text(
                        'Settings',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 5,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.white70,
                      ),
                      SizedBox(
                          height: defaultPadding / 2,
                          width: defaultPadding / 2),
                      Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  onSelected(context, val);
                });
              },
            ),
          );
        }
        return const Center(
          child: Loading(),
        );
      },
    );
  }

  void _showChangePasswordDialog(Widget widget) {
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

  void onSelected(BuildContext context, dynamic item) async{
    switch (item) {
      case 0:
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainScreen(
                      selectedPage: 0,
                    )));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainScreen(
                      selectedPage: 1,
                    )));
        break;
      case 3:
        _showChangePasswordDialog(const ChangePasswordPage());
        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainScreen(
                      selectedPage: 0,
                    )));
        break;
      case 5:
        await _authService.signOut();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => const Authenticate()));
        break;
    }
  }
}
