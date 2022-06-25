import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constants.dart';
import '../sign_in.dart';
import 'all_projects_page.dart';
import 'all_users.dart';
import 'conflicts.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Conflicts conflicts = new Conflicts();

  Future<void> _signOut() async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: color1,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.1, right: 15, left: 15),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dashboard",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: width * 0.08,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      print('clicked');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      backgroundImage: AssetImage('assets/images/admin.png'),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello Admin!",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              height: height * 0.14,
                              width: width * 0.42,
                              decoration: BoxDecoration(
                                color: Color(0xff30663a),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    height: width * 0.09,
                                    width: width * 0.09,
                                    image: AssetImage(
                                        'assets/images/complaints.png'),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "View Complaints/Issues",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontSize: width * 0.038,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Conflicts(),
                                ));
                          },
                          child: Card(
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              height: height * 0.14,
                              width: width * 0.42,
                              decoration: BoxDecoration(
                                color: Color(0xff30663a),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    height: width * 0.09,
                                    width: width * 0.09,
                                    image: AssetImage(
                                        'assets/images/conflict.png'),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "View Conflicts",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontSize: width * 0.038,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AllUsers(),
                                  ));
                            },
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.black,
                              elevation: 0,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  height: height * 0.14,
                                  width: width * 0.42,
                                  decoration: BoxDecoration(
                                    color: Color(0xff30663a),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Image(
                                        height: width * 0.09,
                                        width: width * 0.09,
                                        image: AssetImage(
                                            'assets/images/user.png'),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Users Information",
                                          style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontSize: width * 0.038,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AdminProjectsPage(),
                                  ));
                            },
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.black,
                              elevation: 0,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  height: height * 0.14,
                                  width: width * 0.42,
                                  decoration: BoxDecoration(
                                    color: Color(0xff30663a),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                        height: width * 0.07,
                                        width: width * 0.07,
                                        image: AssetImage(
                                            'assets/images/view_projects.png'),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "All Projects and Bids",
                                          style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontSize: width * 0.038,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            // Text(
            //   'Projects in progress',
            //   style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold, color: Colors.white),
            // ),
            // Expanded(
            //     child: StreamBuilder<QuerySnapshot>(
            //         stream: FirebaseFirestore.instance
            //             .collection('conflicts')
            //             .snapshots(),
            //         builder: (context, snapshot) {
            //           if (snapshot.hasError) {
            //             print(snapshot.error);
            //
            //             return Text("Error: ${snapshot.error}");
            //           }
            //
            //           switch (snapshot.connectionState) {
            //             case ConnectionState.waiting:
            //               return Center(child: CircularProgressIndicator());
            //
            //             default:
            //                   return new CircularPercentIndicator(
            //                     radius: 70.0,
            //                     lineWidth: 7.0,
            //                     percent: 0.30,
            //                     center: new Text("0%"),
            //                     progressColor: Colors.green,
            //                   );
            //           }
            //         })),

          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text(_auth.currentUser!.email.toString()),
            decoration: BoxDecoration(gradient: kGradient1),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                child: Text('A'),
                backgroundColor: Colors.white60,
              ),
            ],
            onDetailsPressed: () {},
          ),
          // DrawerHeader(
          //   decoration: BoxDecoration(color: kBaseColor2),
          //   child: Text('Switch to Freelancer'),
          // ),
          ListTile(
            title: Text('Assigned Projects'),
            leading: Icon(Icons.article),
            onTap: () {},
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Sign Out '),
            leading: Icon(Icons.logout),
            onTap: () {
              setState(() {
                _signOut();
              });
            },
          ),
          ListTile(
              title: Text('Close'),
              leading: Icon(Icons.close),
              onTap: () {
                Navigator.of(context).pop();
              }),
        ]),
      ),
    );
  }
}
