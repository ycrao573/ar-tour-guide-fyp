class GoogleUserModel {
  String? id;
  String? email;
  String? displayName;
  String? photoURL;

  GoogleUserModel({this.id, this.email, this.displayName, this.photoURL});

  // receiving data from server
  factory GoogleUserModel.fromMap(map) {
    return GoogleUserModel(
        email: map['email'],
        displayName: map['displayName'],
        photoURL: map['photoURL']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL
    };
  }
}
