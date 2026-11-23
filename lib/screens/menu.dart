import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Data contoh sesuai Tutorial 8
  final String npm = "2506617374";
  final String nama = "Fayiz Mahardika Ghulam Afandi";
  final String kelas = "PBP F";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.green),
    ItemHomepage("Logout", Icons.logout, Colors.red),
    ItemHomepage("Tambah Edukasi", Icons.school, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kartu identitas pemilik
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: npm),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Name', content: nama),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Class', content: kelas),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Pesan sambutan
              const Text(
                'Selamat datang di MyPortfolio Mobile!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 16),

              // Grid tombol menu
              GridView.count(
                crossAxisCount: 3,
                mainAxisExtent: 160,
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: items.map((item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model data tombol menu
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

// Widget kartu informasi
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
