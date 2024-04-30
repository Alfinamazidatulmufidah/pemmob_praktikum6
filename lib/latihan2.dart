import 'package:flutter/material.dart'; // Mengimpor modul flutter/material yang berisi komponen UI
import 'package:http/http.dart' as http; // Mengimpor modul http dari paket http
import 'dart:convert'; // Mengimpor modul json untuk parsing data

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter
}

// Model untuk menyimpan data hasil pemanggilan API
class Activity {
  String aktivitas; // Variabel untuk menyimpan nama aktivitas
  String jenis; // Variabel untuk menyimpan jenis aktivitas

  Activity({required this.aktivitas, required this.jenis}); // Konstruktor dengan parameter wajib

  // Konstruktor dari JSON ke atribut objek
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengambil data aktivitas dari JSON
      jenis: json['type'], // Mengambil data jenis aktivitas dari JSON
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan instance dari MyAppState sebagai state
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Variabel yang menampung hasil aktivitas dari API
  String url = "https://www.boredapi.com/api/activity"; // URL untuk API

  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Menginisialisasi objek Activity dengan nilai default
  }

  // Mengambil data dari API
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Mengirim GET request ke URL API
    if (response.statusCode == 200) { // Jika respon berhasil
      // Parsing data JSON dan mengembalikan objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else { // Jika respon gagal
      throw Exception('Gagal load'); // Lempar exception
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Memanggil fungsi init saat initState dipanggil
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Memanggil fetchData saat tombol ditekan
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Membangun UI berdasarkan hasil futureActivity
            builder: (context, snapshot) {
              if (snapshot.hasData) { // Jika data tersedia
                // Menampilkan data aktivitas dan jenis
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Teks aktivitas
                      Text("Jenis: ${snapshot.data!.jenis}") // Teks jenis aktivitas
                    ]));
              } else if (snapshot.hasError) { // Jika terjadi error
                return Text('${snapshot.error}'); // Menampilkan pesan error
              }
              // Tampilan default saat loading
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
