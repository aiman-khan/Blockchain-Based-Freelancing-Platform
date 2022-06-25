import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/firebase_temp.dart';
import 'package:rigel_fyp_project/widgets/appbar_widget.dart';
import 'package:rigel_fyp_project/widgets/card_widget.dart';
import '../../constants.dart';
import 'project/client_projects_page.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseServices firebaseServices = FirebaseServices();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var name = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController searchEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppBarWidget(
                          title: 'Dashboard',
                        ),
                        SizedBox(
                          width: width * 0.3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.1,
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                              ),
                              color: color1,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  height: height * 0.03,
                                  width: width * 0.2,
                                  child: Center(
                                    child: Text(
                                      "Client",
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hi ${currentUser!.displayName != null
                          ? currentUser!.displayName.toString().replaceFirst(currentUser!.displayName.toString()[0], currentUser!.displayName.toString()[0].toUpperCase())
                      : name}!",
                      style: GoogleFonts.redressed(
                        color: color1,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: TextField(
                          controller: searchEditingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            labelText: 'Search...',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print('');
                          },
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                            //  color: Color(0xff34189c),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClientsProjectsPage()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ManageOrders()));
                        },
                        child: CardWidget(
                          image: Image(
                            image: AssetImage('assets/images/manage.png'),
                          ),
                          title: 'My Projects',
                          subtitle: 'View your posted projects',
                          color: color1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                        },
                        child: CardWidget(
                          image: Image(
                            image: AssetImage('assets/images/view.png'),
                          ),
                          title: 'View Bids',
                          subtitle: 'See the received bids     ',
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.52),
                        child: Text(
                          'Popular Services',
                          style: GoogleFonts.aBeeZee(
                            color: color1,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ImageCardWidget(
                                  title: 'Logo Design',
                                  imageURL: 'assets/images/logo_design.png',
                                ),
                                ImageCardWidget(
                                  title: 'UI/UX Android',
                                  imageURL: 'assets/images/web_design_image.jpg',
                                ),
                                ImageCardWidget(
                                  title: 'Web Design',
                                  imageURL: 'assets/images/android.png',
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCardWidget extends StatelessWidget {
  final String title;
  final String imageURL;
  ImageCardWidget({required this.title, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: color2,
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("$imageURL"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$title",
                  style: TextStyle(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
