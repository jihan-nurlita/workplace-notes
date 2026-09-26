import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final DateTime? reminderTime;

  const NoteCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.onDelete,
    this.onTap,
    this.reminderTime,
  });

  // Fungsi untuk menampilkan dialog konfirmasi hapus sesuai desain UI gambar
  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(
              0xFFFDF7FB), // Latar belakang bernuansa soft pink/putih
          contentPadding: const EdgeInsets.all(24),
          title: Text(
            'Delete Note',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            'Are you sure you want to delete this record?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF475569),
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF5252), // Warna tombol merah sesuai gambar
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah waktu reminder sudah lewat dari waktu sekarang
    final bool isExpired =
        reminderTime != null && reminderTime!.isBefore(DateTime.now());

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart, // Swipe dari kanan ke kiri
      confirmDismiss: (direction) async {
        final confirm = await _showDeleteDialog(context);
        return confirm ?? false;
      },
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!();
        }
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFFF5252),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Bilah Indikator Warna
              Container(
                width: 5,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),

              // Teks Judul & Deskripsi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    // ⏰ HANYA TAMPILKAN REMINDER JIKA REMINDER TIME TIDAK NULL
                    if (reminderTime != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isExpired ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isExpired ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // 💡 JARAK ANTARA TEKS DAN IKON
              const SizedBox(width: 12),

              // Tombol Delete Manual (Optional)
              if (onDelete != null) ...[
                IconButton(
                  onPressed: () async {
                    final confirm = await _showDeleteDialog(context);
                    if (confirm == true) {
                      onDelete!();
                    }
                  },
                  splashRadius: 20,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Icon Status / Kategori di Sebelah Kanan
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
