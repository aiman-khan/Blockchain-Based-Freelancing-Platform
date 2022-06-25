import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../constants.dart';

class ReviewerAssign extends StatefulWidget {
  final projectID;
  ReviewerAssign({required this.projectID});
  @override
  State<ReviewerAssign> createState() => _ReviewerAssignState();
}

class _ReviewerAssignState extends State<ReviewerAssign> {
  final firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            HeadingWidget(
              title: 'Assign Reviewer',
              width: MediaQuery.of(context).size.width,
              back: true,
            ),
            const SizedBox(height: 5.0),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user_info')
                        .where("completed_projects", isGreaterThanOrEqualTo: 50)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (snapshot.hasError) {
                        print(snapshot.error);

                        return Text("Error: ${snapshot.error}");
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:


                          return Center(
                              child: CircularProgressIndicator()
                          );

                        default:
                          return new ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return GestureDetector(
                                onLongPress: () {

                                },
                                child: Card(
                                  child: new ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${document['username']}',
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Category: Web Development',
                                              ),
                                              SizedBox(height: 2,),
                                              Text(
                                                'Completed Projects: ${document['completed_projects']}',
                                              ),
                                              SizedBox(height: 10,),
                                            ],
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(color2),
                                                shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                )),
                                            onPressed: () {
                                              print(document['username']);
                                              firebaseServices.assignReviewer(
                                                  widget.projectID, '${document['username']}');
                                           Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Assign",
                                              style: TextStyle(
                                                  fontSize: width * 0.032,
                                                  letterSpacing: 2.2,
                                                  color: Colors.white),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                      }

                    }
                )
            ),
          ],
        ),
      ),
    );
  }
}
