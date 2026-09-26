class Note {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime? reminderTime;
  final DateTime createdAt;

  Note({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    this.reminderTime,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      reminderTime: map['reminderTime'] != null
          ? DateTime.tryParse(map['reminderTime'])
          : null,
      createdAt: map['createdAt'] != null
          ? (DateTime.tryParse(map['createdAt']) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
