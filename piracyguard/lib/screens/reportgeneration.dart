import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ReportGenerationPage extends StatefulWidget {
  const ReportGenerationPage({Key? key}) : super(key: key);

  @override
  State<ReportGenerationPage> createState() => _ReportGenerationPageState();
}

class _ReportGenerationPageState extends State<ReportGenerationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _entityType;
  String? _expectedUsers;
  PlatformFile? _selectedFile;

  final _entityNameController = TextEditingController();
  final _contactDetailsController = TextEditingController();
  final _softwareController = TextEditingController();
  final _otherDetailsController = TextEditingController();
  final _verifierController = TextEditingController();
  final _emailController = TextEditingController();

  final List<String> _entityOptions = [
    'An organisation using unlicensed software',
    'A distributor of unlicensed software',
    'An individual using or distributing unlicensed software',
  ];

  final List<String> _userOptions = [
    '0-10',
    '11-20',
    '21-30',
    '31-40',
    '41-50',
    '51-60',
    '61-70',
    '71-80',
    '81-90',
    '91-100',
  ];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  void dispose() {
    _entityNameController.dispose();
    _contactDetailsController.dispose();
    _softwareController.dispose();
    _otherDetailsController.dispose();
    _verifierController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report filed successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Confidential Software Piracy Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'File a Confidential Software Piracy Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose an entity you would like to report',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _entityType,
                items: _entityOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _entityType = val),
                validator: (val) =>
                    val == null ? 'Please select an entity type' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _entityNameController,
                decoration: const InputDecoration(
                  labelText: 'Name of entity',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter entity name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Other contact details',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _expectedUsers,
                items: _userOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _expectedUsers = val),
                validator: (val) =>
                    val == null ? 'Please select expected illegal users' : null,
                decoration: const InputDecoration(
                  labelText: 'Expected illegal users',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _softwareController,
                decoration: const InputDecoration(
                  labelText: 'Software being pirated',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter software name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Any other important details',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text(
                'Include any related files',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Choose File'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedFile?.name ?? 'No file selected',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _verifierController,
                decoration: const InputDecoration(
                  labelText: 'Is there someone who can help verify this report?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Your Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Filing this software piracy report is completely confidential. In the event of a successful lead.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Stay updated - share your contact details',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(val)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('File Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}