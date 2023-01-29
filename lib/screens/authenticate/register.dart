import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/authenticate.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/validator_service.dart';


class Register extends StatefulWidget {
  const Register({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
        body: Container(
            height: _size.height,
            width: _size.width,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  RegisterForm(
                    toggleView: widget.toggleView,
                    reg: true,
                  )
                ],
              ),
            )),
      );
    }
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key, this.info,required this.reg, this.toggleView, this.profilePage})
      : super(key: key);
  final UserInformation? info;
  final bool? profilePage;
  final Function? toggleView;
  final bool? reg;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final userRole = ['Admin', "Manager", "User"];
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  String? address = '';
  String? phone = '';
  String? fullName = '';
  String? role;
  String? imageUrl = 'avatar';
  String imgPath = '';
  bool loading = false;
  File? imageFile;
  String? fileName;
  final DateTime _now = DateTime.now();

  //Image
  XFile? picketedImage;

  Future uploadImage(String inputSource) async {
    final picker = ImagePicker();
    picketedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      loading = true;
    });
  }

  Future<List<Map>?> loadImage() async {
    if (widget.info != null) {
      late List<Map> files;
      final ListResult result;
      final List<Reference> allFiles;
      files = [];
      result = await firebaseStorage.ref().listAll();
      allFiles = result.items;
      await Future.forEach(allFiles, (Reference file) async {
        final String fileUrl = await file.getDownloadURL();
        imgPath = fileUrl;
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
        });
      });
      debugPrint('files$files');
      return files;
    } else {
      return null;
    }
  }

  Future<void> delete(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  @override
  void initState() {
    role = widget.info?.role;
    fullName = widget.info?.fullName;
    //widget.info != null ? imageUrl : imageUrl;
    address = widget.info?.address;
    phone = widget.info?.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //widget.info.uid =
    //double _height = 250;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //height: 720,
              width: 325,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: //widget.info != null,
                              _auth.currentUser?.uid == null,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white70,
                            ),
                            onPressed: () async {
                              widget.toggleView!();
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.info != null ||
                              _auth.currentUser?.uid != null,
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
                  ),
                  Visibility(
                    visible: widget.profilePage == true,
                    child: Container(
                      color: Colors.transparent,
                      height: 250,
                      child: widget.info?.imageUrl == "avatar"
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                  'assets/images/launcher.png')) //Text('No image'),

                          : FutureBuilder(
                              future: loadImage(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                //return Text(snapshot.data.toString());
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length ?? 0,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final Map image = snapshot.data[index];
                                      //setState(() {
                                      imageUrl = image['url'];
                                      debugPrint(
                                          'url = $imageUrl');
                                      //});
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          //Image.network(image['url'],width: 325,height: 325,),
                                          SizedBox(
                                            height: 250,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(
                                                              defaultPadding)),
                                              clipBehavior: Clip.antiAlias,
                                              child:
                                                  Image.network(image['url']),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: defaultPadding,
                                          ),
                                          Positioned(
                                            bottom: 1,
                                            right: 20,
                                            child: IconButton(
                                                onPressed: () async {
                                                  await delete(image['path']);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Image Successfully Deleted")));
                                                },

                                                // label: Text('',style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors
                                                //     .white70),),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white70,
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: Text('No image'),
                                  );
                                }
                              },
                            ),
                    ),
                  ),
                  SizedBox(
                    height: widget.info != null ? defaultPadding / 2 : 0,
                  ),
                  Visibility(
                    visible: widget.profilePage == true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              uploadImage("camera");
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  secondaryColor),
                            ),
                            icon: const Icon(Icons.camera),
                            label: Text(
                              'Camera',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              uploadImage("gallery");
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  secondaryColor),
                            ),
                            icon: const Icon(Icons.library_add),
                            label: Text(
                              'Gallery',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      //controller: _fullName,
                      initialValue: fullName,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      //controller: _address,
                      initialValue: address,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      //controller: _phone,
                      initialValue: phone,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 250,
                    child: DropdownButton<String>(
                      hint: Text(
                        "Role",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                      style: const TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      isExpanded: true,
                      iconSize: 36,
                      value: role,
                      items: userRole.map(buildMenuItem).toList(),
                      onChanged: (val) {
                        setState(() {
                          role = val!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: widget.info == null,
                    child: SizedBox(
                      width: 250,
                      child: TextFormField(
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
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: widget.info == null,
                    child: SizedBox(
                      width: 250,
                      child: TextFormField(
                        //controller: _password,
                        decoration: InputDecoration(
                          labelText: "Password",
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
                            password = val;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);

                        // try {
                        //   AuthCredential credential =
                        //       EmailAuthProvider.credential(
                        //           email: email, password: password);
                        //   await _auth.currentUser!
                        //       .reauthenticateWithCredential(credential);
                        //
                        //   //await _auth.currentUser!.updateEmail(email);
                        //   // await _auth.currentUser!.updatePassword(_password);
                        //
                        //   //currentUser.updateEmail(this.email.value);
                        //   debugPrint(
                        //       'Email and Password successfully updated.!');
                        // } catch (err) {
                        //   debugPrint(
                        //       "Reauthentication error! : " + err.toString());
                        // }

                        if (widget.info == null) {
                          createUserUID();
                          //await uploadImageToFireStorage();
                          //addUser();
                        } else {
                          editUser();
                        }
                        if(widget.reg == true){
                        await _authService.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const Authenticate()));
                        }
                      } else {
                        return debugPrint('Validation error');
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
                    height: 10.0,
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
          ],
        ),
      ),
    );
  }

  ///kontrol et ve ekle
  ///https://www.youtube.com/watch?v=JVSHH6vYxGM
  // resetPassword() async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Password Reset Email has been sent')));
  //     Navigator.pop(context);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('No user found for that email')));
  //     }
  //     setState(() {
  //       error = e.toString();
  //       debugPrint(error);
  //       loading = false;
  //     });
  //     debugPrint(e.toString());
  //   }
  // }

  editUser() async {
    try {
      uploadImageToFireStorage();
      //await _authService.updateEmailAndPassword(email!,password);
      await _databaseService.updateUserData(
        widget.info!.uid.toString(),
        fullName!,
        imageUrl ?? imgPath,
        phone!,
        address!,
        role!,
        DateFormat.yMd().add_Hm().format(_now),
      );

      // if (res == null) {
      //   setState(() {
      //     error = 'Please supply a valid email';
      //     debugPrint(error);
      //     loading = false;
      //   });
      // }else{
      //   Navigator.pop(context);
      // }
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = e.toString();
        debugPrint(error);
        loading = false;
      });
      debugPrint(e.toString());
    }
  }

  createUserUID() async {
    try {
      dynamic result =
          await _authService.registerWithEmailAndPassword(email, password);
      _auth.currentUser?.displayName == fullName;
      debugPrint(email);
      debugPrint(password);
      dynamic res = await _databaseService.addUsersInfo(
          _auth.currentUser!.uid.toString(),
          fullName.toString(),
          imageUrl,
          address.toString(),
          phone.toString(),
          email,
          role.toString(),
          DateFormat.yMd().add_Hm().format(_now),
          DateFormat.yMd().add_Hm().format(_now),);
      debugPrint(fullName);
      debugPrint(_auth.currentUser?.metadata.creationTime.toString());
      debugPrint(DateFormat.yMd().add_Hm().format(_now).toString());
      debugPrint(_auth.currentUser?.email);
      debugPrint(phone);
      debugPrint(address);
      debugPrint(role);

      if (result == null && res == null) {
        //&& res == null) {
        setState(() {
          error = 'Please supply a valid email';
          debugPrint(error);
          loading = false;
        });
      }
    } catch (e) {
      error = e.toString();
      debugPrint(error);
      loading = false;
      debugPrint(e.toString());
    }
  }

  addUser() async {
    try {
      /// email ve pass firebase kayit yaptikdan sonraki olusan uid yeni currentUser.uid oluyor ve boylese addUserInfo icerisene basliyor
      /// Login yapan user uid'si yeni register uid oluyor.
      // dynamic result =
      //     await _authService.registerWithEmailAndPassword(email, password);
      // debugPrint(email);
      // debugPrint(password);
      dynamic result = await _databaseService.addUsersInfo(
        _auth.currentUser!.uid,
        fullName!,
        imageUrl ?? imgPath,
        address!,
        phone!,
        "${_auth.currentUser?.email}",
        role!,
        DateFormat.yMd().add_Hm().format(_now),
        DateFormat.yMd().add_Hm().format(_now),
      );
      debugPrint(fullName);
      debugPrint(_auth.currentUser?.metadata.creationTime.toString());
      debugPrint(DateFormat.yMd().add_Hm().format(_now).toString());
      debugPrint(_auth.currentUser?.email);
      debugPrint(phone);
      debugPrint(address);
      debugPrint(role);
      if (result == null) {
        setState(() {
          error = 'Please supply a valid email';
          debugPrint(error);
          loading = false;
        });
      } else {
        //Navigator.pop(context);
      }
    } catch (e) {
      error = e.toString();
      debugPrint(error);
      loading = false;
      debugPrint(e.toString());
    }
  }

  uploadImageToFireStorage() async {
    if (picketedImage == null) {
      debugPrint("picketedImage null");
      return null;
    } else {
      fileName = picketedImage!.name;
      imageFile = File(picketedImage!.path);
      imageUrl = widget.info?.imageUrl;
      debugPrint("fileName : $fileName");
      debugPrint("imageFile : $imageFile");
      debugPrint("imageUrl : $imageUrl");
    }
    try {
      await firebaseStorage.ref(fileName).putFile(imageFile!);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully Uploaded")));
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image could not Uploaded")));
    } catch (error) {
      debugPrint(error.toString());
    }
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
