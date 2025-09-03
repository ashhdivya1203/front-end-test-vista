// lib/screens/create_company_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});
  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _reg = TextEditingController();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Company')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: 'Company Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.miscellaneous_services),
              filled: true,
              fillColor: Colors.grey[50]
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _reg,
              decoration: InputDecoration(labelText: 'Registration Number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.grey[50],
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            _submitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => _submitting = true);
                      final ok = await context.read<AppState>().addCompany(_name.text.trim(), _reg.text.trim());
                      setState(() => _submitting = false);
                      if (ok && mounted) Navigator.pop(context);
                      if (!ok && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(app.error ?? 'Error')));
                    },
                    child: const Text('Create'),
                  )
          ]),
        ),
      ),
    );
  }
}
