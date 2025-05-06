class ReportMP {
  int? id;
  final String name;
  final String lastName;
  final String status;
  final String age;
  final String bornCountry;
  final String lastSeen;
  final String placeLastSeen;
  final String? tez;
  final String? sangre;
  final String? contextura;
  final String? estatura;
  final String? cabello;
  final String? boca;
  final String? ojos;
  final String? nariz;
  final String alertNoteUrl;
  final String? image1;

  ReportMP({
    this.id,
    required this.name,
    required this.lastName,
    required this.status,
    required this.age,
    required this.bornCountry,
    required this.lastSeen,
    required this.placeLastSeen,
    this.tez,
    this.sangre,
    this.contextura,
    this.estatura,
    this.cabello,
    this.boca,
    this.ojos,
    this.nariz,
    required this.alertNoteUrl,
    this.image1,
  });

  /// Crea una instancia a partir de un Map (por ejemplo, el JSON parseado).
  factory ReportMP.fromJson(Map<String, dynamic> json) {
    return ReportMP(
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      age: json['age']?.toString() ?? '',
      bornCountry: json['bornCountry'] as String? ?? '',
      lastSeen: json['lastSeen'] as String? ?? '',
      placeLastSeen: json['placeLastSeen'] as String? ?? '',
      tez: json['tez'] as String?,
      sangre: json['sangre'] as String?,
      contextura: json['contextura'] as String?,
      estatura: json['estatura'] as String?,
      cabello: json['cabello'] as String?,
      boca: json['boca'] as String?,
      ojos: json['ojos'] as String?,
      nariz: json['nariz'] as String?,
      alertNoteUrl: json['alertNoteUrl'] as String? ?? '',
      image1: json['image1'] as String?,
    );
  }

  // Convertir de Map a Item
  factory ReportMP.fromMap(Map<String, dynamic> map) {
    return ReportMP(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      status: map['status'] as String? ?? '',
      age: map['age'] as String? ?? '',
      bornCountry: map['bornCountry'] as String? ?? '',
      lastSeen: map['lastSeen'] as String? ?? '',
      placeLastSeen: map['placeLastSeen'] as String? ?? '',
      tez: map['tez'] as String?,
      sangre: map['sangre'] as String?,
      contextura: map['contextura'] as String?,
      estatura: map['estatura'] as String?,
      cabello: map['cabello'] as String?,
      boca: map['boca'] as String?,
      ojos: map['ojos'] as String?,
      nariz: map['nariz'] as String?,
      alertNoteUrl: map['alertNoteUrl'] as String? ?? '',
      image1: map['image1'] as String?,
    );
  }

  /// Convierte la instancia a un Map para insertar/actualizar en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'lastName': lastName,
      'status': status,
      'age': age.toString(),
      'bornCountry': bornCountry,
      'lastSeen': lastSeen,
      'placeLastSeen': placeLastSeen,
      'tez': tez,
      'sangre': sangre,
      'contextura': contextura,
      'estatura': estatura,
      'cabello': cabello,
      'boca': boca,
      'ojos': ojos,
      'nariz': nariz,
      'alertNoteUrl': alertNoteUrl,
      'image1': image1,
    };
  }
}
