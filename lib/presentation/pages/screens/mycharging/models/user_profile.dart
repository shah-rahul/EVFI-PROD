import 'dart:io';

class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    required this.number,
    required this.image,
  });

  final String name;
  final String email;
  final String number;
  final File image;
}
