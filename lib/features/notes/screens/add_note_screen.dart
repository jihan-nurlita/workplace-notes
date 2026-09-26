import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workplace_notes/core/utils/category_helper.dart';
import 'package:workplace_notes/models/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final int? index;

  const AddNoteScreen({
    super.key,
    this.note,
    this.index,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedCategory = "Work";

  DateTime? selectedTime; // Gabungan Date + Time untuk reminder
  DateTime? selectedDate; // Penampung Tanggal

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      noteController.text = widget.note!.description;
      selectedCategory = widget.note!.category;

      selectedDate = widget.note!.reminderTime ?? widget.note!.createdAt;

      if (widget.note!.reminderTime != null) {
        selectedTime = widget.note!.reminderTime;
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // Helper Format Tanggal & Jam
  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return "${date.day}/${date.month}/${date.year}";
  }

  String formatTime(DateTime? time) {
    if (time == null) return "Select Time";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  // 🔽 MODAL BOTTOM SHEET CATEGORY PICKER (FIXED OVERFLOW)
  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled:
          true, // Memungkinkan modal sheet menyesuaikan tinggi layar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final categories =
            workplaceCategories.where((e) => e != 'All').toList();

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                // Menambahkan scroll agar konten tidak overflow
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle Bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Pilih Category",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.3,
                        ),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = selectedCategory == cat;
                          final catColor = getCategoryColor(cat);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCategory = cat;
                              });
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? catColor
                                    : catColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    getCategoryIcon(cat),
                                    color: isSelected ? Colors.white : catColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      cat,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.note == null ? "Workplace Note" : "Edit Workplace Note",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📝 TITLE LABEL & INPUT
                      Text(
                        "Title",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        autofocus: true, // 👈 Keyboard langsung aktif
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: "Enter task or note title",
                          hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF94A3B8), fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 1),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 📄 NOTE LABEL & INPUT
                      Text(
                        "Note Details",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: noteController,
                        autofocus: true, // 👈 Keyboard langsung aktif
                        maxLines: 5,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color(0xFF0F172A),
                            height: 1.4),
                        decoration: InputDecoration(
                          hintText:
                              "Write workplace details, meeting notes, or ideas...",
                          hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF94A3B8), fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 1),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🏷️ CATEGORY LABEL & SELECTOR
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),

                      InkWell(
                        onTap: _showCategoryBottomSheet,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                getCategoryIcon(selectedCategory),
                                color: getCategoryColor(selectedCategory),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                selectedCategory,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 📅 REMINDER CARDS (DATE & TIME)
                      Text(
                        "Reminder Time",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          // DATE CARD
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? now,
                                  firstDate: selectedDate != null &&
                                          selectedDate!.isBefore(now)
                                      ? selectedDate!
                                      : now,
                                  lastDate: DateTime(2100),
                                );

                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                    if (selectedTime != null) {
                                      selectedTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      );
                                    }
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined,
                                        size: 18, color: Color(0xFF64748B)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        formatDate(selectedDate),
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: selectedDate != null
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // TIME CARD
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                if (selectedDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Pilih tanggal dulu ya")),
                                  );
                                  return;
                                }

                                final initialTimeOfPicker = selectedTime != null
                                    ? TimeOfDay(
                                        hour: selectedTime!.hour,
                                        minute: selectedTime!.minute)
                                    : TimeOfDay.now();

                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: initialTimeOfPicker,
                                );

                                if (time != null) {
                                  setState(() {
                                    selectedTime = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_alarm,
                                        size: 22, color: Color(0xFF64748B)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        formatTime(selectedTime),
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: selectedTime != null
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

                      // 💾 SAVE BUTTON
                      SafeArea(
                        top: false,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              /// REMINDER
                              if (titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("The title cannot be empty.")),
                                );
                                return;
                              }

                              /// REMINDER
                              if (noteController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("The note cannot be empty.")),
                                );
                                return;
                              }

                              /// REMINDER
                              if (selectedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Pilih tanggal dulu ya")),
                                );
                                return;
                              }

                              if (selectedTime == null) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    title: Text("Tanpa Reminder",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold)),
                                    content: Text(
                                        "Yakin mau simpan tanpa jam reminder?",
                                        style: GoogleFonts.poppins()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text("Batal",
                                            style: GoogleFonts.poppins(
                                                color: Colors.grey)),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text("Lanjut",
                                            style: GoogleFonts.poppins(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;
                              }

                              final newNote = Note(
                                title: titleController.text,
                                description: noteController.text,
                                category: selectedCategory,
                                createdAt:
                                    widget.note?.createdAt ?? DateTime.now(),
                                reminderTime: selectedTime,
                              );

                              if (!context.mounted) return;
                              Navigator.pop(context, newNote);
                            },
                            child: Text(
                              "Save Workplace Note",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
