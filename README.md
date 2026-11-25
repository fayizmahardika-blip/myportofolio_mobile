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

## Tutorial 9

- `lib/screens/menu.dart`: halaman utama dan identitas pemilik.
- `lib/screens/project_form.dart`: formulir proyek dengan lima isian.
- `lib/widgets/left_drawer.dart`: Home dan Add Project menggunakan `pushReplacement`.
- `lib/widgets/project_card.dart`: kartu menu; Tambah Proyek menggunakan `push`.
- Nama dan deskripsi wajib diisi serta menolak spasi saja. Kategori memiliki lima pilihan;
  teknologi dan tautan boleh kosong sesuai tutorial.
- Save menampilkan seluruh data pada AlertDialog. OK menutup dialog dan mereset
  isian serta kategori ke Web Development. Data belum disimpan ke database.
- Impor Material menggunakan `material_ui` sesuai PDF, termasuk pada pengujian.

## AI Disclosure Tutorial 9

Dalam pengerjaan Tutorial 9, saya menggunakan **ChatGPT (OpenAI)** sebagai alat bantu untuk memahami materi dan proses pengembangan aplikasi Flutter.

AI membantu memberikan penjelasan mengenai konsep navigasi menggunakan `Navigator`, penggunaan `Drawer`, pembuatan form, validasi input, serta pengelolaan widget dan struktur proyek.

Strategi prompting yang saya gunakan adalah memberikan konteks proyek dan instruksi tutorial, kemudian meminta penjelasan serta contoh implementasi untuk bagian yang belum saya pahami.

Hasil bantuan AI tetap saya sesuaikan dengan instruksi tutorial dan saya periksa kembali untuk memastikan implementasinya berjalan dengan baik. AI digunakan sebagai pendukung pembelajaran, sedangkan tanggung jawab akhir pengerjaan tetap berada pada saya.

### Tugas 8

**1. Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.**

`Navigator.push()` digunakan untuk menambahkan halaman baru ke dalam navigation stack. Dengan metode ini, pengguna dapat kembali ke halaman sebelumnya menggunakan tombol Back.

`Navigator.pushReplacement()` digunakan untuk mengganti halaman yang sedang aktif dengan halaman baru, sehingga halaman yang digantikan tidak lagi berada pada posisi tersebut dalam navigation stack.

Sementara itu, `Navigator.pop()` digunakan untuk menutup route yang berada di bagian teratas navigation stack, sehingga pengguna kembali ke route sebelumnya.

Dalam proyek MyPortfolio Mobile, `Navigator.push()` digunakan pada kartu aksi Tambah Edukasi untuk membuka `EducationFormPage`. Dengan demikian, pengguna dapat kembali ke halaman utama menggunakan tombol Back.

Opsi Home pada Drawer menggunakan navigasi untuk membawa pengguna kembali ke `MyHomePage`, sehingga pengguna dapat berpindah dari halaman formulir ke halaman utama.

**2. Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.**

`Scaffold` menyediakan kerangka dasar halaman Flutter, seperti area `AppBar`, `Drawer`, dan `body`.

`AppBar` digunakan untuk menampilkan judul halaman, sedangkan `Drawer` menyediakan menu navigasi yang dapat digunakan untuk berpindah antarhalaman.

Dengan menggunakan struktur tersebut secara konsisten, halaman Home, Add Project, dan Add Education memiliki pola antarmuka serta navigasi yang serupa.

Sebagai contoh, warna utama aplikasi dapat diambil menggunakan `Theme.of(context).colorScheme.primary` dan digunakan sebagai warna latar `AppBar` pada halaman Home maupun halaman Education Form. Dengan demikian, kedua halaman tetap mengikuti tema portofolio yang sama.

**3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.**

Form Edukasi disusun menggunakan `Column` agar seluruh input ditampilkan secara vertikal dan mudah diikuti oleh pengguna.

Widget `Padding` digunakan untuk memberikan jarak antara konten dengan tepi halaman, sedangkan `SizedBox` memberikan jarak antar-input agar tampilan lebih rapi dan mudah dibaca.

Selain itu, `SingleChildScrollView` digunakan agar seluruh elemen formulir dapat digulir ketika ukuran layar terbatas atau papan ketik sedang ditampilkan.

Tata letak ini dipilih karena aplikasi Flutter dapat dijalankan pada perangkat dengan berbagai ukuran layar. Dengan adanya fitur scrolling, pengguna tetap dapat mengakses input dan tombol Simpan pada layar yang sempit.

