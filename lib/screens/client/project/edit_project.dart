import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/response.dart';
import '../../../constants.dart';

class EditProject extends StatefulWidget {
  DocumentSnapshot project;

  EditProject(this.project);

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseServices firebaseServices = FirebaseServices();
  var currentUser = FirebaseAuth.instance.currentUser;
  ResponseMessage response = new ResponseMessage();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  String time = "1 day";
  String category = "Graphic Design";


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid).collection('projects').doc(widget.project.id)
        .snapshots()
        .listen((data) {
      title.text = (data.data() as dynamic)['title'];
      description.text = (data.data() as dynamic)['description'];
      price.text = (data.data() as dynamic)['price'];
      time = (data.data() as dynamic)['time'];
      category = (data.data() as dynamic)['category'];

    });
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    description.dispose();
    price.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project', style: TextStyle(color: Colors.white),),
        backgroundColor: color1,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 35,
              ),
              buildTextField("Title", title, true ),
              buildTextField("Description", description, true),
              buildTextField("Price", price, true),
              Row(
                children: [
                  Text("Time"),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  DropdownButton<String>(
                    value: time,
                    icon: Icon(AntDesign.down, size: width * 0.03,),
                    style: TextStyle(fontSize: width * 0.03, color: Colors.black ),
                    onChanged: (String? newValue) {
                      setState(() {
                        time = newValue!;
                        print(time);

                      });
                    },
                    items: <String>['1 day', '2 days', '3 days', '4 days', '5 days', '6 days','7 days']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Category"),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  DropdownButton<String>(
                    value: category,
                    icon: Icon(AntDesign.down, size: width * 0.03,),
                    style: TextStyle(fontSize: width * 0.03, color: Colors.black ),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                        print(category);

                      });
                    },
                    items: <String>['Graphic Design', 'Web Design', 'Web Development', 'Android App Development', 'UI/UX Design', 'Wordpress', 'MS Office', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10)),
                    )),

                onPressed: () {},
                child: Text("CANCEL",
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.black)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(color1),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10)),
                    )),

                onPressed: () async {
                  response.successAlertDialog(
                      context,
                      title: 'Successful!',
                      desc: 'Your info has been updated.',
                      alertAction: null
                  );
                  firebaseServices.modifyProject(
                      title,
                      description,
                      price,
                      time,
                      widget.project);
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField
      (String labelText, TextEditingController input, bool isWalletAddress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Container(
        child: TextField(
          controller: input,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          ),
        ),
      ),
    );
  }
}
