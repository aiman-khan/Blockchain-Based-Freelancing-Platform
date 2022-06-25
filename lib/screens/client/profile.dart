import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rigel_fyp_project/screens/user_edit_profile.dart';
import 'package:rigel_fyp_project/services/auth.dart';
import 'package:rigel_fyp_project/transactions/splash.dart';
import '../account_settings.dart';
import '../../constants.dart';
import '../sign_in.dart';
import 'package:intl/intl.dart';
import '../favorites.dart';
import '../freelancer/freelancer_home.dart';
import '../notification.dart';
import '../conflict_resolution_screens/resolution_requests.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  Auth authenticate = new Auth();
  bool showSpinner = false;
  bool status = false;
  String name = 'Rigel User';
  var skills;
  var education;

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(
            color: Colors.purple,
          ),
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 8,
                      ),
                      CircleAvatar(
                        radius: 42.0,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40.0,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user_info')
                              .doc(_auth.currentUser!.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text("...");
                            }
                            var userInfoDocument = snapshot.data;
                            String completedProjects = (userInfoDocument
                                    as dynamic)["completed_projects"]
                                .toString();
                            DateTime? accountCreation =
                                currentUser!.metadata.creationTime;
                            var formatter = new DateFormat('yMMMM');
                            String date = formatter.format(accountCreation!);

                            return Column(
                              children: [
                                Text(
                                  "${currentUser!.displayName != null ? currentUser!.displayName : name}",
                                  style: GoogleFonts.aBeeZee(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                                Text(
                                  '${currentUser!.email}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 34.0,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InsightsWidgets(
                                  width: width,
                                  title: 'Projects Completed',
                                  text: completedProjects,
                                ),
                                kSizedBox(),
                                Divider(
                                  thickness: 2,
                                  indent: 2,
                                ),
                                kSizedBox(),
                                InsightsWidgets(
                                    width: width,
                                    title: 'Joined',
                                    text: ' ${date}'),
                                kSizedBox(),
                                Divider(
                                  thickness: 2,
                                  indent: 2,
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                // Text(
                                //   'Rigel',
                                //   style: GoogleFonts.dancingScript(
                                //       fontSize: 35, letterSpacing: 2),
                                // ),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'About',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontSize: width * 0.06,
                  ),
                ),
              ),
              SizedBox(height: 15),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user_info')
                      .doc(_auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text("...");
                    }
                    var userInfoDocument = snapshot.data;
                    String skills =
                        (userInfoDocument as dynamic)["skills"].toString();
                    String education =
                        (userInfoDocument as dynamic)["education"].toString();
                    String rating =
                        (userInfoDocument as dynamic)["rating"].toString();

                    return Column(
                      children: [
                        InsightsWidgets(
                          width: width,
                          title: 'Rating',
                          text: rating.isNotEmpty ? rating : "Not rated yet",
                        ),
                        kSizedBox(),
                        Divider(
                          thickness: 2,
                          indent: 2,
                        ),
                        kSizedBox(),
                        InsightsWidgets(
                          width: width,
                          title: 'Education',
                          text: education.isNotEmpty
                              ? education
                              : "Not entered yet",
                        ),
                        kSizedBox(),
                        Divider(
                          thickness: 2,
                          indent: 2,
                        ),
                        kSizedBox(),
                        InsightsWidgets(
                            width: width,
                            title: 'Skills',
                            text:
                                skills.isNotEmpty ? skills.substring(1, skills.length - 1) : "Not entered yet"),
                        kSizedBox(),
                        Divider(
                          thickness: 2,
                          indent: 2,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_auth.currentUser!.displayName.toString()),
              accountEmail: Text(_auth.currentUser!.email.toString()),
              decoration: BoxDecoration(gradient: kGradient1),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  child: Text(_auth.currentUser!.displayName.toString()[0].toUpperCase()),
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
              title: Text('Switch to Freelancer'),
              leading: Icon(Icons.swap_horiz),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FreelancerHome()));
              },
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfile()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NotificationBar()));
              },
            ),
            ListTile(
              title: Text('Favorites'),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Favorites()));
              },
            ),
            ListTile(
              title: Text('Requests'),
              leading: Icon(Icons.event_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Requests()));
              },
            ),
            ListTile(
              title: Text('Payments'),
              leading: Icon(Icons.payment_sharp),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SmartContract()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Transactions'),
              leading: Icon(Icons.payment_sharp),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SplashScreen()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountSettings()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Support'),
              leading: Icon(Icons.report_problem),
              onTap: () {

              },
            ),
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
      ),
    );
  }
}

class InsightsWidgets extends StatelessWidget {
  const InsightsWidgets({
    Key? key,
    required this.width,
    required this.title,
    required this.text,
  }) : super(key: key);

  final double width;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title',
          textAlign: TextAlign.left,
          style: GoogleFonts.aBeeZee(fontSize: width * 0.04),
        ),
        SizedBox(),
        Text(
          '$text',
          textAlign: TextAlign.right,
          style: GoogleFonts.aBeeZee(fontSize: width * 0.04),
        ),
      ],
    );
  }
}
