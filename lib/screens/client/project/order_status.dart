import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rigel_fyp_project/screens/client/project/feedback.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:rigel_fyp_project/description_model/function.dart';
import 'package:rigel_fyp_project/temp/api/firebase_api.dart';
import 'package:rigel_fyp_project/temp/model/firebase_file.dart';
import 'package:rigel_fyp_project/temp/page/file_page.dart';
import 'package:rigel_fyp_project/transactions/Palette.dart';
import 'package:rigel_fyp_project/transactions/data.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import '../../../constants.dart';
import '../../../payment_methods.dart';
import '../../conflict_resolution_screens/conflict_resolution_form.dart';
import 'order_revision.dart';

enum Popup { conflict, link, edit }

class ClientOrderStatus extends StatefulWidget {
  final DocumentSnapshot project;

  ClientOrderStatus({required this.project});

  @override
  _ClientOrderStatusState createState() => _ClientOrderStatusState();
}

class _ClientOrderStatusState extends State<ClientOrderStatus> {
  FirebaseServices firebaseServices = FirebaseServices();
  ResponseMessage response = ResponseMessage();
  late String title;
  late String desc;
  var futureFiles;


  bool data = false;
  Client client = Client();
  late web3dart.Web3Client ethClient;

  List<TransactionsData> list =
  List<TransactionsData>.filled(1, t1, growable: true);
  final address = "0xDDCeC1a9881a2EF93C784edDe25C96ce413bFf36";
  int myAmt = 0;
  var myData;
  int _currentSliderValue = 0;
  String contractAddress = "0xFB1dB5403b7FB3190331234E90dA890B42124314";


  @override
  void initState() {
    client = Client();
    ethClient = web3dart.Web3Client(
        "https://ropsten.infura.io/v3/1530e2d89ff74a58807de36d56485a6b",
        client);
    list = List<TransactionsData>.filled(1, t1, growable: true);
    getBalance(address);
    futureFiles = FirebaseApi.listAll('pdfs/');

    super.initState();


  }

