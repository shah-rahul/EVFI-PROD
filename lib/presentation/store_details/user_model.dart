//create a User Model
class UserModel {
  final String? id;
  final String fullName;
  final String phoneNo;
  const UserModel({
    this.id,
    required this.fullName,
    required this.phoneNo,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Phone": phoneNo,
    };
  }
}
