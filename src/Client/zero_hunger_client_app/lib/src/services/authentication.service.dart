import 'package:flutter/cupertino.dart';
import 'package:zero_hunger_client_app/src/models/current.user.model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

import 'dart:convert';

class AuthenticationService with ChangeNotifier {
  Future<CurrentUserModel> login(String username, String password) async {
    final response = await http.post(Uri.parse("http://localhost:3000/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    return CurrentUserModel.fromJson(jsonDecode(response.body));
  }
}
