import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  String _degree = 'S1';
  DateTime? _startDate;
  DateTime? _endDate;

  static const _degrees = ['SMA', 'D3', 'S1', 'S2', 'S3'];

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (!mounted || selected == null) return;

    setState(() {
      if (isStart) {
        _startDate = selected;
        _startController.text = _formatDate(selected);
      } else {
        _endDate = selected;
        _endController.text = _formatDate(selected);
      }
    });

    _formKey.currentState?.validate();
  }

  void _saveEducation() {
    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Data Edukasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institusi: ${_institutionController.text.trim()}'),
              Text('Jurusan: ${_majorController.text.trim()}'),
              Text('Jenjang: $_degree'),
              Text('Tanggal Mulai: ${_formatDate(_startDate!)}'),
              Text(
                'Tanggal Selesai: ${_endDate == null ? "Masih berlangsung" : _formatDate(_endDate!)}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Education Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _institutionController,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'Nama Institusi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama institusi wajib diisi!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _majorController,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Program Studi / Jurusan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jurusan wajib diisi!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _degree,
                decoration: const InputDecoration(
                  labelText: 'Jenjang Pendidikan',
                  border: OutlineInputBorder(),
                ),
                items: _degrees.map((degree) {
                  return DropdownMenuItem(value: degree, child: Text(degree));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _degree = value);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenjang pendidikan!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _startController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Mulai',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  _pickDate(isStart: true);
                },
                validator: (_) {
                  if (_startDate == null) {
                    return 'Tanggal mulai wajib dipilih!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _endController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Selesai (Opsional)',
                  border: const OutlineInputBorder(),
                  suffixIcon: _endDate == null
                      ? const Icon(Icons.calendar_today)
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _endDate = null;
                              _endController.clear();
                            });
                            _formKey.currentState?.validate();
                          },
                        ),
                ),
                onTap: () {
                  _pickDate(isStart: false);
                },
                validator: (_) {
                  if (_startDate != null &&
                      _endDate != null &&
                      _endDate!.isBefore(_startDate!)) {
                    return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveEducation,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
