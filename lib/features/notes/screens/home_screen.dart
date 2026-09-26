import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workplace_notes/core/utils/category_helper.dart';
import 'package:workplace_notes/features/notes/screens/add_note_screen.dart';
import 'package:workplace_notes/features/notes/screens/detail_note_screen.dart';
import 'package:workplace_notes/features/notes/widgets/note_card.dart';
import 'package:workplace_notes/models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "All"; // state filter
  List<String> categories = workplaceCategories;

  List<Note> notes = [];
  final box = Hive.box('notesBox');
  String searchQuery = "";

  // FILTER NOTES / SEARCH
  List<Note> get filteredNotes {
    List<Note> result;

    if (selectedCategory == "All") {
      result = notes;
    } else {
      result = notes.where((e) => e.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      result = result.where((note) {
        return note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            note.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  // NOTIFICATION
  int get overdueCount {
    return notes.where((note) {
      return note.reminderTime != null &&
          note.reminderTime!.isBefore(DateTime.now());
    }).length;
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // 📥 Load data
  void loadNotes() {
    final data = box.get('notes', defaultValue: []);

    if (data != null && data is List) {
      setState(() {
        notes = data.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return Note(
            title: map['title'] ?? '',
            description: map['description'] ?? '',
            category: map['category'] ?? '',
            reminderTime: map['reminderTime'] != null
                ? DateTime.parse(map['reminderTime'])
                : null,
          );
        }).toList();
      });
    }
  }

  // 🧾 Fungsi save
  void saveNotes() {
    final data = notes
        .map((e) => {
              'title': e.title,
              'description': e.description,
              'category': e.category,
              'reminderTime': e.reminderTime?.toIso8601String(),
            })
        .toList();

    box.put('notes', data);
  }

  // 🔔 Fungsi reusable untuk menampilkan SnackBar dan menangani UNDO
  void _deleteNoteWithUndo(Note removedNote, int removedIndex) {
    setState(() {
      notes.removeAt(removedIndex);
    });
    saveNotes();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior
            .fixed, // Membuat SnackBar menempel full di paling bawah
        backgroundColor: const Color(0xFF2D3142),
        duration: const Duration(seconds: 4),
        content: Text(
          "Note deleted",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        action: SnackBarAction(
          label: "UNDO",
          textColor: const Color(0xFFFFB703),
          onPressed: () {
            setState(() {
              final targetIndex =
                  removedIndex > notes.length ? notes.length : removedIndex;
              notes.insert(targetIndex, removedNote);
            });
            saveNotes();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 22.0),
        child: FloatingActionButton(
          elevation: 4,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddNoteScreen(),
              ),
            );

            if (result != null && result is Note) {
              setState(() {
                notes.add(result);
              });
              saveNotes();
            }
          },
          child: const Icon(
            Icons.add_rounded,
            size: 30,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3F6F9),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Workplace Notes",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "& Reminder Workspace",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=3",
                            ),
                          ),
                        ),
                        if (overdueCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                overdueCount.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // SEARCH BAR
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search_rounded,
                          color: Color(0xFF94A3B8)),
                      hintText: "Search your notes...",
                      hintStyle:
                          GoogleFonts.poppins(color: const Color(0xFF94A3B8)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // KATEGORI
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: categories.map((cat) {
                      final isActive = selectedCategory == cat;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isActive
                                    ? Colors.blue
                                    : const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  getCategoryIcon(cat),
                                  size: 16,
                                  color: isActive
                                      ? Colors.white
                                      : getCategoryColor(cat),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cat,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isActive
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // LIST NOTE
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.note_alt_outlined,
                              size: 70,
                              color: Color(0xFFCBD5E1),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isNotEmpty
                                  ? "No records found."
                                  : "There are no records yet.",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];

                          return TweenAnimationBuilder<double>(
                            duration:
                                Duration(milliseconds: 200 + (index * 40)),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  final removedIndex = notes.indexOf(note);
                                  _deleteNoteWithUndo(note, removedIndex);
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.delete_sweep_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                child: NoteCard(
                                  title: note.title,
                                  subtitle: note.description,
                                  color: getCategoryColor(note.category),
                                  icon: getCategoryIcon(note.category),
                                  reminderTime: note.reminderTime,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailNoteScreen(
                                          note: note,
                                          index: notes.indexOf(note),
                                        ),
                                      ),
                                    );

                                    if (result != null) {
                                      if (result["action"] == "update") {
                                        setState(() {
                                          notes[result["index"]] =
                                              result["note"];
                                        });
                                        saveNotes();
                                      } else if (result["action"] == "delete") {
                                        // Panggil fungsi UNDO saat hapus via DetailNoteScreen
                                        _deleteNoteWithUndo(
                                          result["deletedNote"] ?? note,
                                          result["index"],
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
