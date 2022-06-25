import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rigel_fyp_project/services/response.dart';
import '../../constants.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  ResponseMessage response = new ResponseMessage();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController wallet_address = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('user_info')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((data) {
      email.text = (data.data() as dynamic)['email'];
      username.text = (data.data() as dynamic)['username'];
      wallet_address.text = (data.data() as dynamic)['wallet_address'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    username.dispose();
    wallet_address.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
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
              buildTextField("Username", username, false),
              buildTextField("Email", email, false ),
              buildTextField("Wallet Address", wallet_address, true),

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
                  List<String> splitList = username.text.split(" ");
                  List<String> indexList = [];
                  for (int i = 0; i < splitList.length; i++) {
                    for (int y = 1; y < splitList[i].length + 1; y++) {
                      indexList.add(splitList[i].substring(0, y).toLowerCase());
                    }
                  }
                  Map<String, dynamic> data = {
                    'username': username.text,
                    'email': email.text,
                    'wallet_address': wallet_address.text,
                    'userId': currentUser!.uid,
                    'searchIndex': indexList

                  };
                  await FirebaseFirestore.instance
                      .collection('user_info')
                      .doc(_firebaseAuth.currentUser!.uid)
                      .set(data);
                  response.successAlertDialog(
                      context,
                      title: 'Successful!',
                      desc: 'Your info has been saved.', alertAction: null);

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

  Widget buildTextField(String labelText, TextEditingController input, bool isWalletAddress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: input,
        decoration: InputDecoration(
            suffixIcon: isWalletAddress
                ? IconButton(
              onPressed: () {
                setState(() {

                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            enabled: isWalletAddress ? true : false
        ),
      ),
    );
  }
}
