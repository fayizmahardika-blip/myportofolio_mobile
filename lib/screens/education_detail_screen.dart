import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class EducationDetailScreen extends StatefulWidget {
  const EducationDetailScreen({super.key, required this.entry});

  final Education entry;

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  late Future<Education> _detail;

  @override
  void initState() {
    super.initState();
    _detail = _load();
  }

  Future<Education> _load() {
    final id = widget.entry.id;
    if (id == null) return Future.value(widget.entry);
    return context.read<ApiClient>().getEducationDetail(id);
  }

  Widget _details(Education entry) {
    final fields = {
      'ID': entry.id?.toString(),
      'Institusi': entry.institution,
      'Jenjang': entry.levelLabel,
      'Program studi': entry.fieldOfStudy,
      'Tahun mulai': entry.startYear.toString(),
      'Tahun selesai': entry.endYear?.toString() ?? 'Masih berlangsung',
      'Nilai / IPK': entry.grade,
      'Kegiatan': entry.activities,
      'Pencapaian': entry.achievements,
      'Deskripsi': entry.description,
      'URL gambar': entry.schoolImage,
      'Situs institusi': entry.schoolUrl,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final field in fields.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.key, style: Theme.of(context).textTheme.titleSmall),
                SelectableText(
                  field.value == null || field.value!.isEmpty
                      ? '—'
                      : field.value!,
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Edukasi')),
      body: FutureBuilder<Education>(
        future: _detail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Detail edukasi gagal dimuat.'),
                  OutlinedButton(
                    onPressed: () {
                      final request = _load();
                      setState(() {
                        _detail = request;
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return _details(snapshot.requireData);
        },
      ),
    );
  }
}
