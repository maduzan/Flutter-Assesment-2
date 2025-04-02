import 'package:sample/model/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final Authservice authService;

  AuthController(this.authService);

  Future<void> signIn(String email, String password) async {
    var user = await authService.authenticate(email, password);
  }

  Future<void> signUp(String email, String password) async {
    var user = await authService.signUpWithEmailAndPassword(email, password);
  }

  Future<void> addUserToFirest(
    String password,
    String telephone,
    String fullname,
  ) async {
    var user = authService.addUserToFirestore(password, telephone, fullname);
  }

  Future<void> signOut() async {
    try {
      authService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear stored preferences
    } catch (e) {
      print("Logout failed: $e");
    }
  }
}
