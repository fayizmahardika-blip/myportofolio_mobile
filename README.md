# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi portofolio pribadi berbasis Flutter yang dikembangkan sebagai bagian dari Tutorial 8 dan Tugas Individu 7 mata kuliah Pemrograman Berbasis Platform.

Aplikasi ini menampilkan informasi pemilik portofolio berupa NPM, nama lengkap, dan kelas PBP. Selain itu, tersedia tiga kartIu menu, yaitu Lihat Proyek, Tambah Proyek, dan Logout, yang memiliki warna berbeda serta menampilkan SnackBar ketika ditekan.

### Identitas 
Nama : Fayiz Mahardika Ghulam Afadni
NPM  : 2506617374
Kelas : PBP F

### Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terinstal.
2. Buka terminal di folder proyek.
3. Jalankan perintah berikut:

   flutter pub get
   flutter run -d chrome

4. Untuk memeriksa kode, jalankan:

   flutter analyze

### Tugas 7

**1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**

Widget tree merupakan struktur hierarki yang menggambarkan susunan dan hubungan antar-widget dalam aplikasi Flutter. Widget dapat memiliki hubungan parent (induk) dan child (anak). Parent membungkus atau mengatur child berdasarkan fungsi widget tersebut. Misalnya, `Row` menyusun widget secara horizontal, sedangkan `Column` menyusunnya secara vertikal.

Sebuah widget juga dapat menjadi child sekaligus parent. Contohnya, `Row` merupakan child dari `Column`, tetapi juga menjadi parent dari beberapa `InfoCard`.

**2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**

Widget yang digunakan dalam aplikasi MyPortfolio Mobile meliputi:

- `MaterialApp`: menyediakan konfigurasi aplikasi berbasis Material Design, seperti tema dan halaman awal.
- `Scaffold`: menyediakan kerangka dasar halaman aplikasi.
- `AppBar`: menampilkan judul pada bagian atas halaman.
- `Text`: menampilkan tulisan, seperti nama, NPM, kelas, dan pesan sambutan.
- `Row`: menyusun widget secara horizontal.
- `Column`: menyusun widget secara vertikal.
- `Padding`: memberikan ruang di sekitar child.
- `Container`: membantu menentukan ukuran dan tata letak komponen.
- `Card`: menampilkan informasi dalam bentuk kartu.
- `SizedBox`: memberikan jarak kosong antar-widget.
- `GridView`: menyusun kartu menu dalam bentuk grid.
- `Icon`: menampilkan ikon pada tombol.
- `Material`: menyediakan permukaan Material untuk kartu menu.
- `InkWell`: menangani ketukan pengguna dan memberikan efek sentuhan.
- `SnackBar`: menampilkan pesan sementara ketika tombol ditekan.
- `SingleChildScrollView`: memungkinkan halaman digulir ketika konten melebihi ruang layar.

Selain itu, terdapat widget buatan sendiri, yaitu `MyApp` untuk konfigurasi aplikasi, `MyHomePage` untuk halaman utama, `InfoCard` untuk informasi pemilik portofolio, dan `ItemCard` untuk kartu menu yang dapat digunakan kembali.

**3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**

`MaterialApp` menyediakan konfigurasi dasar aplikasi berbasis Material Design, termasuk tema, navigasi, dan halaman awal.

Widget ini biasanya digunakan di dekat bagian paling atas widget tree agar widget turunannya dapat menggunakan fasilitas yang disediakan.

Dalam proyek ini, `MaterialApp` mengatur tema aplikasi dan menjadikan `MyHomePage` sebagai halaman awal. Widget yang diberikan langsung kepada `runApp()` adalah `MyApp`, yang kemudian membangun `MaterialApp`.

**4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?**

`StatelessWidget` tidak memiliki objek `State` internal yang dikelola menggunakan `setState()`. Widget ini cocok digunakan ketika tidak membutuhkan pengelolaan state lokal sendiri, misalnya untuk menampilkan informasi profil.

