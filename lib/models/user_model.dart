
class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstname;
  final String lastname;
  final String phone;
  final String city;
  final String street;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.city,
    required this.street,
  });

  String get fullName => '$firstname $lastname';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstname: json['name']?['firstname'] ?? '',
      lastname: json['name']?['lastname'] ?? '',
      phone: json['phone'] ?? '',
      city: json['address']?['city'] ?? '',
      street: json['address']?['street'] ?? '',
    );
  }
}
