import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/register.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';

import '../../utils/shared/loading.dart';

class UserTable extends StatefulWidget {
  const UserTable({Key? key}) : super(key: key);

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  bool loading = false;
  int no = 1;
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserInformation?>?>(context);
    if (users == null) {
      return const Loading();
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ScrollPhysics().parent,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No.')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Update Date')),
                DataColumn(label: Text('')),
              ],
              rows: List<DataRow>.generate(
                users.length,
                    (index) => DataRow(cells: [
                  DataCell(Text(index.toString())),
                  DataCell(Text(users[index]!.fullName.toString())),
                  DataCell(Text(users[index]!.role.toString())),
                  DataCell(Text(users[index]!.updatedDate.toString())),
                  DataCell(Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          debugPrint(users[index]!.toString());
                          _showDialog(users[index]!);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        onPressed: ()async{
                          var uid= users[index]!.uid;
                          DatabaseService(uid: uid).deleteUser(uid.toString());
                          debugPrint("user UID => ${uid!}");
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[200],
                        ),
                      )
                    ],
                  ))
                ]),
              ),
            ),
          );
        },
      );
    }
  }
  void _showDialog(UserInformation information) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              RegisterForm(info: information,reg: false,),
            ],
          ),
        );
      },
    );
  }

}