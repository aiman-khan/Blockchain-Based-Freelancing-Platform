import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rigel_fyp_project/description_model/function.dart';
import 'package:rigel_fyp_project/services/firebase_services.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:rigel_fyp_project/transactions/data.dart';
import 'package:rigel_fyp_project/widgets/heading_widget.dart';
import '../../constants.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../payment_methods.dart';

TransactionsData t1 = new TransactionsData(
    "PAID", "OXSBJSB", "O", DateFormat.jm().format(DateTime.now()));

class PaymentConfirmation extends StatefulWidget {
  final DocumentSnapshot bid;

  PaymentConfirmation({required this.bid});

  @override
  _PaymentConfirmationState createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  FirebaseServices firebaseServices = FirebaseServices();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var projectsCollection = FirebaseFirestore.instance.collection('users');
  ResponseMessage response = ResponseMessage();
  late String price;
  late String desc;

  bool data = false;
  Client client = Client();
  late web3dart.Web3Client ethClient;

  List<TransactionsData> list =
      List<TransactionsData>.filled(1, t1, growable: true);
  final address = "0xDDCeC1a9881a2EF93C784edDe25C96ce413bFf36";
  double myAmt = 0;
  var myData;
  double project_price = 0;

  @override
  void initState() {
    client = Client();
    ethClient = web3dart.Web3Client(
        "https://ropsten.infura.io/v3/1530e2d89ff74a58807de36d56485a6b",
        client);
    list = List<TransactionsData>.filled(1, t1, growable: true);
    getBalance(address);
    super.initState();

  }

  // Future<web3dart.DeployedContract> loadContract() async {
  //   String abi = await rootBundle.loadString('assets/abi.json');
  //   String contractAddress = "0xFB1dB5403b7FB3190331234E90dA890B42124314";
  //   final contract = web3dart.DeployedContract(
  //       web3dart.ContractAbi.fromJson(abi, "UACoins"),
  //       web3dart.EthereumAddress.fromHex(contractAddress));
  //   return contract;
  // }
  //
  // Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  //   final contract = await loadContract();
  //   final ethFunction = contract.function(functionName);
  //   final result =
  //       ethClient.call(contract: contract, function: ethFunction, params: args);
  //   return result;
  // }

  // Future<void> getBalance(String targetAddress) async {
  //   web3dart.EthereumAddress ethaddress =
  //       web3dart.EthereumAddress.fromHex(targetAddress);
  //   List<dynamic> result = await query("getBalance", []);
  //   myData = result[0];
  //   data = true;
  //   setState(() {});
  // }
  //
  // Future<String> submit(String functionName, List<dynamic> args) async {
  //   web3dart.EthPrivateKey credentials = web3dart.EthPrivateKey.fromHex(
  //       "b66c68a3be1cd129bc3c6480b85886d808d11901dd613d1957fc9109d50bac0b");
  //   web3dart.DeployedContract contract = await loadContract();
  //   final ethFunction = contract.function(functionName);
  //   final result = await ethClient.sendTransaction(
  //       credentials,
  //       web3dart.Transaction.callContract(
  //           contract: contract, function: ethFunction, parameters: args),
  //       fetchChainIdFromNetworkId: true,
  //       chainId: null);
  //   print(result);
  //   dynamic currentTime = DateFormat.jm().format(DateTime.now());
  //   if (functionName == "depositBalance") {
  //     TransactionsData t = new TransactionsData(
  //         "RECEIVED", result, args[0].toString(), currentTime);
  //     list.add(t);
  //     setState(() {});
  //   } else {
  //     TransactionsData t =
  //         new TransactionsData("PAID", result, args[0].toString(), currentTime);
  //     list.add(t);
  //     setState(() {});
  //   }
  //   return result;
  // }
  //
  // Future<String> sendEther() async {
  //   double price = double.parse((widget.bid.data() as dynamic)['price']);
  //   var bigAmt = BigInt.from(price);
  //
  //   String c = myData.toString();
  //   double balance = double.parse(c);
  //   if (balance >= price) {
  //     var response = await submit("depositBalance", [bigAmt]);
  //     print("Deposited");
  //     return response;
  //   } else {
  //     return 'Insufficient balance in your account';
  //   }
  // }
  //
  // Future<String> withdrawEther() async {
  //   var bigAmt = BigInt.from(project_price);
  //   var response = await submit("withdrawBalance", [bigAmt]);
  //   print("WithDraw");
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String projectID = (widget.bid.data() as dynamic)['projectID'];
    String freelancerName = (widget.bid.data() as dynamic)['freelancerName'];
    String title = '';
    late String category;
    late String description;

