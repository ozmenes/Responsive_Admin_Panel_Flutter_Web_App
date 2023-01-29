class UserModel{

  final String? uid;
  UserModel({this.uid});
}

class UserData{
  String? uid;
  String? fullName;
  String? address;
  String? phone;
  String? email;
  String? role;
  String? createdDate;
  String? updatedDate;
  UserData({
    this.uid,
    this.phone,this.email,this.address,this.role,
    this.updatedDate,this.createdDate,this.fullName});

}