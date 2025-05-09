import 'package:flutter/material.dart';
import 'package:catatan_harian/models/catatan_model.dart';
import 'package:catatan_harian/services/database_helper.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:catatan_harian/utils/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahCatatanScreen extends StatefulWidget {
  const TambahCatatanScreen({super.key});

  @override
  State<TambahCatatanScreen> createState() => _TambahCatatanScreenState();
}

class _TambahCatatanScreenState extends State<TambahCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _simpanCatatan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final tanggal = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
        
        final catatan = Catatan(
          judul: _judulController.text,
          isi: _isiController.text,
          tanggal: tanggal,
        );

        await DatabaseHelper.instance.tambahCatatan(catatan);
        
        if (!mounted) return;
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Catatan berhasil disimpan', 
              style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: AppColors.tertiary,
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan catatan', 
              style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.add,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Judul
                  TextFormField(
                    controller: _judulController,
                    decoration: InputDecoration(
                      labelText: AppStrings.titleHint,
                      labelStyle: GoogleFonts.poppins(color: AppColors.primary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Isi Catatan
                  Expanded(
                    child: TextFormField(
                      controller: _isiController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        labelText: AppStrings.contentHint,
                        alignLabelWithHint: true,
                        labelStyle: GoogleFonts.poppins(color: AppColors.primary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.requiredField;
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tombol Simpan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppStrings.cancel,
                          style: GoogleFonts.poppins(
                            color: AppColors.tertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(
                          AppStrings.save,
                          style: GoogleFonts.poppins(),
                        ),
                        onPressed: _simpanCatatan,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) 
            const LoadingWidget(message: AppStrings.saving),
        ],
      ),
    );
  }
}