import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/details.dart';
import 'package:sample/service/service.dart';
import 'package:sample/view/home.dart';
import 'package:sample/view/login.dart';
import 'package:sample/view/regester.dart';
import 'package:sample/view/splasher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routs {
  final GoRouter goRouter = GoRouter(
    initialLocation: '/splasher',
    routes: [
      GoRoute(path: '/splasher', builder: (context, state) => Splasher()),
      GoRoute(path: '/Login', builder: (context, state) => Login()),
      GoRoute(path: '/register', builder: (context, state) => Regester()),
      GoRoute(path: '/home', builder: (context, state) => Home()),
      GoRoute(
        path: '/details/:id', // Define a dynamic path parameter
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return Details(productId: productId);
        },
      ),
    ],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final bool hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;

      final ac = getIt<AuthController>();
      final firebase = getIt<FirebaseAuth>();

      final User? user = firebase.currentUser;
      if (!hasSeenSplash) {
        prefs.setBool('hasSeenSplash', true);
        return '/splasher';
      }
      if (user == null) {
        if (state.path != '/Login' && state.path != '/register') {
          return '/Login';
        }
      } else {
        if (state.path == '/Login' || state.path == '/register') {
          return '/home';
        }
      }

      return null;
    },
  );
}
