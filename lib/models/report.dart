class ReportMP {
  int? id;
  final String name;
  final String lastName;
  final String status;
  final String age;
  final String bornCountry;
  final String lastSeen;
  final String placeLastSeen;
  final String url;

  ReportMP(
      {this.id,
      required this.name,
      required this.lastName,
      required this.status,
      required this.age,
      required this.bornCountry,
      required this.lastSeen,
      required this.placeLastSeen,
      required this.url});

  // Convertir de Map a Item
  factory ReportMP.fromMap(Map<String, dynamic> map) {
    return ReportMP(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      status: map['status'] as String? ?? '',
      age: map['age'].toString(),
      bornCountry: map['bornCountry'] as String? ?? '',
      lastSeen: map['lastSeen'] as String,
      placeLastSeen: map['placeLastSeen'] as String? ?? '',
      url: map['url'] as String? ?? '',
    );
  }

  // Convertir de Item a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastName,
      'status': status,
      'age': age,
      'bornCountry': bornCountry,
      'lastSeen': lastSeen,
      'placeLastSeen': placeLastSeen,
      'url': url,
    };
  }
}
