import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rigel_fyp_project/services/response.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:rigel_fyp_project/transactions/data.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

import '../../payment_methods.dart';

class TransferPayment extends StatefulWidget {

  final DocumentSnapshot documentSnapshot;
  TransferPayment({required this.documentSnapshot});

  @override
  State<TransferPayment> createState() => _TransferPaymentState();
}

class _TransferPaymentState extends State<TransferPayment> {
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
    String price = (widget.documentSnapshot.data() as dynamic)['price'].toString();

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
    ResponseMessage response = ResponseMessage();


    double freelancerAward = 0;
    double clientAward = 0;

    double _calculate(client, freelancer, total_amount) {


      setState(() {
        freelancerAward = total_amount * freelancer / 100;
        clientAward = total_amount * client / 100;
      });
      return freelancerAward;

    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Payments', style: TextStyle(color: Colors.white),),
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
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text('Funds Awarded to:'),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Client'),
                  Text('${
                    (widget.documentSnapshot.data() as dynamic)['client_support']
                        .toString()
                  }%'),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Freelancer'),
                  Text('${
                      (widget.documentSnapshot.data() as dynamic)['freelancer_support']
                          .toString()
                  }%'),              ],
              ),
              SizedBox(height: 40,),
              // Container(
              //   width: width * 0.5,
              //   height: height * 0.05,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor:
              //         MaterialStateProperty.all(color1),
              //         shape: MaterialStateProperty.all(
              //           RoundedRectangleBorder(
              //               borderRadius:
              //               BorderRadius.circular(10)),
              //         )),
              //     onPressed: () {
              //
              //     },
              //     child: Text('Calculate'),
              //   ),
              // ),
              // Text('$clientAward'),
              // Text('$freelancerAward')


            ],
          ),
        ),
      ),
      bottomNavigationBar:             Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: width * 0.5,
          height: height * 0.05,
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

              String priceInString = (widget.documentSnapshot.data() as dynamic)['price']
                  .toString();

              String freelancerSupport = (widget.documentSnapshot.data() as dynamic)['freelancer_support']
                  .toString();

              String clientSupport = (widget.documentSnapshot.data() as dynamic)['client_support']
                  .toString();

              double freelancerAwardPercentage = double.parse(freelancerSupport);
              double clientAwardPercentage = double.parse(clientSupport);
              double price = double.parse(priceInString);

              freelancerAward = price * freelancerAwardPercentage / 100;
              clientAward = price * clientAwardPercentage / 100;

              setState(() {
                response.successAlertDialog(context,
                    desc: '''Client: $clientAward
Freelancer: $freelancerAward''',
                    title: 'Funds transferred!', alertAction: null);
              });

            },
            child: Text('Confirm'),
          ),
        ),
      ),
    );
  }
}
