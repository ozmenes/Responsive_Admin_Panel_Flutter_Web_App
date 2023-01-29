
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/services/database.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final double _iconSize = 40.0;
  late String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  XFile? picketedImage;
  String imageURL = 'avatar';
  String? resimAdresi;
  String? fileName;
  File? imageFile;
  Future uploadImage(String inputSource) async {
    final picker = ImagePicker();
    picketedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      loading = true;
    });
  }

  Future<void> delete(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  Future<List<Map>?> loadImage() async {
    late List<Map> files;
    final ListResult result;
    final List<Reference> allFiles;
    files = [];
    result = await firebaseStorage.ref().listAll();
    allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      resimAdresi = fileUrl;
      debugPrint('resimAdresi = ${resimAdresi!}');
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });
    debugPrint('files$files');
    return files;
  }

  @override
  void initState() {
    uid = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserInformation?>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.hasData) {
          UserInformation? userData = snapshot.data;
          imageURL = userData!.imageUrl!;
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                SizedBox(
                  //color: Colors.white70,
                  width: double.infinity,
                  //height: 500,
                  child: Column(
                    children: [
                      ProfileViewHeader(
                        childHeight: _iconSize,
                        firstIcon: null,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 5.0,
                              color: Colors.white,
                            ),
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 5.0,
                                  color: secondaryColor,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: imageURL == 'avatar'
                                    ? Image.asset(
                                        'assets/images/avatar.png',
                                        fit: BoxFit.fill,
                                        height: 120,
                                        width: 120,
                                      )
                                    : Image.network(
                                        imageURL,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                              )
                              // ClipOval(
                              //   clipBehavior: Clip.antiAlias,
                              //   //clipper: MyClipper(),
                              //   child: imageURL == 'avatar' ? Image.asset(
                              //     'assets/images/avatar.png',
                              //     fit: BoxFit.fill,
                              //     height: 120,
                              //     width: 120,
                              //   ):Image.network(imageURL,fit: BoxFit.cover,),
                              // ),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton.icon(
                        label: const Text(
                          'edit photo',
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white70,
                          size: 19,
                        ),
                        onPressed: () => _showDialog(userData),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${userData.fullName}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 32,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${userData.role}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${userData.email}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${userData.address}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Loading());
      },
    );
  }

  void _showDialog(UserInformation info) {
    String? imageUrl = 'avatar';
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: secondaryColor,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white70,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Add new photo ")),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton.icon(
                                icon: const Icon(
                                  Icons.library_add,
                                  color: secondaryColor,
                                ),
                                onPressed: () async {
                                  await uploadImage("gallery");
                                  FutureBuilder(
                                    future: loadImage(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        debugPrint('snapshot.connectionState');
                                        return Container(); //const Center(child: CircularProgressIndicator(),);
                                      }
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data.length ?? 0,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final Map image =
                                                  snapshot.data[index];
                                              //setState(() {
                                              imageUrl = image['url'];
                                              debugPrint('url = $imageUrl');
                                              //});
                                              return Container();
                                              // return Stack(
                                              //   alignment: Alignment.center,
                                              //   children: [
                                              //     //Image.network(image['url'],width: 325,height: 325,),
                                              //     SizedBox(
                                              //       height: 250,
                                              //       child: Card(
                                              //         shape: RoundedRectangleBorder(
                                              //             borderRadius:
                                              //                 BorderRadiusDirectional
                                              //                     .circular(defaultPadding)),
                                              //         clipBehavior: Clip.antiAlias,
                                              //         //child: Image.network(image['url']),
                                              //       ),
                                              //     ),
                                              //     const SizedBox(
                                              //       width: defaultPadding,
                                              //     ),
                                              //     Positioned(
                                              //       child: IconButton(
                                              //           onPressed: () async {
                                              //             await delete(image['path']);
                                              //             ScaffoldMessenger.of(context)
                                              //                 .showSnackBar(const SnackBar(
                                              //                     content: Text(
                                              //                         "Image Successfully Deleted")));
                                              //           },
                                              //
                                              //           // label: Text('',style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors
                                              //           //     .white70),),
                                              //           icon: const Icon(
                                              //             Icons.delete,
                                              //             color: Colors.white70,
                                              //           )),
                                              //       bottom: 1,
                                              //       right: 20,
                                              //     ),
                                              //   ],
                                              // );
                                            });
                                      } else {
                                        return const Center(
                                          child: Text('No image'),
                                        );
                                      }
                                    },
                                  );
                                  Navigator.pop(context);
                                  _uploadDialog(info, imageUrl!);
                                },
                                label: const Text('Gallery',
                                    style: TextStyle(color: secondaryColor))),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton.icon(
                                icon: const Icon(
                                  Icons.camera,
                                  color: secondaryColor,
                                ),
                                onPressed: () async {
                                  await uploadImage("camera");

                                  FutureBuilder(
                                    future: loadImage(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        debugPrint('snapshot.connectionState');
                                        return Container(); //const Center(child: CircularProgressIndicator(),);
                                      }
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data.length ?? 0,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final Map image =
                                                  snapshot.data[index];
                                              //setState(() {
                                              imageUrl = image['url'];
                                              debugPrint('url = $imageUrl');
                                              //});
                                              return Container();
                                              // return Stack(
                                              //   alignment: Alignment.center,
                                              //   children: [
                                              //     //Image.network(image['url'],width: 325,height: 325,),
                                              //     SizedBox(
                                              //       height: 250,
                                              //       child: Card(
                                              //         shape: RoundedRectangleBorder(
                                              //             borderRadius:
                                              //                 BorderRadiusDirectional
                                              //                     .circular(defaultPadding)),
                                              //         clipBehavior: Clip.antiAlias,
                                              //         //child: Image.network(image['url']),
                                              //       ),
                                              //     ),
                                              //     const SizedBox(
                                              //       width: defaultPadding,
                                              //     ),
                                              //     Positioned(
                                              //       child: IconButton(
                                              //           onPressed: () async {
                                              //             await delete(image['path']);
                                              //             ScaffoldMessenger.of(context)
                                              //                 .showSnackBar(const SnackBar(
                                              //                     content: Text(
                                              //                         "Image Successfully Deleted")));
                                              //           },
                                              //
                                              //           // label: Text('',style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors
                                              //           //     .white70),),
                                              //           icon: const Icon(
                                              //             Icons.delete,
                                              //             color: Colors.white70,
                                              //           )),
                                              //       bottom: 1,
                                              //       right: 20,
                                              //     ),
                                              //   ],
                                              // );
                                            });
                                      } else {
                                        return const Center(
                                          child: Text('No image'),
                                        );
                                      }
                                    },
                                  );
                                  Navigator.pop(context);
                                  _uploadDialog(info, imageUrl!);
                                },
                                label: const Text(
                                  'Camera',
                                  style: TextStyle(color: secondaryColor),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _uploadDialog(UserInformation info, String imgURL) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: secondaryColor,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white70,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("photo comes here")),
                      Text("${info.imageUrl} $imgURL"),
                      const SizedBox(
                        height: 30,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Would you like to upload this photo?")),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton.icon(
                                icon: const Icon(
                                  Icons.library_add,
                                  color: secondaryColor,
                                ),
                                onPressed: () => Navigator.pop(context),
                                label: const Text('NO',
                                    style: TextStyle(color: secondaryColor))),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton.icon(
                                icon: const Icon(
                                  Icons.camera,
                                  color: secondaryColor,
                                ),
                                onPressed: () async {
                                  await uploadImageToFireStorage(info);
                                  Navigator.pop(context);
                                },
                                label: const Text(
                                  'Yes',
                                  style: TextStyle(color: secondaryColor),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  uploadImageToFireStorage(UserInformation information) async {
    final DateTime _now = DateTime.now();
    String error = '';
    if (picketedImage == null) {
      debugPrint("picketedImage null");
      return null;
    } else {
      fileName = picketedImage!.name;
      imageFile = File(picketedImage!.path);
      debugPrint("fileName : $fileName");
      debugPrint("imageFile : $imageFile");
    }
    try {
      await firebaseStorage.ref(fileName).putFile(imageFile!);
      await DatabaseService(uid: _auth.currentUser!.uid).updateUserData(
          _auth.currentUser!.uid,
          information.fullName,
          resimAdresi,
          information.phone,
          information.address,
          information.role,
          DateFormat.yMMMMd().add_Hm().format(_now));
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
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: const Offset(200, 100), radius: 75);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class ProfileViewHeader extends StatelessWidget implements PreferredSizeWidget {
  final Widget? firstIcon;
  final Widget? secondIcon;
  final Widget child;
  final double height;
  final double childHeight;
  final Color color;

  const ProfileViewHeader({
    Key? key,
    this.height = 200.0,
    required this.childHeight,
    this.color = secondaryColor,
    this.firstIcon,
    this.secondIcon,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: <Widget>[
              ClipPath(
                clipper: _AppBarProfileClipper(height),
                child: Container(
                  width: double.maxFinite,
                  height: preferredSize.height - childHeight,
                  color: color,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      if (firstIcon != null) firstIcon!,
                      if (firstIcon != null) Expanded(child: Container()),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(child: Container()),
                      if (secondIcon != null) secondIcon!,
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _AppBarProfileClipper extends CustomClipper<Path> {
  final double childHeight;

  _AppBarProfileClipper(this.childHeight);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height - 50.0);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40.0);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
