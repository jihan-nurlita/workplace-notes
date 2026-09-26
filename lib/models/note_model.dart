class Note {
  final String title;
  final String description;
  final String category;
  final DateTime? reminderTime;
  final DateTime createdAt; // Dibuat non-nullable (tanpa tanda ?)

  Note({
    required this.title,
    required this.description,
    required this.category,
    this.reminderTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ??
            DateTime
                .now(); // Jika createdAt tidak diisi, otomatis pakai waktu saat ini

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
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
