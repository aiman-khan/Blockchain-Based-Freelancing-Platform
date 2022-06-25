import 'package:flutter/cupertino.dart';
import 'package:rigel_fyp_project/model/user.dart';
import 'package:rigel_fyp_project/services/auth.dart';
import 'package:rigel_fyp_project/services/firebase_temp.dart';

class ProfileProvider with ChangeNotifier {
  final firestoreServices = FirebaseServicesTemp();
  late String _username;
  late String _email;
  late String _userId;
  late String _wallet_address;

  String get username => _username;
  String get email => _email;
  String get userId => _userId;
  String get wallet_address => _wallet_address;
  Stream<List<Users>> get entries => firestoreServices.getEntries();

  set changeUserName(String username) {
    _username = username;
    notifyListeners();
  }

  set changeEmail(String email) {
    _email = email;
    notifyListeners();
  }

  loadAll(Users entry) {
    if (entry != null) {
      _email = entry.email;
      _username = entry.username;
      _userId = entry.userId;
      _wallet_address = entry.wallet_address;
    } else {
      _email = 'null';
      _username = 'null';
      _userId = 'null';
      _wallet_address = 'null';
    }
  }

  saveEntry() {
    if (_username == null) {
      var newEntry = Users(
          email: _email,
          username: _username,
          userId: _userId,
          wallet_address: _wallet_address);
      firestoreServices.setEntry(newEntry);
    } else {
      var updateEntry = Users(
          email: _email,
          username: _username,
          userId: _userId,
          wallet_address: _wallet_address);
      firestoreServices.setEntry(updateEntry);
    }
  }
}