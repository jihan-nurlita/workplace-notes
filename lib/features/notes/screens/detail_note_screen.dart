import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workplace_notes/core/utils/category_helper.dart';
import 'package:workplace_notes/features/notes/screens/add_note_screen.dart';
import 'package:workplace_notes/models/note_model.dart';

class DetailNoteScreen extends StatelessWidget {
  final Note note;
  final int index;

  const DetailNoteScreen({
    super.key,
    required this.note,
    required this.index,
  });

  // 🗑️ DIALOG KONFIRMASI HAPUS
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Delete Note",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            "Are you sure you want to delete this record?",
            style: GoogleFonts.poppins(
              color: const Color(0xFF475569),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context, {
                  "action": "delete",
                  "index": index,
                });
              },
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ✏️ FUNGSI NAVIGASI EDIT
  Future<void> _navigateToEdit(BuildContext context) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNoteScreen(
          note: note,
          index: index,
        ),
      ),
    );

    if (updatedNote != null && updatedNote is Note) {
      if (!context.mounted) return;
      Navigator.pop(context, {
        "action": "update",
        "note": updatedNote,
        "index": index,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getCategoryColor(note.category);
    final IconData categoryIcon = getCategoryIcon(note.category);

    final String formattedDateTime =
        DateFormat('dd MMM yyyy, HH:mm').format(note.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Detail Note",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ✏️ TOMBOL EDIT (IconButton Minimalis)
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit_outlined,
              size: 22,
              color: Color(0xFF1E293B),
            ),
            onPressed: () => _navigateToEdit(context),
          ),

          // 🗑️ TOMBOL DELETE (IconButton Minimalis)
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 22,
              color: Color(0xFFEF4444),
            ),
            onPressed: () => _showDeleteDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ CATEGORY BADGE MODERN
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.25), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(categoryIcon, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      note.category,
                      style: GoogleFonts.poppins(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 17),

              // 📝 TITLE
              Text(
                note.title,
                style: GoogleFonts.poppins(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 6),

              // 📅 TANGGAL & JAM DIBUAT
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Dibuat: $formattedDateTime",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              // ⏰ REMINDER TIME
              if (note.reminderTime != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alarm_rounded,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        "Reminder: ${note.reminderTime!.hour.toString().padLeft(2, '0')}:${note.reminderTime!.minute.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFB45309),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 15),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1),
              const SizedBox(height: 16),

              // 📄 DESCRIPTION
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    note.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF475569),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
