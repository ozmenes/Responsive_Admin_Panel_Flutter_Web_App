import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/validator_service.dart';

class ProfileUserData extends StatefulWidget {
  const ProfileUserData({Key? key}) : super(key: key);

  @override
  _ProfileUserDataState createState() => _ProfileUserDataState();
}

class _ProfileUserDataState extends State<ProfileUserData> {
  final _formKey = GlobalKey<FormState>();
  final userRole = ['Admin', "Manager", "User"];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  String? role;
  String? fullName;
  String? address;
  String? phone;
  String? email;
  String? imageUrl;
  String error = '';
  bool loading = false;

  late String uid;

  @override
  void initState() {
    uid = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int item = !Responsive.isMobile(context) ? 2 : 1;
    return StreamBuilder<UserInformation?>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: Loading());
        // }
        if (snapshot.hasData) {
          UserInformation? userData = snapshot.data;
          //role = userData?.role;
          // fullName = "${userData?.fullName}";
          // address = "${userData?.address}";
          // phone = userData?.phone;
          imageUrl = "${userData?.imageUrl}";
          email = userData?.email;
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "General Information",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: defaultPadding),
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 9/2,
                      //physics: const ScrollPhysics(),
                      //scrollDirection: Axis.vertical,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 0,

                      crossAxisCount: item,
                      children: [
                        SizedBox(
                          width: !Responsive.isMobile(context)
                              ? 350
                              : double.infinity,
                          child: TextFormField(
                            //controller: _fullName,
                            initialValue: userData?.fullName,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter your Full name' : null,
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            //controller: _phone,
                            initialValue: userData?.phone,
                            decoration: InputDecoration(
                              labelText: "Phone number",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter your Phone number' : null,
                            onChanged: (val) {
                              setState(() {
                                phone = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: Responsive.isMobile(context)
                              ? 350
                              : double.infinity,
                          child: TextFormField(
                            readOnly: true,
                            //controller: _email,
                            initialValue: email,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                            validator: (val) =>
                                val!.isValidEmail() ? null : "Check your email",
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            //controller: _address,
                            initialValue: userData?.address,
                            decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter your address' : null,
                            onChanged: (val) {
                              setState(() {
                                address = val;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.only(left: defaultPadding),
                          child: DropdownButton<String>(
                            isDense: true,
                            hint: Text(
                              "${userData?.role}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            isExpanded: true,
                            iconSize: 36,
                            value: role,
                            underline: const SizedBox(
                              height: 0,
                            ),
                            items: userRole.map(buildMenuItem).toList(),
                            onChanged: (val) {
                              setState(() {
                                role = val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final DateTime _now = DateTime.now();
                        try {
                          //uploadImageToFireStorage();
                          //await _authService.updateEmailAndPassword(email!,password);
                          await _databaseService.updateUserData(
                            uid,
                            fullName ?? "${userData?.fullName}",
                            imageUrl,
                            phone ?? "${userData?.phone}",
                            address?? "${userData?.address}",
                            role ?? "${userData?.role}",
                            DateFormat.yMMMMd().add_Hm().format(_now),
                          );
                        } catch (e) {
                          setState(() {
                            error = e.toString();
                            debugPrint(error);
                            loading = false;
                          });
                          debugPrint(e.toString());
                        }
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Updated!.")));
                      } else {
                        return debugPrint('Validation error');
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: defaultPadding),
                      width: 350,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                  const SizedBox(height: defaultPadding*2),
                ],
              ),
            ),
          );
        }
        //UserInformation? userData = snapshot.data;
        return const Center(child: Loading());
      },
    );
  }

  editUser() async {

  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
      ),
    );
  }
}
