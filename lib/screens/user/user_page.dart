import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/user/user_table.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserInformation?>?>.value(
        initialData: null,
        catchError: (UserData, User) => null,
        value: DatabaseService()
            .getUsers, //DatabaseService(uid: DatabaseService().uid).getUsers, //(uid: DatabaseService().uid).getUsers,
        child: loading
            ? const Loading()
            : //const UserTable()
            LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(defaultPadding),
                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                    decoration: const BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Users Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: UserTable()),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
