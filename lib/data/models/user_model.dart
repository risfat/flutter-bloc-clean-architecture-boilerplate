import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.age,
    required super.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'] ?? 'N/A',
      lastName: json['lastName'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'gender': gender,
    };
  }
}
