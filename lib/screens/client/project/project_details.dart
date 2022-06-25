import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../../constants.dart';
import 'edit_project.dart';

enum ProjectPopup { delete, link, edit }

class ProjectDetails extends StatefulWidget {
  final DocumentSnapshot projects;

  ProjectDetails({required this.projects});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  FirebaseServices firebaseServices = FirebaseServices();
  ResponseMessage response = ResponseMessage();
  late String title;
  late String desc;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              HeadingWidget(
                width: width,
                title: 'Project Details',
                back: true,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: PopupMenuButton<ProjectPopup>(
                  onSelected: (ProjectPopup result) {
                    setState(() {});
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ProjectPopup>>[
                    PopupMenuItem<ProjectPopup>(
                        value: ProjectPopup.link,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) => EditProject(widget.projects)
                            ));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 25,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('Edit',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        )),
                    PopupMenuItem<ProjectPopup>(
                        value: ProjectPopup.link,
                        child: TextButton(
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: widget.projects.id)).then((_){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Project ID copied to clipboard")));
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.content_copy_sharp,
                                size: 25,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('Copy ID',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        )),
                    PopupMenuItem<ProjectPopup>(
                        value: ProjectPopup.delete,
                        child: TextButton(
                          onPressed: () => response.successAlertDialog(
                            context,
                            title: 'Delete Project?',
                            desc: 'This action cannot be undone.',
                            alertAction:
                                firebaseServices.deleteProject(widget.projects),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 25,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('Delete',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kHeadingFontSize(heading: 'Title'),
                    SizedBox(width: 10),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['title'],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 2,
                    ),
                    SizedBox(height: 10),
                    kHeadingFontSize(heading: 'Description'),
                    SizedBox(width: 10),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['description'],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 2,
                    ),
                    SizedBox(height: 10),
                    kHeadingFontSize(heading: 'Category'),
                    SizedBox(width: 10),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['category'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 2,
                    ),
                    SizedBox(height: 10),
                    kHeadingFontSize(heading: 'Budget'),
                    SizedBox(width: 10),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['price']
                              .toString()
                              .isNotEmpty
                          ? (widget.projects.data() as dynamic)['price'].toString().toUpperCase()
                          : 'Not given',
                      style: TextStyle(fontSize: 20, fontStyle: (widget.projects.data() as dynamic)['price']
                          .toString()
                          .isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 2,
                    ),
                    SizedBox(height: 10),
                    kHeadingFontSize(heading: 'Delivery Time'),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['time'],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 2,
                      indent: 2,
                    ),
                    kHeadingFontSize(heading: 'Created at'),
                    SizedBox(width: 10),
                    SizedBox(height: 5),
                    Text(
                      (widget.projects.data() as dynamic)['createdAt'] != null
                      ? "" : (widget.projects.data() as dynamic)['createdAt'],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
