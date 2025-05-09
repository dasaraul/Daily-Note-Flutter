import 'package:flutter/material.dart';
import 'package:catatan_harian/models/catatan_model.dart';
import 'package:catatan_harian/screens/tambah_catatan_screen.dart';
import 'package:catatan_harian/services/database_helper.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:catatan_harian/utils/loading_widget.dart';
import 'package:catatan_harian/widgets/catatan_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Catatan> _catatanList = [];
  bool _isLoading = true;
  String _pencarian = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshCatatanList();
  }

  Future<void> _refreshCatatanList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Catatan> catatanList;
      if (_pencarian.isEmpty) {
        catatanList = await DatabaseHelper.instance.ambilSemuaCatatan();
      } else {
        catatanList = await DatabaseHelper.instance.cariCatatan(_pencarian);
      }

      setState(() {
        _catatanList = catatanList;
      });
    } catch (e) {
      // Handle error
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _hapusCatatan(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.hapusCatatan(id);
      await _refreshCatatanList();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan berhasil dihapus', 
            style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.tertiary,
        ),
      );
    } catch (e) {
      // Handle error
      debugPrint(e.toString());
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus catatan', 
            style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://${AppStrings.whatsappContact}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka $url');
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tentang Aplikasi',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aplikasi ${AppStrings.appName}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.tertiary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Versi 1.0.0',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aplikasi ini dibuat untuk membantu kamu menyimpan catatan harian dengan mudah dan cepat.',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.copyright,
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _launchWhatsApp,
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      color: AppColors.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Hubungi Developer',
                      style: GoogleFonts.poppins(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tutup',
                style: GoogleFonts.poppins(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
            tooltip: 'Tentang',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.search,
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _pencarian = value;
                    });
                    _refreshCatatanList();
                  },
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                  ),
                ),
              ),
              
              // List Catatan
              Expanded(
                child: _catatanList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              size: 80,
                              color: AppColors.tertiary.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.emptyNotes,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshCatatanList,
                        color: AppColors.tertiary,
                        child: ListView.builder(
                          itemCount: _catatanList.length,
                          itemBuilder: (context, index) {
                            final catatan = _catatanList[index];
                            return CatatanCard(
                              catatan: catatan,
                              onDelete: () => _hapusCatatan(catatan.id!),
                            );
                          },
                        ),
                      ),
              ),
              
              // Footer dengan copyright
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: AppColors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.copyright,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    GestureDetector(
                      onTap: _launchWhatsApp,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hubungi Developer',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading) 
            const LoadingWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahCatatanScreen(),
            ),
          );
          
          if (result == true) {
            _refreshCatatanList();
          }
        },
        tooltip: AppStrings.add,
        child: const Icon(Icons.add),
      ),
    );
  }
}