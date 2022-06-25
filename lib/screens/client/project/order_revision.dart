import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/firebase_storage.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:rigel_fyp_project/widgets/button_widget.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';

import '../../../constants.dart';


class OrderRevision extends StatefulWidget {
  final String projectId;

  OrderRevision({
    required this.projectId,
  });

  @override
  _OrderRevisionState createState() => _OrderRevisionState();
}

class _OrderRevisionState extends State<OrderRevision> {
  FirebaseServices firebaseServices = new FirebaseServices();
  TextEditingController work_description = TextEditingController();
  ResponseMessage response = ResponseMessage();
  var urlDownload;
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final fileName = file != null ? basename(file!.path) : 'No File Selected';


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Request a Revision", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: color1,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeadingFontSize(heading: 'Your Comments',),
            SizedBox(height: height * 0.02),

            TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),

                controller: work_description
            ),
            SizedBox(height: height * 0.05),

            ButtonWidget(
              text: 'Attach Additional File',
              icon: Icons.attach_file,
              onClicked: selectFile,
            ),
            SizedBox(height: height * 0.05),
            Text(
              fileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 48),
            ButtonWidget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: uploadFile,
            ),
            SizedBox(height: 20),
            task != null ? buildUploadStatus(task!) : Container(),
            // ButtonWidget(
            //   text: 'Download File',
            //   icon: Icons.download,
            //   onClicked: downloadFile
            // ),
            SizedBox(height: 20),
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
                    firebaseServices.deliverWork(
                        widget.projectId, work_description.text);

                    response.successAlertDialog(context,
                        title: 'Successful!',
                        desc: 'Your work has been delivered.',
                        alertAction: null);
                  }
                  );
                },
                child: Text(
                  "Submit",
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
    );
  }

  generateImageHash(File file) async{
    // var bytes = await file.readAsBytes();
    // var buffer = bytes.buffer;
    // var m = base64.encode(Uint8List.view(buffer));
    // print(file.hashCode);

    var file_bytes =  file.readAsBytesSync().toString();
    var bytes = utf8.encode(file_bytes);
    String hash = sha256.convert(bytes).toString();
    print("This is hash :  $hash");
    return hash;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    generateImageHash(file!);

    final fileName = basename(file!.path);
    final projectId = widget.projectId;
    final destination = 'projects_work/$projectId/$fileName';

    task = FirebaseApi.uploadFile(destination, file!, widget.projectId);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('projects_assigned')
        .doc(widget.projectId)
        .update({
      "file_url": urlDownload,
      //"file_hash":
    }).then((value) => print("Work Added"))
        .catchError((error) => print("Failed: $error"));

    print('Download-Link: $urlDownload');
  }

  // Future downloadFile() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   File downloadToFile = File('${appDocDir.path}/1647530654895.jpg');
  //
  //   try {
  //     await FirebaseStorage.instance
  //         .ref('/HD Stoica Azul-Wallpaper.jpg')
  //         .writeToFile(downloadToFile);
  //     print("downloaded");
  //   } on FirebaseException catch (e) {
  //     //  e.code == 'canceled'
  //   }
  // }
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);


        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}