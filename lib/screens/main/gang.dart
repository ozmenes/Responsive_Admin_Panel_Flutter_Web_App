import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/screens/dashboad/dashboard_screen.dart';
import 'package:responsive_admin_panel_web_app/screens/profile/profile_page.dart';

class Gang extends StatefulWidget {
  const Gang({Key? key,this.selectedPage}) : super(key: key);
  final int? selectedPage;
  @override
  _GangState createState() => _GangState();
}

class _GangState extends State<Gang> {
  final List<Widget> _widgetList = [
    const DashboardScreen(),
    const ProfilePage(),
  ];
  int _index = 0;
  @override
  void initState() {
    if(widget.selectedPage != null){
      setState(() {
        _index = widget.selectedPage!;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _widgetList[_index]);
  }
}
