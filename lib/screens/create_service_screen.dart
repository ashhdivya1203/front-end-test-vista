// lib/screens/create_service_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});
  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _companyId;
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppState>().fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final companies = app.companies;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Service')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            DropdownButtonFormField<int>(
              value: _companyId,
              items: companies.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _companyId = v),
              validator: (v) => v == null ? 'Select a company' : null,
                decoration: InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.business),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: 'Service Name',
              border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.miscellaneous_services),
                  filled: true,
                  fillColor: Colors.grey[50],
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _desc,
              decoration: InputDecoration(labelText: 'Description (optional)',
              border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Price',
              border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.price_change),
                  filled: true,
                  fillColor: Colors.grey[50],
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final d = double.tryParse(v);
                return (d == null || d < 0) ? 'Invalid number' : null;
              },
            ),
            const SizedBox(height: 20),
            _submitting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => _submitting = true);
                      final ok = await context.read<AppState>().addService(
                            _companyId!,
                            _name.text.trim(),
                            _desc.text.trim().isEmpty ? null : _desc.text.trim(),
                            double.parse(_price.text.trim()),
                          );
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
