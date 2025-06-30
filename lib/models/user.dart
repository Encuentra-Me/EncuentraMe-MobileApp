class User {

  final int id; // de User
  final String email; // de User
  final String firstName;
  final String paternalLastName;
  final String maternalLastName;
  final String documentType;
  final String documentNumber;
  final String birthDate;
  final String countryCode;
  final String phone;
  final String ubigeo;
  final String roleName; // de Role

  User(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.paternalLastName,
      required this.maternalLastName,
      required this.documentType,
      required this.documentNumber,
      required this.birthDate,
      required this.countryCode,
      required this.phone,
      required this.ubigeo,
      required this.roleName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      paternalLastName: json['paternalLastName'] as String,
      maternalLastName: json['maternalLastName'] as String,
      documentType: json['documentType'] as String,
      documentNumber: json['documentNumber'] as String,
      birthDate: json['birthDate'] as String,
      countryCode: json['countryCode'] as String,
      phone: json['phone'] as String,
      ubigeo: json['ubigeo'] as String,
      roleName: json['roleName'] as String,
    );
  }

}
