import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'users.dart';
import 'login_database.dart';

class LoginService {
  MongoDatabase mongoDatabase = MongoDatabase();

  // Constructor
  LoginService() {
    mongoDatabase.init();
  }

  Future<String?> isSignValuesValid(String username, String email) async {
    if (mongoDatabase.findUserByUsername(username) != Null) {
      return "Username already exists";
    }

    return "a";
  }

  Future<bool?> isLoginValid(String username, String password) async {
    final result = await mongoDatabase.findUserByUsername(username);
    if (result != null) {
      if (result['password'] == password) {
        return true;
      }
    }

    return null;
  }

  Future<void>? saveUser(String userName, String password, String email) {
    mongoDatabase.insertUser(userName, password, email);
    return null;
  }
}
