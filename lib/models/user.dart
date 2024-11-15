class User {
  int? id;
  final String name;
  final String lastName;
  final String status;
  final String age;
  final String bornCountry;
  final String lastSeen;
  final String placeLastSeen;
  final String url;

  User(
      {this.id,
      required this.name,
      required this.lastName,
      required this.status,
      required this.age,
      required this.bornCountry,
      required this.lastSeen,
      required this.placeLastSeen,
      required this.url});
}
