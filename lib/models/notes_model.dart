class NotesModel {
  final String id;
  final String title;
  final String description;
  final DateTime createOrUpdatedAt;

  NotesModel({  
    required this.id,
    required this.title,
    required this.description,
    required this.createOrUpdatedAt,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createOrUpdatedAt: json['createOrUpdatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createOrUpdatedAt': createOrUpdatedAt,
    };
  }
}