  Future<web3dart.DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = "0xFB1dB5403b7FB3190331234E90dA890B42124314";
    final contract = web3dart.DeployedContract(web3dart.ContractAbi.fromJson(abi, "UACoins"),
        web3dart.EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result =
    ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    web3dart.EthereumAddress ethaddress = web3dart.EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    web3dart.EthPrivateKey credentials = web3dart.EthPrivateKey.fromHex(
        "b66c68a3be1cd129bc3c6480b85886d808d11901dd613d1957fc9109d50bac0b");
    web3dart.DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        web3dart.Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true,
        chainId: null);
    print(result);
    dynamic currentTime = DateFormat.jm().format(DateTime.now());
    if (functionName == "depositBalance") {
      TransactionsData t = new TransactionsData(
          "RECEIVED", result, args[0].toString(), currentTime);
      list.add(t);
      setState(() {});
    } else {
      TransactionsData t =
      new TransactionsData("PAID", result, args[0].toString(), currentTime);
      list.add(t);
      setState(() {});
    }
    return result;
  }

  Future<String> sendCoins() async {
    var bigAmt = BigInt.from(_currentSliderValue);
    var response = await submit("depositBalance", [bigAmt]);
    print("Deposited");
    return response;
  }

  Future<String> withdrawCoins() async {
    String price = (widget.project.data() as dynamic)['price'].toString();

    int priceInt = int.parse(price) ;
    var bigAmt = BigInt.from(priceInt);
    var response = await submit("withdrawBalance", [bigAmt]);
    print("WithDraw $priceInt");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var projectTime = (widget.project.data() as dynamic)['time'].toString();
    var timeStr = projectTime.replaceAll(new RegExp(r'[^0-9]'), '');
    int timeInt = int.parse(timeStr);

    var startDate = (widget.project.data() as dynamic)['createdAt'];
    DateTime toDate = DateTime.parse(startDate);
    var endDateLong =
        new DateTime(toDate.year, toDate.month, toDate.day + timeInt);
    String endDate = endDateLong
        .toString()
        .substring(0, endDateLong.toString().indexOf(' '));

    bool showSpinner = false;
    var status = (widget.project.data() as dynamic)['status'];

    FirebaseFirestore.instance
        .collection('projects_assigned')
        .doc(widget.project.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
      } else {
        print('Document does not exist');
      }
    });
    Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
          // leading: ClipOval(
          //   child: Image.network(
          //     file.url != null ? file.url : image1,
          //     width: 52,
          //     height: 52,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          title: Text(
            file.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FilePage(file: file),
          )),
        );

    Widget buildHeader(int length) => ListTile(
          tileColor: Colors.blue,
          leading: Container(
            width: 52,
            height: 52,
            child: Icon(
              Icons.file_copy,
              color: Colors.white,
            ),
          ),
          title: Text(
            '$length Files',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        );

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.04,
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: Icon(Icons.arrow_back),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: width * 0.04,
                            ),
                            Text(
                              "Order # ",
                              style: GoogleFonts.aBeeZee(
                                color: Color(0xFF3b3b53),
                                fontSize: width * 0.06,
                              ),
                            ),
                          ],
                        ),
                        ((widget.project.data() as dynamic)['status']) ==
                                'Completed'
                            ? Container()
                            : PopupMenuButton<Popup>(
                                onSelected: (Popup result) {
                                  setState(() {});
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Popup>>[
                                  PopupMenuItem<Popup>(
                                      value: Popup.link,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ConflictResolutionForm(
                                                          widget.project)));
                                        },
                                        child: Text('Resolve my Conflict',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      )),
                                ],
                              ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.06),
                      child: Row(
                        children: [
                          Text(
                            widget.project.id,
                            style: GoogleFonts.aBeeZee(
                              color: Color(0xFF3b3b53),
                              fontSize: width * 0.045,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                      text: widget.project.id))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Project ID copied to clipboard")));
                              });
                            },
                            child: Icon(
                              Icons.content_copy_sharp,
                              size: (width + height) * 0.017,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start Date:",
                        ),
                        Text((widget.project.data() as dynamic)['createdAt'])
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("End Date:"), Text(endDate.toString())],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status:"),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('projects_assigned')
                              .doc(widget.project.id)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Text("Not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                '${data['status']}',
                                style: TextStyle(
                                    color:
                                        status.toString().contains("Completed")
                                            ? color1
                                            : color2),
                              );
                            }
                            return Text("...");
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Freelancer:"),
                        Text((widget.project.data()
                            as dynamic)['freelancerName'])
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price:"),
                        Row(
                          children: [
                            Text((widget.project.data() as dynamic)['price']
                                .toString()),
                            ethLogo
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Description:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      (widget.project.data() as dynamic)['description'],
                      textAlign: TextAlign.justify,
                    ),

                    SizedBox(
                      height: height * 0.01,
                    ),
                    status.toString().contains('Delivered') ||
                            status.toString().contains('Completed')
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivered Work",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              FutureBuilder<List<FirebaseFile>>(
                                future: futureFiles,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: color1,
                                      ));
                                    default:
                                      if (snapshot.hasError) {
                                        return Center(
                                            child:
                                                Text('Some error occurred!'));
                                      } else {
                                        final files = snapshot.data!;
                                        return MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemExtent: 30.0,
                                            itemCount: files.length,
                                            itemBuilder: (context, index) {
                                              final file = files[index];
                                              return buildFile(context, file);
                                            },
                                          ),
                                        );
                                      }
                                  }
                                },
                              ),
                            ],
                          )
                        : Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('projects_assigned')
                .doc(widget.project.id)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                print(data["client_rating"].runtimeType);
                return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: data['status'].toString().contains("Delivered")
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OrderRevision(
                                      projectId: widget.project.id,
                                    );
                                  });
                              // firebaseServices.updateProjectStatus(
                              //     widget.id,
                              //     '',
                              //     "In Progress");
                            },
                            child: Text(
                              "REVISE",
                              style: TextStyle(
                                  fontSize: width * 0.032,
                                  letterSpacing: 2.2,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              colors: [color1, color2],
                            ),
                          ),
                          child: OutlinedButton(
                            onPressed: ()  async {
                              firebaseServices.updateProjectStatus(widget.project.id, '', "Completed");
                              firebaseServices.updateProjectsCount(
                               (widget.project.data() as dynamic)['freelancerName'].toString());
                              String price = (widget.project.data() as dynamic)['price'].toString();

                                await withdrawCoins();

                              print('${(widget.project.data() as dynamic)['freelancerName']} $price');
                              response.successAlertDialog(context,
                                  desc:
                                  '''Your Address: $address 
                                  Smart Contract Address: [$contractAddress]''',
                                  title: "Congrats! Order Completed.",
                                  alertAction: null);
                            },
                            child: Text(
                              "ACCEPT",
                              style: TextStyle(
                                  fontSize: width * 0.032,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )

                        : data['status'].toString().contains("Completed") &&
                                data['client_feedback'].toString().isEmpty
                            ? GiveFeedbackWidget(widget: widget, width: width)
                            : data['status'].toString().contains("Completed") &&
                                    data['client_feedback']
                                        .toString()
                                        .isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Feedback",
                                            style: TextStyle(
                                                color: color1,
                                                fontSize: width * 0.04),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          RatingBarIndicator(
                                            rating: data["client_rating"]
                                                .toDouble(),
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 30.0,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(data['client_feedback']),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Freelancer's Feedback",
                                            style: TextStyle(
                                                color: color2,
                                                fontSize: width * 0.04),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          RatingBarIndicator(
                                            rating: data["freelancer_rating"]
                                                        .toDouble() ==
                                                    0
                                                ? 0
                                                : data["freelancer_rating"]
                                                    .toDouble(),
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 30.0,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(data['freelancer_feedback']
                                                  .toString()
                                                  .isNotEmpty
                                              ? data['freelancer_feedback']
                                              : 'Not submitted'),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(color1),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ConflictResolutionForm(
                                                            widget.project)));
                                      },
                                      child: Text(
                                        "Raise Conflict",
                                        style: TextStyle(
                                            fontSize: width * 0.032,
                                            letterSpacing: 2.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ));
              }
              return Text("...");
            },
          ),

          // child: (widget.project.data() as dynamic)['status']
          //     .toString()
          //     .contains("Delivered")
          //     ?  AcceptOrderWidget(width: width,
          //     firebaseServices: firebaseServices, widget: widget.project, response: response)
          //     : (widget.project.data() as dynamic)['status']
          //     .toString()
          //     .contains("DeliverKed")
          //     ? ResolveConflictWidget(
          //   width: width,
          //   project: widget.project.id,
          // )
          //     : (widget.project.data() as dynamic)['freelancer_feedback']
          //     .toString()
          //     .isEmpty
          //     ? Container(
          //   width: MediaQuery.of(context).size.width * 0.5,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8.0),
          //     gradient: LinearGradient(
          //       colors: [color1, color2],
          //     ),
          //   ),
          //   child: MaterialButton(
          //     onPressed: () {
          //       // Navigator.push(
          //       //     context,
          //       //     MaterialPageRoute(
          //       //         builder: (BuildContext context) =>
          //       //             FreelancerFeedback(
          //       //                 projectId: widget.project.id)));
          //     },
          //     child: Text(
          //       "Give Feedback",
          //       style: TextStyle(
          //           fontSize: width * 0.032,
          //           letterSpacing: 2.2,
          //           color: Colors.white),
          //     ),
          //   ),
          // )
          //     : Text('')

          // FutureBuilder<DocumentSnapshot>(
          //           future: FirebaseFirestore.instance
          //               .collection('projects_assigned')
          //               .doc(widget.project.id)
          //               .get(),
          //           builder: (BuildContext context,
          //               AsyncSnapshot<DocumentSnapshot> snapshot) {
          //             if (snapshot.hasError) {
          //               return Text("Something went wrong");
          //             }
          //
          //             if (snapshot.hasData && !snapshot.data!.exists) {
          //               return Text("Not exist");
          //             }
          //
          //             if (snapshot.connectionState ==
          //                 ConnectionState.done) {
          //               Map<String, dynamic> data =
          //                   snapshot.data!.data() as Map<String, dynamic>;
          //               return Padding(
          //                   padding: const EdgeInsets.all(18.0),
          //                   child: data['status']
          //                               .toString()
          //                               .contains("Completed") &&
          //                           data['freelancer_feedback']
          //                               .toString()
          //                               .isEmpty
          //                       ? GiveFeedbackWidget(
          //                           width: width,
          //                           widget: widget,
          //                         )
          //                       : data['status']
          //                                   .toString()
          //                                   .contains("Completed") &&
          //                               data['client_feedback']
          //                                   .toString()
          //                                   .isNotEmpty
          //                           ? Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Text(
          //                                       "Your Feedback",
          //                                       style: TextStyle(
          //                                           color: color2,
          //                                           fontSize:
          //                                               width * 0.04),
          //                                     ),
          //                                     SizedBox(
          //                                       height: height * 0.01,
          //                                     ),
          //                                     RatingBarIndicator(
          //                                       rating: data['freelancer_rating']
          //                                                   .toDouble() ==
          //                                               0
          //                                           ? 0
          //                                           : data['freelancer_rating']
          //                                               .toDouble(),
          //                                       itemBuilder:
          //                                           (context, index) =>
          //                                               Icon(
          //                                         Icons.star,
          //                                         color: Colors.amber,
          //                                       ),
          //                                       itemCount: 5,
          //                                       itemSize: 30.0,
          //                                       direction:
          //                                           Axis.horizontal,
          //                                     ),
          //                                     SizedBox(
          //                                       height: height * 0.01,
          //                                     ),
          //                                     Text(data['freelancer_feedback']
          //                                             .toString()
          //                                             .isNotEmpty
          //                                         ? data[
          //                                             'freelancer_feedback']
          //                                         : 'Not submitted'),
          //                                   ],
          //                                 ),
          //                                 SizedBox(
          //                                   height: height * 0.04,
          //                                 ),
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Text(
          //                                       "Client's Feedback",
          //                                       style: TextStyle(
          //                                           color: color1,
          //                                           fontSize:
          //                                               width * 0.04),
          //                                     ),
          //                                     SizedBox(
          //                                       height: height * 0.01,
          //                                     ),
          //                                     RatingBarIndicator(
          //                                       rating: data['client_rating']
          //                                                   .toDouble() ==
          //                                               0
          //                                           ? 0.0
          //                                           : data['client_rating']
          //                                               .toDouble(),
          //                                       itemBuilder:
          //                                           (context, index) =>
          //                                               Icon(
          //                                         Icons.star,
          //                                         color: Colors.amber,
          //                                       ),
          //                                       itemCount: 5,
          //                                       itemSize: 30.0,
          //                                       direction:
          //                                           Axis.horizontal,
          //                                     ),
          //                                     SizedBox(
          //                                       height: height * 0.01,
          //                                     ),
          //                                     Text(data[
          //                                         'client_feedback']),
          //                                   ],
          //                                 ),
          //                               ],
          //                             )
          //                           : Text("Cancel"));
          //             }
          //             return Text("...");
          //           },
          //         )
        ),
      ),
    );
  }
}