`StatefulWidget` memiliki objek `State` yang dapat menyimpan kondisi yang berubah selama aplikasi berjalan. Widget ini cocok untuk fitur seperti penghitung Like yang nilainya berubah setelah pengguna menekan tombol.

Dalam proyek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` menggunakan `StatelessWidget` karena tidak mengelola state lokal yang berubah. `ItemCard` tetap dapat menangani ketukan dan menampilkan SnackBar tanpa menjadi `StatefulWidget`.

**5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?**

`BuildContext` merupakan objek yang merepresentasikan lokasi suatu widget dalam widget tree Flutter. Context digunakan untuk menemukan informasi atau fasilitas yang tersedia berdasarkan posisi widget dalam hierarki.

Dalam method `build(BuildContext context)`, context dapat digunakan untuk mengakses tema melalui `Theme.of(context)`.   

Pada `ItemCard`, context juga digunakan melalui `ScaffoldMessenger.of(context)` untuk menampilkan SnackBar ketika kartu ditekan.

**6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**

Hot Reload menerapkan perubahan kode Dart yang didukung pada aplikasi yang sedang berjalan tanpa mengulang seluruh aplikasi dari awal. State aplikasi umumnya tetap dipertahankan. Fitur ini cocok untuk perubahan antarmuka, seperti teks, warna, dan tata letak.

Hot Restart menjalankan ulang kode Dart aplikasi, termasuk fungsi `main()`, serta menginisialisasi ulang state aplikasi. Hot Restart dapat diperlukan ketika perubahan pada proses inisialisasi tidak diterapkan melalui Hot Reload.

Full Restart menghentikan aplikasi dan menjalankannya kembali dari awal. Proses ini dapat diperlukan ketika perubahan konfigurasi atau kode native membutuhkan proses build dan peluncuran ulang.

### Dokumentasi Penggunaan AI

**AI yang digunakan:** ChatGPT dari OpenAI, serta Codex untuk bantuan pengaturan lingkungan pengembangan.

**Tujuan penggunaan:**

- Membantu memahami konsep dasar Dart dan Flutter, termasuk class, constructor, List, widget tree, serta hubungan parent-child.
- Mendiskusikan implementasi warna berbeda pada setiap `ItemCard`.
- Membantu memahami callback `onTap`, string interpolation, dan penggunaan SnackBar.
- Membahas materi `MaterialApp`, `StatelessWidget`, `StatefulWidget`, `BuildContext`, Hot Reload, dan Hot Restart.
- Membantu menyusun dan memperbaiki penjelasan pada README.
- Membantu proses pengaturan Flutter SDK dan lingkungan pengembangan.

**Strategi prompting:**

Saya menggunakan pendekatan pembelajaran bertahap. Pertanyaan diberikan untuk meminta penjelasan konsep, contoh kode sederhana, serta kuis pemahaman. Saya mencoba menjawab dengan pemahaman sendiri sebelum meminta AI mengoreksi jawaban dan menjelaskan bagian yang belum dipahami.

Contoh pertanyaan yang digunakan meliputi:
- Apa perbedaan `Color` dan `Colors.red` dalam Dart?
- Mengapa menggunakan `List<ItemHomepage>` untuk menyimpan beberapa objek?
- Mengapa `ItemCard` dapat menggunakan `StatelessWidget` meskipun memiliki callback `onTap`?
- Apa perbedaan Hot Reload dan Hot Restart?

**Verifikasi dan keterbatasan AI:**

Jawaban dan saran AI tidak langsung dianggap benar. Penjelasan dibandingkan dengan materi Tutorial 8 dan kebutuhan Tugas 7, kemudian implementasi diperiksa melalui analisis statis Flutter.

AI dapat memberikan kode yang terlihat benar secara sintaksis tetapi belum tentu sesuai dengan seluruh kebutuhan aplikasi. Oleh karena itu, hasil bantuan AI tetap perlu diperiksa pada kode proyek dan melalui pengujian aplikasi secara langsung.

Pada proses pengembangan, perintah `flutter analyze` telah dijalankan dan menghasilkan `No issues found`.