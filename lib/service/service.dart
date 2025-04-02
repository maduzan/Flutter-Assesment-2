import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/model/authservice.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<Authservice>(
    () => Authservice(firebaseAuth: getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AuthController>(
    () => AuthController(getIt<Authservice>()),
  );
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}
