import 'package:flutter/foundation.dart';

class UserModel {
  final String? fullName;
  final String? email;
  final String? password;

  UserModel(
      {@required this.fullName, @required this.email, @required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
    );
  }
}
