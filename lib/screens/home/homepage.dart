import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/user/user_table.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService= AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserInformation?>?>.value(
      initialData: null,
      catchError: (UserData,User)=>null,
      value: DatabaseService(uid: DatabaseService().uid).getUsers,//(uid: DatabaseService().uid).getUsers,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Panel"),
          backgroundColor: Colors.redAccent,
          elevation: 0.0,
          actions: <Widget>[
            MaterialButton(
              onPressed: ()async{
                await _authService.signOut();
              },
              child: const Text('Logout'),

            )
          ],
        ),
        body: loading ? const Loading() :const UserTable() ,
      ),
    );
  }
}