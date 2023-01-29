import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/controllers/menu_controller.dart';
import 'package:responsive_admin_panel_web_app/models/user.dart';
import 'package:responsive_admin_panel_web_app/screens/main/main_screen.dart';
import 'package:responsive_admin_panel_web_app/screens/wrapper.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "",
        authDomain: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: "",
        measurementId: ""
    )
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, e) {
        debugPrint('Error in Authentication Service: ${e.toString()}');
        return null;
      },//(_, err) => null,
      child: MaterialApp(
        title: 'Responsive Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
          canvasColor: secondaryColor,
          primarySwatch: Colors.blue,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuController(),child: const MainScreen(),)
          ],
          child: const Wrapper(),
        ),
      ),
    );
  }
}