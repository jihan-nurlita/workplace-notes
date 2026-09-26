import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// LIST KATEGORI WORKPLACE LENGKAP
// (Bisa kamu pakai untuk variable `categories` di HomeScreen)
// -----------------------------------------------------------------------------
const List<String> workplaceCategories = [
  'All',
  'Work',
  'Meeting',
  'Project',
  'Tasks',
  'Important',
  'Ideas',
  'Urgent',
  'Finance',
  'Client',
  'HR',
  'Deadline',
  'Bug / Issue',
  'Study',
  'Personal',
  'Archive',
];

// -----------------------------------------------------------------------------
// GET CATEGORY ICON
// -----------------------------------------------------------------------------
IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Work':
      return Icons.work_rounded;
    case 'Meeting':
      return Icons.groups_rounded;
    case 'Project':
      return Icons.assignment_rounded;
    case 'Tasks':
      return Icons.task_alt_rounded;
    case 'Important':
      return Icons.star_rounded;
    case 'Urgent':
      return Icons.warning_amber_rounded;
    case 'Ideas':
      return Icons.lightbulb_rounded;
    case 'Finance':
      return Icons.attach_money_rounded;
    case 'Client':
      return Icons.business_center_rounded;
    case 'HR':
      return Icons.badge_rounded;
    case 'Deadline':
      return Icons.alarm_rounded;
    case 'Bug / Issue':
      return Icons.bug_report_rounded;
    case 'Study':
      return Icons.school_rounded;
    case 'Personal':
      return Icons.person_rounded;
    case 'Archive':
      return Icons.archive_rounded;
    default:
      return Icons.note_alt_rounded;
  }
}

// -----------------------------------------------------------------------------
// GET CATEGORY COLOR
// -----------------------------------------------------------------------------
Color getCategoryColor(String category) {
  switch (category) {
    case 'Work':
      return const Color(0xFF2563EB); // Royal Blue
    case 'Meeting':
      return const Color(0xFF0284C7); // Light Blue / Sky
    case 'Project':
      return const Color(0xFF0D9488); // Teal
    case 'Tasks':
      return const Color(0xFF16A34A); // Emerald Green
    case 'Important':
      return const Color(0xFFD97706); // Amber / Gold
    case 'Urgent':
      return const Color(0xFFDC2626); // Crimson Red
    case 'Ideas':
      return const Color(0xFFCA8A04); // Yellow
    case 'Finance':
      return const Color(0xFF059669); // Money Green
    case 'Client':
      return const Color(0xFF4F46E5); // Indigo
    case 'HR':
      return const Color(0xFFDB2777); // Pink
    case 'Deadline':
      return const Color(0xFFEA580C); // Orange
    case 'Bug / Issue':
      return const Color(0xFFE11D48); // Rose / Coral
    case 'Study':
      return const Color(0xFF9333EA); // Purple
    case 'Personal':
      return const Color(0xFF7C3AED); // Violet
    case 'Archive':
      return const Color(0xFF64748B); // Slate Grey
    default:
      return const Color(0xFF94A3B8); // Muted Grey
  }
}
