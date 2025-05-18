class RoleResource {
  final int id;
  final String name;

  RoleResource({
    required this.id,
    required this.name,
  });

  factory RoleResource.fromJson(Map<String, dynamic> json) {
    return RoleResource(
      id: json['id'] as int,
      name: json['name'] as String,
      //description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      //if (description != null) 'description': description,
    };
  }
} 