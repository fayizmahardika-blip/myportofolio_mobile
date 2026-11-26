import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

Future<bool> openEducationForm(BuildContext context) async {
  if (!await ensureLoggedIn(context) || !context.mounted) return false;
  final saved = await Navigator.of(context)
      .push<bool>(MaterialPageRoute(builder: (_) => const EducationFormPage()));
  return saved ?? false;
}

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institution = TextEditingController();
  final _fieldOfStudy = TextEditingController();
  final _startYear = TextEditingController();
  final _endYear = TextEditingController();
  final _description = TextEditingController();
  String _level = 'undergraduate';
  bool _saving = false;

  @override
  void dispose() {
    _institution.dispose();
    _fieldOfStudy.dispose();
    _startYear.dispose();
    _endYear.dispose();
    _description.dispose();
    super.dispose();
  }

  void _showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveEducation() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final auth = context.read<AuthState>();
      final token = auth.token;
      if (token == null) return;
      final education = Education(
        institution: _institution.text.trim(),
        level: _level,
        fieldOfStudy: _fieldOfStudy.text.trim(),
        startYear: int.parse(_startYear.text.trim()),
        endYear: int.tryParse(_endYear.text.trim()),
        description: _description.text.trim(),
      );
      Education saved;
      try {
        saved = await context.read<ApiClient>().createEducation(
          education,
          token: token,
        );
      } on ApiException catch (error) {
        if (error.statusCode != 401) rethrow;
        auth.clearExpiredToken(token);
        if (!mounted) return;
        _showError('Sesi berakhir. Login kembali, lalu tekan Simpan.');
        await ensureLoggedIn(context);
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
        return;
      }
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Edukasi tersimpan'),
          content: Text('${saved.institution} (${saved.period})'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 403) {
        _showError('Hanya pemilik portofolio yang dapat menambah edukasi.');
      } else {
        _showError('Edukasi gagal disimpan (HTTP ${error.statusCode}).');
      }
    } catch (_) {
      if (mounted) {
        _showError('Koneksi ke Django gagal. Cek daftar sebelum mencoba lagi.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _validateYear(String? value, {bool required = true}) {
    final text = (value ?? '').trim();
    if (text.isEmpty && !required) return null;
    final year = int.tryParse(text);
    if (year == null || year < 1900 || year > 2100) {
      return 'Masukkan tahun antara 1900 dan 2100.';
    }
    return null;
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int? maxLength,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      enabled: !_saving,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(
                _institution,
                'Nama Institusi',
                maxLength: 255,
                validator: (value) {
                  final text = (value ?? '').trim();
                  if (text.isEmpty) return 'Nama institusi wajib diisi.';
                  if (text.runes.length > 255) return 'Maksimal 255 karakter.';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: const InputDecoration(
                  labelText: 'Jenjang Pendidikan',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final option in educationLevels.entries)
                    DropdownMenuItem(
                      value: option.key,
                      child: Text(option.value),
                    ),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _level = value);
                      },
              ),
              const SizedBox(height: 16),
              _field(
                _fieldOfStudy,
                'Program Studi (opsional)',
                maxLength: 255,
                validator: (value) => (value ?? '').trim().runes.length > 255
                    ? 'Maksimal 255 karakter.'
                    : null,
              ),
              _field(
                _startYear,
                'Tahun Mulai',
                maxLength: 4,
                keyboardType: TextInputType.number,
                validator: _validateYear,
              ),
              _field(
                _endYear,
                'Tahun Selesai (opsional)',
                maxLength: 4,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final error = _validateYear(value, required: false);
                  if (error != null) return error;
                  final end = int.tryParse((value ?? '').trim());
                  final start = int.tryParse(_startYear.text.trim());
                  if (end != null && start != null && end < start) {
                    return 'Tahun selesai tidak boleh sebelum tahun mulai.';
                  }
                  return null;
                },
              ),
              _field(_description, 'Deskripsi (opsional)', maxLines: 3),
              FilledButton(
                onPressed: _saving ? null : _saveEducation,
                child: Text(_saving ? 'Menyimpan…' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
