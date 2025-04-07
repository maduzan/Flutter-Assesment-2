class Getuser {
  String id;
  String email;
  String telephone;
  String fullname;

  Getuser({
    required this.id,
    required this.email,
    required this.telephone,
    required this.fullname,
  });

  factory Getuser.fromFirestore(Map<String, dynamic> data, String docId) {
    return Getuser(
      id: docId,
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      fullname: data['fullname'] ?? '',
    );
  }
}
