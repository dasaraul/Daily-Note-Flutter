class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String tanggal;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
  });

  // Konversi dari Map ke objek Catatan
  factory Catatan.fromMap(Map<String, dynamic> map) {
    return Catatan(
      id: map['id'],
      judul: map['judul'],
      isi: map['isi'],
      tanggal: map['tanggal'],
    );
  }

  // Konversi dari objek Catatan ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }

  // Membuat salinan objek dengan nilai yang diperbarui
  Catatan copyWith({
    int? id,
    String? judul,
    String? isi,
    String? tanggal,
  }) {
    return Catatan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      tanggal: tanggal ?? this.tanggal,
    );
  }
}