    projectsCollection
        .doc(_auth.currentUser!.uid)
        .collection('projects')
        .doc(projectID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      title = documentSnapshot.get('title');
      category = documentSnapshot.get('category');
      description = documentSnapshot.get('description');
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    HeadingWidget(
                      width: width,
                      title: 'Confirm Order',
                      back: true,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 40.0),
                  child: Column(
                    children: [
                      Text(
                        'Offered by: ${(widget.bid.data() as dynamic)['freelancerName']}',
                        style: TextStyle(
                            fontSize: width * 0.04,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.01),
                      Text(
                        "Description",
                        style: GoogleFonts.aBeeZee(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        (widget.bid.data() as dynamic)['description'],
                        style: TextStyle(fontSize: width * 0.045),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 7),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget",
                        style: GoogleFonts.aBeeZee(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        (widget.bid.data() as dynamic)['price']
                                .toString()
                                .isNotEmpty
                            ? '${(widget.bid.data() as dynamic)['price'].toString().toUpperCase()} eth'
                            : 'Not given',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontStyle: (widget.bid.data() as dynamic)['price']
                                  .toString()
                                  .isNotEmpty
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Delivery Time",
                        style: GoogleFonts.aBeeZee(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        (widget.bid.data() as dynamic)['time'],
                        style: TextStyle(fontSize: width * 0.045),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Category",
                        style: GoogleFonts.aBeeZee(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      FutureBuilder<DocumentSnapshot>(
                        future: projectsCollection
                            .doc(_auth.currentUser!.uid)
                            .collection('projects')
                            .doc(projectID)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                              '${data['category']}',
                              style: TextStyle(fontSize: width * 0.045),
                            );
                          }
                          return Text("loading");
                        },
                      ),
                      SizedBox(height: height * 0.06),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.1),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Confirmation',
                        style: GoogleFonts.aBeeZee(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.aBeeZee(
                              fontSize: width * 0.04,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                (widget.bid.data() as dynamic)['price'],
                                style: GoogleFonts.aBeeZee(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                              ethLogo
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: width * 0.35,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: MaterialButton(
                onPressed: () {
                  double price =
                      double.parse((widget.bid.data() as dynamic)['price']);
                  String c = myData.toString();
                  double balance = double.parse(c);

                  // setState(() async {
                    if (balance >= price) {
                      firebaseServices.assignProject(
                          title
                              .toString()
                              .replaceFirst(title[0], title[0].toUpperCase()),
                          category,
                          projectID,
                          description,
                          (widget.bid.data() as dynamic)['time'],
                          (widget.bid.data() as dynamic)['price'],
                          freelancerName);
                      sendEther;
                      setHash((widget.bid.data() as dynamic)['description'].toString(), ethClient);

                      setState((){
                        response.successAlertDialog(context,
                            title: "Transaction Successful!",
                            desc: 'Your order has been placed.',
                            alertAction: null);
                        print('success $price $balance');
                      });


                    } else {

                      setState((){
                        response.failureAlertDialog(context,
                            title: 'Transaction Failed!',
                            desc:
                            'You have insufficient balance in your account. Please deposit enough amount and try again.');
                        print('Insufficient Balance $price $balance');
                      });
                    }
                  // });
                },
                child: Text(
                  "Place Order",
                  style: GoogleFonts.aBeeZee(
                    fontSize: (height + width) * 0.015,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
