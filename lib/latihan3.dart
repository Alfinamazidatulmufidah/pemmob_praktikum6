import 'package:flutter/material.dart'; // Mengimport package flutter untuk membangun UI
import 'package:http/http.dart' as http; // Mengimport package http untuk melakukan HTTP requests
import 'dart:convert'; // Mengimport package untuk melakukan encoding/decoding JSON

// Class untuk merepresentasikan sebuah perguruan tinggi
class University {
  String name; // Nama perguruan tinggi
  String website; // Website perguruan tinggi

  // Constructor dengan parameter wajib
  University({required this.name, required this.website});
}

// Class untuk menyimpan daftar perguruan tinggi
class UniversitiesList {
  List<University> universities = []; // List untuk menyimpan objek University

  // Constructor untuk membuat objek UniversitiesList dari JSON
  UniversitiesList.fromJson(List<dynamic> json) { 
    universities = json.map((university) {
      return University(
        name: university['name'], // Mengambil nama perguruan tinggi dari JSON
        website: university['web_pages'][0], // Mengambil website pertama dari JSON
      );
    }).toList();
  }
}

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter
}

// Class MyApp adalah widget Stateful yang akan di-render
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan objek MyAppState
  }
}

// Class MyAppState adalah state dari widget MyApp
class MyAppState extends State<MyApp> {
  late Future<UniversitiesList> futureUniversities; // Future untuk menyimpan daftar perguruan tinggi

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL endpoint untuk mendapatkan data perguruan tinggi

  // Method untuk melakukan HTTP request dan mendapatkan data perguruan tinggi
  Future<UniversitiesList> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Melakukan HTTP GET request

    if (response.statusCode == 200) { // Jika response berhasil
      return UniversitiesList.fromJson(jsonDecode(response.body)); // Mendecode response body menjadi objek UniversitiesList
    } else { // Jika terjadi kesalahan
      throw Exception('Gagal load'); // Melempar exception dengan pesan kesalahan
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchData(); // Memuat data perguruan tinggi saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities List', // Judul aplikasi
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indonesian Universities'), // Judul AppBar
        ),
        body: Center(
          child: FutureBuilder<UniversitiesList>(
            future: futureUniversities, // Menggunakan futureUniversities untuk membangun UI
            builder: (context, snapshot) {
              if (snapshot.hasData) { // Jika data tersedia
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(), // Menambahkan garis pemisah di antara setiap item
                  itemCount: snapshot.data!.universities.length, // Jumlah item di ListView
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.universities[index].name), // Menampilkan nama perguruan tinggi
                      subtitle: Text(snapshot.data!.universities[index].website), // Menampilkan website perguruan tinggi
                    );
                  },
                );
              } else if (snapshot.hasError) { // Jika terjadi kesalahan
                return Text('${snapshot.error}'); // Menampilkan pesan kesalahan
              }
              return CircularProgressIndicator(); // Menampilkan indicator loading saat data sedang dimuat
            },
          ),
        ),
      ),
    );
  }
}
