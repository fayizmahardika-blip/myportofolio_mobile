import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

// Widget tombol menu interaktif
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          switch (item.name) {
            case 'Lihat Proyek':
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProjectListScreen()),
              );
            case 'Tambah Proyek':
              if (!await ensureLoggedIn(context) || !context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProjectFormPage()),
              );
            case 'Tambah Edukasi':
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EducationFormPage()),
              );
            case 'Logout':
              if (!context.read<AuthState>().isLoggedIn) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kamu belum login.')),
                );
                return;
              }
              await signOut(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Icon(item.icon, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
