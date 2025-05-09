import 'package:flutter/material.dart';
import 'package:catatan_harian/models/catatan_model.dart';
import 'package:catatan_harian/services/database_helper.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:catatan_harian/utils/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class EditCatatanScreen extends StatefulWidget {
  final Catatan catatan;

  const EditCatatanScreen({
    super.key, 
    required this.catatan,
  });

  @override
  State<EditCatatanScreen> createState() => _EditCatatanScreenState();
}

class _EditCatatanScreenState extends State<EditCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _isiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.catatan.judul);
    _isiController = TextEditingController(text: widget.catatan.isi);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _updateCatatan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final tanggal = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
        
        final catatanBaru = Catatan(
          id: widget.catatan.id,
          judul: _judulController.text,
          isi: _isiController.text,
          tanggal: tanggal,
        );

        await DatabaseHelper.instance.perbaruiCatatan(catatanBaru);
        
        if (!mounted) return;
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Catatan berhasil diperbarui', 
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
            content: Text('Gagal memperbarui catatan', 
              style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _hapusCatatan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.hapusCatatan(widget.catatan.id!);
      
      if (!mounted) return;
      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan berhasil dihapus', 
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
          content: Text('Gagal menghapus catatan', 
            style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _konfirmasiHapus() {
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
                Navigator.of(context).pop();
                _hapusCatatan();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.edit,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _konfirmasiHapus,
            tooltip: AppStrings.delete,
          ),
        ],
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
                        onPressed: _updateCatatan,
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