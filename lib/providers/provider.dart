import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:sample/model/getuser.dart';
import 'package:sample/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderClass extends ChangeNotifier {
  Getuser? currentUser;

  Future<void> fetchUserByEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');

    if (savedEmail == null) return;

    final querySnapshot =
        await getIt<FirebaseFirestore>()
            .collection('users')
            .where('email', isEqualTo: savedEmail)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      currentUser = Getuser.fromFirestore(doc.data(), doc.id);
    } else {
      currentUser = null;
    }

    notifyListeners();
  }
}
