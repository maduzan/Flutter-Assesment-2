class UserModel {
  String password;
  String telephone;
  String fullname;

  UserModel({
    required this.password,
    required this.telephone,
    required this.fullname,
  });

  // Convert model to map to store in Firestore
  Map<String, dynamic> toMap() {
    return {'password': password, 'telephone': telephone, 'fullname': fullname};
  }

  // Convert Firestore document to model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      password: map['password'],
      telephone: map['telephone'],
      fullname: map['fullname'],
    );
  }
}
