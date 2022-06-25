import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../constants.dart';

class ClientFeedback extends StatefulWidget {
  final String projectId;

  ClientFeedback({
    required this.projectId,
  });

  @override
  ClientFeedbackState createState() {
    return ClientFeedbackState();
  }
}

class ClientFeedbackState extends State<ClientFeedback> {
  final firestore = FirebaseFirestore.instance;
  FirebaseServices firebaseServices = FirebaseServices();
  ResponseMessage response = ResponseMessage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  var feedback = TextEditingController();
  var rating;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeadingWidget(
            back: true,
            title: 'Rate Your Experience',
            width: width,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) {
                        rating = value;
                        print(rating);
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.05),

                  kHeadingFontSize(
                      heading: 'How was your experience with the freelancer?'),
                  SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    controller: feedback,
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [color1, color2],
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          firebaseServices.giveFeedbackByFreelancer(
                            widget.projectId,
                            feedback.text,
                            rating
                          );
                          print('feedback submitted');

                          response.successAlertDialog(context,
                              title: 'Successful!',
                              desc: 'Your feedback has been submitted',
                              alertAction: null);
                        });

                      },
                      child: Text(
                        "Submit Feedback",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
