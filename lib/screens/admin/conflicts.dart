import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rigel_fyp_project/screens/admin/reviewers.dart';
import 'package:rigel_fyp_project/screens/admin/transfer_payment.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../constants.dart';

class Conflicts extends StatefulWidget {
  @override
  State<Conflicts> createState() => _ConflictsState();
}

class _ConflictsState extends State<Conflicts> {
  final firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;


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
    getProjectsInProgress() {}

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            HeadingWidget(
              title: 'View Conflicts',
              width: MediaQuery.of(context).size.width,
              back: true,
            ),
            const SizedBox(height: 5.0),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('conflicts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);

                        return Text("Error: ${snapshot.error}");
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());

                        default:
                          return new ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(new ClipboardData(
                                          text: document['projectID']))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Project ID copied to clipboard")));
                                  });
                                },
                                child: Card(
                                  child: new ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${document['conflictFormSubmittedBy']}',
                                            maxLines: 3,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Category: ',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontStyle: FontStyle.italic,
                                                    color: color2),
                                              ),
                                              Text(
                                                'ProjectID: ${document['projectID']}',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontStyle: FontStyle.italic,
                                                    color: color2),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Description: ${document['description']}',
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Conflicting Person: ${document['conflictingUser']}',
                                            style: TextStyle(
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Reviewer: ',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                  document['reviewer'].toString().isNotEmpty
                                                      ? '${document['reviewer']}'
                                                      : 'Not assigned yet',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                   ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Reviewer Comments: ',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                document['reviewer_comments'].toString().isNotEmpty
                                                    ? '${document['reviewer_comments']}'
                                                    : 'Not comments yet',
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Freelancer Support: ',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                document['freelancer_support'].toString().isNotEmpty
                                                    ? '${document['freelancer_support']}%'
                                                    : '-',
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Client Support: ',
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                document['client_support'].toString().isNotEmpty
                                                    ? '${document['client_support']}%'
                                                    : '-',
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,

                                            ///  condition ? this : condition ? this : this
                                            children: [
                                              if (document['reviewer']
                                                      .toString()
                                                      .isNotEmpty ==
                                                  true) ...[
                                                if (document['isAccepted'] == true && document['resolved'] == false) ...[
                                                  Text('Assigned'),
                                                ] else if (document['resolved'] == true) ...[
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(color1),
                                                        shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                        )),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext context) =>
                                                                  TransferPayment(documentSnapshot: document,)));
                                                    },
                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        "Transfer Payments",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ] else if(document['confirmed'] == true)...[
                                                  Text('Resolved')
                                                ] else if(document['isDeclined'] == true)...[
                                                    Text('Declined')
                                                  ]
                                                  else ...[
                                                  Text('Waiting for User')
                                                ]
                                              ] else ...[
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(color1),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      )),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ReviewerAssign(
                                                                    projectID: document[
                                                                            'projectID']
                                                                        .toString())));
                                                  },
                                                  child: Text(
                                                    "Assign Reviewer",
                                                    style: GoogleFonts.aBeeZee(
                                                        fontSize: width * 0.03,
                                                        letterSpacing: 2.2,
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
