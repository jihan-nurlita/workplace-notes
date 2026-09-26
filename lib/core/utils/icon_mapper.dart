import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case "Semua":
      return Icons.apps;
    case "Rutinitas":
      return Icons.repeat;
    case "Kesehatan":
      return Icons.favorite;
    case "Belajar":
      return Icons.school;
    case "Kerja":
      return Icons.work;
    case "Hobi":
      return Icons.auto_awesome;
    case "Produktif":
      return Icons.flash_on;
    default:
      return Icons.category;
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case "Rutinitas":
      return Color(0xFF6366F1);
    case "Kesehatan":
      return Color(0xFF22C55E);
    case "Belajar":
      return Color(0xFF3B82F6);
    case "Kerja":
      return Color(0xFF00A1FF);
    case "Produktif":
      return Color(0xFFF59E0B);
    case "Hobi":
      return Color(0xFFEC4899);
    default:
      return Color(0xff0066FF);
  }
}

Color getCategoryStyle(String category) {
  switch (category) {
    case "Rutinitas":
      return Color(0xFFA5B4FC); // soft indigo
    case "Kesehatan":
      return Color(0xFF22C55E).withOpacity(0.60); // soft green
    case "Belajar":
      return Color(0xFF93C5FD); // soft blue
    case "Kerja":
      return Color(0xFF468EDB).withOpacity(0.55); // soft blue
    case "Produktif":
      return Color(0xFFFCD34D); // soft amber
    case "Hobi":
      return Color(0xFFF9A8D4); // soft pink
    default:
      return Color(0xff0066FF).withOpacity(0.35);
  }
}
