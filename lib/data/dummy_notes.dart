// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:workplace_notes/core/utils/category_helper.dart';
// import 'package:workplace_notes/features/notes/screens/add_note_screen.dart';
// import 'package:workplace_notes/models/note_model.dart';

// class DetailNoteScreen extends StatelessWidget {
//   final Note note;
//   final int index;

//   const DetailNoteScreen({
//     super.key,
//     required this.note,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = getCategoryColor(note.category);
//     final IconData categoryIcon = getCategoryIcon(note.category);

//     // Membaca waktu pembuatan langsung dari data note
//     final String formattedDateTime =
//         DateFormat('dd MMM yyyy, HH:mm').format(note.createdAt);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: Text(
//           "Detail Note",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: const Color(0xFF1E293B),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: const Color(0xFF1E293B),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color(0xFF1E293B),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🏷️ CATEGORY BADGE MODERN
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: color.withOpacity(0.25), width: 1),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(categoryIcon, size: 16, color: color),
//                     const SizedBox(width: 6),
//                     Text(
//                       note.category,
//                       style: GoogleFonts.poppins(
//                         color: color,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 17),

//               // 📝 TITLE
//               Text(
//                 note.title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 23,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1E293B),
//                   height: 1.3,
//                 ),
//               ),

//               const SizedBox(height: 6),

//               // 📅 TANGGAL & JAM DIBUAT (STATIS)
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.calendar_today_rounded,
//                     size: 14,
//                     color: Color(0xFF94A3B8),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     "Dibuat: $formattedDateTime",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),

//               // ⏰ REMINDER TIME (Hanya muncul jika tidak null)
//               if (note.reminderTime != null) ...[
//                 const SizedBox(height: 8),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.amber.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.alarm_rounded,
//                           size: 16, color: Colors.amber),
//                       const SizedBox(width: 6),
//                       Text(
//                         "Reminder: ${note.reminderTime!.hour.toString().padLeft(2, '0')}:${note.reminderTime!.minute.toString().padLeft(2, '0')}",
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xFFB45309),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 15),
//               const Divider(color: Color(0xFFE2E8F0), thickness: 1),
//               const SizedBox(height: 16),

//               // 📄 DESCRIPTION
//               Expanded(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Text(
//                     note.description,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: const Color(0xFF475569),
//                       height: 1.6,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // 🔘 ACTIONS BUTTONS
//               Row(
//                 children: [
//                   // 🗑️ DELETE BUTTON
//                   Expanded(
//                     flex: 2,
//                     child: SizedBox(
//                       height: 54,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.redAccent,
//                           side: const BorderSide(
//                               color: Color(0xFFFCA5A5), width: 1.5),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context, {
//                             "action": "delete",
//                             "index": index,
//                           });
//                         },
//                         child: Text(
//                           "Delete",
//                           style: GoogleFonts.poppins(
//                             color: Colors.redAccent,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   // ✏️ EDIT BUTTON
//                   Expanded(
//                     flex: 3,
//                     child: SizedBox(
//                       height: 54,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           elevation: 2,
//                           shadowColor: Colors.blue.withOpacity(0.3),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: () async {
//                           final updatedNote = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => AddNoteScreen(
//                                 note: note,
//                                 index: index,
//                               ),
//                             ),
//                           );

//                           if (updatedNote != null && updatedNote is Note) {
//                             if (!context.mounted) return;
//                             Navigator.pop(context, {
//                               "action": "update",
//                               "note": updatedNote,
//                               "index": index,
//                             });
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.edit_note_rounded, size: 22),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Edit Note",
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
