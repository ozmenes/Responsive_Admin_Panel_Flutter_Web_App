import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/screens/main/gang.dart';
import 'package:responsive_admin_panel_web_app/utils/components/side_menu.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';


class MainScreen extends StatefulWidget {
  final int? selectedPage;
  const MainScreen({Key? key,this.selectedPage}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: context.read<MenuController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //flex 1 //left side
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),

            // takes 5/6
             Expanded(
              flex: 5,
              child: Gang(selectedPage:widget.selectedPage,)
            ),
          ],
        ),
      ),
    );
  }
}