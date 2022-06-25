import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rigel_fyp_project/screens/client/project/order_status.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../../constants.dart';

class ClientManageOrders extends StatefulWidget {
  @override
  State<ClientManageOrders> createState() => _ClientManageOrdersState();
}

class _ClientManageOrdersState extends State<ClientManageOrders>
    with SingleTickerProviderStateMixin {

  late TabController _tabController = new TabController(
    length: 2,
    vsync: this,
  );

  var _user = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    _tabController = new TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                    child: HeadingWidget(
                  back: false,
                  title: "Manage Orders",
                  width: width,
                )),
                color: Colors.transparent,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TabBar(
                unselectedLabelColor: Colors.black54,
                indicatorColor: color1,
                labelColor: color1,
                tabs: [
                  Tab(
                    text: 'In Progress',
                  ),
                  Tab(
                    text: 'Completed',
                  )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    InProgressOrdersDataWidget(
                        user: _user, width: width, height: height),
                    CompletedOrdersDataWidget(
                        user: _user, width: width, height: height),

                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class CompletedOrdersDataWidget extends StatelessWidget {
  const CompletedOrdersDataWidget({
    Key? key,
    required String? user,
    required this.width,
    required this.height,
  })  : _user = user,
        super(key: key);

  final String? _user;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects_assigned')
            .where(
              'clientName',
              isEqualTo: _user).orderBy("createdAt", descending: true)
            .where('status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: color1,));
          }

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.data!.docs.isEmpty) {
            return Align(
                alignment: Alignment.center,
                child: Text("No projects completed yet"));
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            default:
              return new ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      child: new ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: width * 0.035),
                                        child:
                                        Container(
                                          width: width * 0.5,
                                          child: Text(
                                            '${document['title']}',
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            TextStyle(fontSize: width * 0.05),
                                          ),
                                        )

                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(${document['status']})',
                                        style:
                                        TextStyle(fontSize: width * 0.03),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Assigned to: ${document['freelancerName']}',
                                          style: TextStyle(
                                              fontSize: width * 0.03,
                                              fontStyle: FontStyle.italic,
                                              color: color3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ${document['price']}',
                                        style: TextStyle(
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                      ethLogo
                                    ],
                                  ),
                                  Text(
                                    'Time:  ${document['time']}',
                                    style: TextStyle(
                                      fontSize: width * 0.03,
                                    ),
                                  ),
                                 Container(
                                    width: width * kSmallButtonWidth,
                                    height: height * kSmallButtonHeight,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(color1),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    ClientOrderStatus(
                                                        project:
                                                        document)));
                                      },
                                      child: Text(
                                        "SEE DETAILS",
                                        style: TextStyle(
                                            fontSize: width * 0.03,
                                            letterSpacing: 2.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
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
        });
  }
}

class InProgressOrdersDataWidget extends StatelessWidget {
  const InProgressOrdersDataWidget({
    Key? key,
    required String? user,
    required this.width,
    required this.height,
  })  : _user = user,
        super(key: key);

  final String? _user;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects_assigned')
            .where(
          'clientName',
          isGreaterThanOrEqualTo: _user,
          isLessThan: _user!.substring(0, _user!.length - 1) +
              String.fromCharCode(_user!.codeUnitAt(_user!.length - 1) + 1),
        ).where('status', whereIn: ['In Progress', 'Delivered' ])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: color1,));
          }

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.data!.docs.isEmpty) {
            return Align(
                alignment: Alignment.center,
                child: Text("No projects in progress"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(color: color1,));

            default:
              return new ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      child: new ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: width * 0.035),
                                        child: Container(
                                          width: width * 0.5,
                                          child: Text(
                                            document['title'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            TextStyle(fontSize: width * 0.05),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(${document['status']})',
                                        style:
                                        TextStyle(fontSize: width * 0.03),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Assigned to: ${document['freelancerName']}',
                                          style: TextStyle(
                                              fontSize: width * 0.03,
                                              fontStyle: FontStyle.italic,
                                              color: color3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ${document['price']}',
                                        style: TextStyle(
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                      ethLogo
                                    ],
                                  ),
                                  Text(
                                    'Time:  ${document['time']}',
                                    style: TextStyle(
                                      fontSize: width * 0.03,
                                    ),
                                  ),
                                  Container(
                                    width: width * kSmallButtonWidth,
                                    height: height * kSmallButtonHeight,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(color1),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    ClientOrderStatus(
                                                        project:
                                                        document)));
                                      },
                                      child: Text(
                                        "SEE DETAILS",
                                        style: TextStyle(
                                            fontSize: width * 0.03,
                                            letterSpacing: 2.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
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
        });
  }
}
