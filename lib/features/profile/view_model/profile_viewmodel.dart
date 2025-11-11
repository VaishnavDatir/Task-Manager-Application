import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  String _name = "Vaishnav Datir";
  String _email = "vaishnav.datir@birlasoft.com";
  bool _isLoading = false;

  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // optional delay for UX

    _isLoading = false;
    notifyListeners();
  }

  // You can later add a method to fetch user info from API
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    // example data fetched:
    _name = "Vaishnav Datir";
    _email = "vaishnav@datir.dev";

    _isLoading = false;
    notifyListeners();
  }
}