class AcceptOrderWidget extends StatelessWidget {
  AcceptOrderWidget({
    Key? key,
    required this.width,
    required this.firebaseServices,
    required this.project,
    required this.response,
    required this.function,
  }) : super(key: key);

  final double width;
  final FirebaseServices firebaseServices;
  final DocumentSnapshot project;
  final function;
  final ResponseMessage response;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.06,
          child: OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OrderRevision(
                      projectId: project.id,
                    );
                  });
              // firebaseServices.updateProjectStatus(
              //     widget.id,
              //     '',
              //     "In Progress");
            },
            child: Text(
              "REVISE",
              style: TextStyle(
                  fontSize: width * 0.032,
                  letterSpacing: 2.2,
                  color: Colors.black),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              colors: [color1, color2],
            ),
          ),
          child: OutlinedButton(
            onPressed: () {
              // firebaseServices.updateProjectStatus(project.id, '', "Completed");
               //firebaseServices.updateProjectsCount(
                 //  (project.data() as dynamic)['freelancerName'].toString());
              String price = (project.data() as dynamic)['price'].toString();
              int priceInt = int.parse(price) ;
              function;

              print('${(project.data() as dynamic)['freelancerName']} $price');
              response.successAlertDialog(context,
                  desc: "Delivered work is marked as complete.",
                  title: "Congrats!",
                  alertAction: null);
            },
            child: Text(
              "ACCEPT",
              style: TextStyle(
                  fontSize: width * 0.032,
                  letterSpacing: 2.2,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class CancelOrderWidget extends StatelessWidget {
  const CancelOrderWidget({
    Key? key,
    required this.response,
    required this.width,
  }) : super(key: key);

  final ResponseMessage response;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
          onPressed: () {
            response.warningAlertDialog(context,
                title: "Cancel Order?",
                desc: "Are you sure you want to cancel this order?",
                alertAction: null);
          },
          child: Text(
            "CANCEL",
            style: TextStyle(
                fontSize: width * 0.032,
                letterSpacing: 2.2,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class GiveFeedbackWidget extends StatelessWidget {
  const GiveFeedbackWidget({
    Key? key,
    required this.widget,
    required this.width,
  }) : super(key: key);

  final ClientOrderStatus widget;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
                    ClientFeedback(projectId: widget.project.id)));
      },
      child: Text(
        "Give Feedback",
        style: TextStyle(
            fontSize: width * 0.032, letterSpacing: 2.2, color: Colors.white),
      ),
    );
  }
}
