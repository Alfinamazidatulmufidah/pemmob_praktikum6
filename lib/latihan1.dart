import 'dart:convert'; // Mengimpor pustaka 'dart:convert' untuk memungkinkan penggunaan fungsi-fungsi konversi JSON.

void main() {
  // JSON transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "Alfina Mazidatul",
    "nim": "22082010002",
    "program_studi": "Sistem Informasi",
    "mata_kuliah": [
      {
        "kode": "TI101",
        "nama": "Pemrograman Dasar",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "TI102",
        "nama": "Algoritma dan Struktur Data",
        "sks": 4,
        "nilai": "A-"
      },
      {
        "kode": "TI103",
        "nama": "Pemrograman Web",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode": "TI104",
        "nama": "Basis Data",
        "sks": 3,
        "nilai": "B"
      }
    ]
  }
  ''';

  // Menampilkan transkrip
  Map<String, dynamic> transkrip = json.decode(transkripJson); // Mendekode JSON menjadi Map menggunakan pustaka 'dart:convert'.
  print('Transkrip Mahasiswa:');
  print('Nama: ${transkrip['nama']}'); // Mencetak nama mahasiswa dari transkrip.
  print('NIM: ${transkrip['nim']}'); // Mencetak NIM mahasiswa dari transkrip.
  print('Program Studi: ${transkrip['program_studi']}'); // Mencetak program studi mahasiswa dari transkrip.
  print('Mata Kuliah:');
  for (var mataKuliah in transkrip['mata_kuliah']) { // Mengiterasi setiap mata kuliah dalam transkrip.
    print('  - ${mataKuliah['nama']}: ${mataKuliah['nilai']}'); // Mencetak nama mata kuliah dan nilai yang diperoleh.
  }
  print('');

  // Hitung IPK
  double ipk = hitungIPK(transkrip); // Memanggil fungsi untuk menghitung IPK.
  print('IPK: $ipk'); // Mencetak hasil perhitungan IPK.
}

// Fungsi untuk menghitung IPK dari transkrip
double hitungIPK(Map<String, dynamic> transkrip) {
  int totalSKS = 0; // Variabel untuk menyimpan total SKS.
  double totalNilai = 0; // Variabel untuk menyimpan total nilai.

  // Mengiterasi setiap mata kuliah
  for (var mataKuliah in transkrip['mata_kuliah']) {
    int sks = mataKuliah['sks']; // Mengambil jumlah SKS mata kuliah.
    String nilai = mataKuliah['nilai']; // Mengambil nilai mata kuliah.

    // Konversi nilai huruf menjadi bobot
    double bobot;
    switch (nilai) { // Memilih bobot sesuai dengan nilai huruf.
      case 'A':
        bobot = 4.0;
        break;
      case 'A-':
        bobot = 3.7;
        break;
      case 'B+':
        bobot = 3.3;
        break;
      case 'B':
        bobot = 3.0;
        break;
      case 'B-':
        bobot = 2.7;
        break;
      case 'C+':
        bobot = 2.3;
        break;
      case 'C':
        bobot = 2.0;
        break;
      case 'C-':
        bobot = 1.7;
        break;
      case 'D':
        bobot = 1.0;
        break;
      default:
        bobot = 0.0; // Jika nilai tidak dikenal, bobot dianggap 0.
    }

    // Menambahkan total nilai dan total SKS
    totalNilai += bobot * sks; // Menghitung total nilai berdasarkan bobot dan SKS.
    totalSKS += sks; // Menambahkan total SKS.
  }

  // Mengembalikan IPK
  return totalSKS == 0 ? 0 : totalNilai / totalSKS; // Mengembalikan nilai IPK atau 0 jika tidak ada SKS.
}
