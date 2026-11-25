import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _techStack = TextEditingController();
  final _projectUrl = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _techStack.dispose();
    _projectUrl.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final auth = context.read<AuthState>();
      final token = auth.token;
      if (token == null) return;
      final created = await context.read<ApiClient>().createProject(
        Project(
          title: _title.text.trim(),
          description: _description.text.trim(),
          techStack: _techStack.text.trim(),
          projectUrl: _projectUrl.text.trim(),
          projectImageUrl: _imageUrl.text.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil disimpan'),
          content: Text(created.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        _notify('Sesi berakhir. Silakan masuk kembali lalu tekan Simpan.');
      } else if (error.statusCode == 403) {
        _notify('Hanya pemilik portofolio yang dapat menambah proyek.');
      } else {
        _notify('Proyek gagal disimpan (HTTP ${error.statusCode}).');
      }
    } catch (_) {
      if (mounted) _notify('Tidak dapat menghubungi server Django.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? value, String field, {int? maxLength}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return '$field wajib diisi.';
    if (maxLength != null && text.runes.length > maxLength) {
      return 'Maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateUrl(String? value, {bool optional = false}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return optional ? null : 'Tautan proyek wajib diisi.';
    if (text.length > 200) return 'Maksimal 200 karakter.';
    final uri = Uri.tryParse(text);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        text.contains(RegExp(r'\s'))) {
      return 'Masukkan URL http:// atau https:// yang valid.';
    }
    return null;
  }

  Widget _input(
    TextEditingController controller,
    String label,
    String? Function(String?) validator, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: !_submitting,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Proyek'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _input(
              _title,
              'Judul Proyek',
              (value) => _required(value, 'Judul', maxLength: 255),
            ),
            _input(
              _description,
              'Deskripsi',
              (value) => _required(value, 'Deskripsi'),
              maxLines: 4,
            ),
            _input(
              _techStack,
              'Teknologi',
              (value) => _required(value, 'Teknologi', maxLength: 255),
            ),
            _input(
              _projectUrl,
              'Tautan Proyek',
              _validateUrl,
              keyboardType: TextInputType.url,
            ),
            _input(
              _imageUrl,
              'Tautan Gambar (opsional)',
              (value) => _validateUrl(value, optional: true),
              keyboardType: TextInputType.url,
            ),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? 'Menyimpan…' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
