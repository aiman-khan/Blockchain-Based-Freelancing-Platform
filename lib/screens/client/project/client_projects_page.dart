import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rigel_fyp_project/screens/client/project/project_form_fill.dart';
import 'package:rigel_fyp_project/screens/client/project/project_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../../constants.dart';

var list = [];
var projects_list = [];
getProjectList() {
  print(list);
  return list;
}

setProjectList(value) {
  list = value;
}

class ClientsProjectsPage extends StatefulWidget {
  @override
  _ClientsProjectsPageState createState() => _ClientsProjectsPageState();
}

class _ClientsProjectsPageState extends State<ClientsProjectsPage> {
  final firestore = FirebaseFirestore.instance;
  CollectionReference projectsReference = FirebaseFirestore.instance.collection('projects');
  FirebaseAuth _auth = FirebaseAuth.instance;

  navigateToDetail(DocumentSnapshot project) {
    print(project.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectDetails(
                  projects: project,
                )));
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeadingWidget(
                  width: width,
                  title: 'My Projects',
                  back: true),
              const SizedBox(height: 30.0),
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('users')
                    .doc(_auth.currentUser!.uid)
                    .collection('projects').
                  snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("No projects added yet")),
                      );
                    }

                    else {
                      final projects = snapshot.data!.docs;
                      List<Container> projectWidgets = [];
                      for (var project in projects) {
                        final projectTitle =
                            (project.data() as dynamic)['title'];
                        final projectDescription =
                            (project.data() as dynamic)['description'];

                        final projectList = Container(
                            child: GestureDetector(
                          onTap: () => navigateToDetail(project),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                            child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        projectTitle,
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      kSizedBox(),
                                      Text(
                                        projectDescription,
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.justify,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ));

                        projectWidgets.add(projectList);
                        projects_list =
                        [(project.data() as dynamic)['userID'],
                          (project.data() as dynamic)['username'] ];
                      }

                      setProjectList(projects_list);
                      return Expanded(
                          child: ListView(
                        padding: EdgeInsets.only(left: 5),
                        children: projectWidgets.toList(),
                      ));
                    }
                  }),

              // FutureBuilder<DocumentSnapshot> (
              //   future: projectsReference.doc(_auth.currentUser!.uid).get(),
              //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //
              //     if (snapshot.hasError) {
              //       return Text("Something went wrong");
              //     }
              //
              //     if (snapshot.hasData && !snapshot.data!.exists) {
              //       return Text("Document does not exist");
              //     }
              //
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              //       return Padding(
              //         padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
              //         child: GestureDetector(
              //           onTap: () => navigateToDetail(snapshot.data!['tg']),
              //           child: Card(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.5),
              //                 child: Column(
              //                   crossAxisAlignment:
              //                   CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Text(
              //                       '${data['title']}',
              //                       style: GoogleFonts.aBeeZee(
              //                         fontSize: 18.0,
              //                       ),
              //                     ),
              //                     kSizedBox(),
              //                     Text(
              //                       '${data['description']}',
              //                       style: GoogleFonts.aBeeZee(
              //                         fontSize: 12.0,
              //                       ),
              //                       textAlign: TextAlign.justify,
              //                       maxLines: 2,
              //                     ),
              //                   ],
              //                 ),
              //               )),
              //         ),
              //       );
              //         // Text("Title: ${data['title']} ${data['description']}");
              //     }
              //     return Text("loading");
              //   },
              // )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.post_add_outlined,
                size: 40,
              ),
              decoration: BoxDecoration(
                color: color1,
                  shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 7,
                    offset: Offset(4, 5),
                  ),
                ]
                 ),
            ),
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> setAnimation,
                            Widget child) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                            alignment: Alignment.bottomRight,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return ProjectRequirementsForm();
                        }));
              });
            },
          )),
    );
  }
}
