class NotesModel {
  final String id;
  final String title;
  final String description;
  final DateTime createOrUpdatedAt;
  final String backgroundColorHex;

  NotesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createOrUpdatedAt,
    required this.backgroundColorHex,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createOrUpdatedAt: DateTime.parse(json['createOrUpdatedAt']),
      backgroundColorHex: json['backgroundColorHex'] ?? 'FFFFFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createOrUpdatedAt': createOrUpdatedAt.toIso8601String(),
      'backgroundColorHex': backgroundColorHex,
    };
  }
}