**4. Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.**

`GlobalKey<FormState>` digunakan untuk mengakses dan mengelola state dari widget `Form`, termasuk menjalankan validasi terhadap input yang berada di dalamnya.

`validator` merupakan fungsi yang memeriksa apakah nilai suatu input telah memenuhi persyaratan. Jika input tidak valid, validator mengembalikan pesan kesalahan. Jika input valid, validator mengembalikan `null`.

Ketika tombol Simpan ditekan, aplikasi menjalankan `_formKey.currentState!.validate()` untuk memeriksa seluruh field yang memiliki validator.

Sebagai contoh, jika pengguna mengisi Nama Institusi hanya dengan spasi (`"   "`), input tersebut akan ditolak karena setelah menggunakan `trim()`, nilainya menjadi string kosong.

Pada Form Edukasi, validasi juga digunakan untuk memastikan tanggal selesai tidak lebih awal daripada tanggal mulai.

Penggunaan jenis input atau papan ketik yang sesuai memang membantu pengguna memasukkan data, tetapi tidak menjamin data tersebut benar. Oleh karena itu, validasi tetap diperlukan untuk memeriksa isi, kelengkapan, dan kesesuaian data sebelum menampilkan ringkasan melalui `AlertDialog`.

### Penggunaan AI pada Tugas 8

Dalam pengerjaan Tugas 8, saya menggunakan **ChatGPT (OpenAI)** untuk membantu memahami materi Flutter serta memberikan panduan implementasi Form Edukasi.

Bantuan AI mencakup penyusunan contoh kode `StatefulWidget`, pembuatan input dan validasi formulir, penggunaan `showDatePicker()`, integrasi navigasi dengan `Navigator.push()`, serta pengembangan Drawer dan `AlertDialog`.

Strategi prompting dilakukan dengan memberikan konteks proyek dari Tutorial 9 beserta persyaratan Tugas 8, kemudian meminta AI memberikan penjelasan konsep dan contoh implementasi secara bertahap.

Hasil bantuan AI tetap perlu dibandingkan dengan instruksi tugas serta diperiksa melalui analisis kode dan pengujian aplikasi. AI dapat menghasilkan kode yang secara sintaksis terlihat benar, tetapi masih memiliki masalah pada alur navigasi atau interaksi pengguna. Karena itu, pengujian langsung tetap diperlukan untuk memastikan fitur berjalan sesuai kebutuhan.


## Tutorial 10: Flutter Backend Integration, Authentication, and CI/CD

### Implementasi

Pada Tutorial 10, aplikasi MyPortfolio Mobile diintegrasikan dengan backend Django REST Framework sehingga aplikasi dapat mengambil dan mengirimkan data secara dinamis melalui REST API.

Beberapa fitur yang diimplementasikan pada tutorial ini adalah:

- Konfigurasi Token Authentication dan CORS pada backend Django.
- Pembuatan endpoint login dan logout berbasis token.
- Implementasi model Project menggunakan `json_serializable`.
- Implementasi `ApiClient` untuk menangani HTTP request dan response.
- Penggunaan `FutureBuilder` dan `RefreshIndicator` untuk menampilkan serta memperbarui daftar proyek.
- Pembuatan halaman detail proyek.
- Pengelolaan state autentikasi menggunakan Provider dan ChangeNotifier.
- Implementasi LoginScreen dan route guard untuk melindungi halaman tambah proyek.
- Integrasi formulir proyek dengan endpoint POST Django REST Framework.
- Konfigurasi GitHub Actions untuk Continuous Integration dan Continuous Delivery berupa build APK.

### Cara Menjalankan Aplikasi

Jalankan server Django terlebih dahulu:

```bash
python manage.py runserver
```

Kemudian jalankan aplikasi Flutter menggunakan Chrome:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

### Hasil Pengujian Lokal

| Pengujian | Hasil |
|---|---|
| `dart format .` | 16 files formatted, 0 changed |
| `flutter analyze` | No issues found |
| `flutter test` | All 4 tests passed |

### Penggunaan AI

Dalam pengerjaan Tutorial 10, saya menggunakan ChatGPT untuk membantu memahami konsep integrasi backend, autentikasi berbasis token, JSON serialization, HTTP networking, state management, serta CI/CD. ChatGPT juga membantu memberikan contoh implementasi kode dan solusi terhadap beberapa error selama proses pengerjaan. Saya melakukan penerapan dan pengujian kode pada lingkungan pengembangan lokal.