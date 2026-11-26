import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  late Future<List<Education>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = context.read<ApiClient>().getEducation();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getEducation();
    setState(() {
      _entries = request;
    });
    try {
      await request;
    } catch (_) {
      // FutureBuilder menampilkan kondisi gagal beserta tombol Retry.
    }
  }

  Future<void> _addEducation() async {
    if (await openEducationForm(context) && mounted) await _reload();
  }

  Widget _scrollableMessage(Widget child) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(24),
    children: [Center(child: child)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edukasi')),
      drawer: LeftDrawer(onEducationAdded: _reload),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEducation,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Edukasi'),
      ),
      body: FutureBuilder<List<Education>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _scrollableMessage(
              Column(
                children: [
                  const Text('Daftar edukasi gagal dimuat.'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _reload,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final entries = snapshot.data ?? const <Education>[];
          return RefreshIndicator(
            onRefresh: _reload,
            child: entries.isEmpty
                ? _scrollableMessage(const Text('Belum ada data edukasi.'))
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.school_outlined),
                          title: Text(entry.institution),
                          subtitle: Text(
                            '${entry.levelLabel} · ${entry.period}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  EducationDetailScreen(entry: entry),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
