import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import 'project/project_postings.dart';
import 'profile.dart';
import '../messages/messages.dart';
import 'project/manage_orders.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

    final List _children = [
      ProjectsPostings(),
      ClientManageOrders(),
      Messages(),
      Profile(),
    ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          selectedItemColor: color1,
          onTap: onTabTapped,
          unselectedItemColor: color1,
          backgroundColor: Colors.white,
          selectedLabelStyle: GoogleFonts.aBeeZee(
            fontSize: 13.0,
            color: color1,
          ),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(AntDesign.home),
              activeIcon: Icon(Entypo.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.book_open_outline),
              activeIcon: Icon(MaterialCommunityIcons.book_open),
              label: 'Manage Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.chatbubble_ellipses_outline),
              activeIcon: Icon(Ionicons.chatbubble_ellipses_sharp),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(AntDesign.user),
              activeIcon: Icon(FontAwesome.user),
              label: 'Profile',
            ),
          ],
        ),
    );
  }
}