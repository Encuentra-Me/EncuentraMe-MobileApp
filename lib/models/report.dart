class ReportMP {
  int? id;
  final String name;
  final String lastName;
  final String status;
  final int age;
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
  final double reconocimiento;
  final String alertNoteUrl;
  final String? image1Url;
  final String? image2Url;
  final String? image3Url;
  final String? image4Url;
  final String? image5Url;
  final String? image6Url;

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
    required this.reconocimiento,
    required this.alertNoteUrl,
    this.image1Url,
    this.image2Url,
    this.image3Url,
    this.image4Url,
    this.image5Url,
    this.image6Url,
  });

  factory ReportMP.fromJson(Map<String, dynamic> json) {
    return ReportMP(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'] ?? '',
      age: json['age'] ?? '',
      bornCountry: json['bornCountry'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      placeLastSeen: json['placeLastSeen'] ?? '',
      tez: json['tez'],
      sangre: json['sangre'],
      contextura: json['contextura'],
      estatura: json['estatura'],
      cabello: json['cabello'],
      boca: json['boca'],
      ojos: json['ojos'],
      nariz: json['nariz'],
      reconocimiento: (json['reconocimiento'] as num?)?.toDouble() ?? 0.0,
      alertNoteUrl: json['alertNoteUrl'] ?? '',
      image1Url: json['image1Url'],
      image2Url: json['image2Url'],
      image3Url: json['image3Url'],
      image4Url: json['image4Url'],
      image5Url: json['image5Url'],
      image6Url: json['image6Url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'lastName': lastName,
      'status': status,
      'age': age,
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
      'reconocimiento': reconocimiento,
      'alertNoteUrl': alertNoteUrl,
      'image1Url': image1Url,
      'image2Url': image2Url,
      'image3Url': image3Url,
      'image4Url': image4Url,
      'image5Url': image5Url,
      'image6Url': image6Url,
    };
  }
}
