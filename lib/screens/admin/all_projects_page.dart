import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rigel_fyp_project/screens/freelancer/project_details.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/firebase_temp.dart';
import 'package:rigel_fyp_project/widgets/appbar_widget.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../constants.dart';

class AdminProjectsPage extends StatefulWidget {
  @override
  State<AdminProjectsPage> createState() => _AdminProjectsPageState();
}

class _AdminProjectsPageState extends State<AdminProjectsPage> {
  FirebaseServices firebaseServices = FirebaseServices();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String name = 'Rigel User';
  var currentUser = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  TextEditingController searchEditingController = new TextEditingController();
  List<String> _options = ['Recent', 'Assigned'];
  List<bool> _selected = [false, true];

  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(_options[i], style: TextStyle(color: Colors.white)),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.grey,
        backgroundColor: Colors.grey,
        selectedColor: color1,
        checkmarkColor: Colors.white,
        onSelected: (bool selected) {
          setState(() {
            _selected[i] = selected;
            if (_selected[1] == true) {}
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: filterChip));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  navigateToDetail(DocumentSnapshot project) {
    print(project.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FreelancerProjectsView(
              project: project,
            )));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeadingWidget(
            title: 'Projects', back: true, width: width,
          ),
          SizedBox(
            width: width * 0.4,
          ),
          SizedBox(
            height: 20,
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
                height: 25,
              ),

            ],
          ),

          StreamBuilder<QuerySnapshot>(
              stream: firestore.collectionGroup('projects').orderBy('createdAt', descending: true)
                  .orderBy('username', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                } else {
                  final projects = snapshot.data!.docs;
                  List<Container> projectWidgets = [];
                  for (var project in projects) {
                    final projectTitle = (project.data() as dynamic)['title'];
                    final projectDescription =
                    (project.data() as dynamic)['description'];
                    final projectPrice =
                    (project.data() as dynamic)['price'];
                    final projectOwner =
                    (project.data() as dynamic)['username'];
                    final projectStatus =
                    (project.data() as dynamic)['assigned'];
                    final projectList = Container(
                        child: GestureDetector(
                          onTap: () => navigateToDetail(project),
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                            child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    projectTitle.toString().replaceFirst(
                                                        projectTitle[0],
                                                        projectTitle[0].toUpperCase()),
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),

                                                ),

                                                SizedBox(width: width * 0.05,),


                                              ],
                                            ),
                                            kSizedBox(),
                                            SizedBox(height: height * 0.01,),

                                            Text(
                                              'Budget: $projectPrice eth',
                                              style: GoogleFonts.aBeeZee(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            SizedBox(height: height * 0.01,),

                                            Text(
                                              projectDescription.toString().replaceFirst(
                                                  projectDescription[0],
                                                  projectDescription[0].toUpperCase()),
                                              style: GoogleFonts.aBeeZee(
                                                fontSize: 12.0,
                                              ),
                                              textAlign: TextAlign.justify,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 10,),

                                            Text(
                                              'Uploaded By: $projectOwner',
                                              style: GoogleFonts.aBeeZee(
                                                color: color1,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        children: [
                                          projectStatus == true
                                              ? Image(
                                              height: (width + height) * 0.014,
                                              width: (width + height) * 0.014,
                                              image: AssetImage(
                                                  'assets/images/checked_user.png'))
                                              : Container(),
                                          projectStatus == true
                                              ? Text(
                                            "Assigned",
                                            style: TextStyle(fontSize: width * 0.025),
                                          )
                                              : Text(""),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ));

                    projectWidgets.add(projectList);
                  }
                  return Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(left: 5),
                        children: projectWidgets.toList(),
                      ));
                }
              }),

        ],
      ),
    );
  }
}
