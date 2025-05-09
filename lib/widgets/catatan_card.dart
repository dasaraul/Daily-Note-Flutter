import 'package:flutter/material.dart';
import 'package:catatan_harian/models/catatan_model.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:catatan_harian/screens/edit_catatan_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatanCard extends StatelessWidget {
  final Catatan catatan;
  final Function onDelete;

  const CatatanCard({
    super.key,
    required this.catatan,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditCatatanScreen(catatan: catatan),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      catatan.judul,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.tertiary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCatatanScreen(catatan: catatan),
                            ),
                          );
                        },
                        tooltip: AppStrings.edit,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      // Tombol Hapus
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColors.tertiary),
                        onPressed: () {
                          _konfirmasiHapus(context);
                        },
                        tooltip: AppStrings.delete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                catatan.isi,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.surface,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    catatan.tanggal,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.surface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppStrings.confirm,
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            AppStrings.deleteConfirm,
            style: GoogleFonts.poppins(
              color: AppColors.primary,
            ),
          ),
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              child: Text(
                AppStrings.no,
                style: GoogleFonts.poppins(
                  color: AppColors.tertiary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppStrings.yes,
                style: GoogleFonts.poppins(),
              ),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}