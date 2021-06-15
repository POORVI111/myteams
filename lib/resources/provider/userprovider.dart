import 'package:flutter/widgets.dart';
import 'package:myteams/models/user.dart';

import '../auth_methods.dart';


class UserProvider with ChangeNotifier {
  UserHelper _user;
  AuthMethods _authMethods = AuthMethods();

  UserHelper get getUser => _user;

  Future<void> refreshUser() async {
    UserHelper user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}
