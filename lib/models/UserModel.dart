class UserModel {
  String ? uid;
  String ? fullname;
  String ? email;
  String ? initialletter;

  // default constructor
  UserModel({this.uid, this.fullname, this.email,this.initialletter});

  // from map constructor
  UserModel.fromMap(Map<String,dynamic> map) {
    uid = map['uid'];
    fullname = map['fullname'];
    email = map['email'];
    initialletter = map['initialletter'];
  }

  // to map constructor
  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'initialletter': initialletter,
    };
  }
}