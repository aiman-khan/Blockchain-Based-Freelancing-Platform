import 'package:rigel_fyp_project/services/validator.dart';

class Users {
  final String username;
  @EmailAddressValidator()
  final String email;
  final String userId;
  final String wallet_address;
  Users(
      {required this.username,
        required this.userId,
        required this.email,
        required this.wallet_address});

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'Username': username,
      'Wallet Address': wallet_address,
      'User ID': userId
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      email: json['Email'],
      username: json['Username'],
      wallet_address: json['Wallet Address'],
      userId: json['User ID'],
    );
  }
}