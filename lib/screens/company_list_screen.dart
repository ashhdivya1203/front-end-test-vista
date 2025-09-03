// lib/screens/company_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/company.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});
  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppState>().fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Companies')),
      backgroundColor: const Color.fromARGB(255, 100, 164, 237),
      body: Builder(builder: (_) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.error != null) return Center(child: Text(state.error!));
        if (state.companies.isEmpty) return const Center(child: Text('No companies yet'));
        return ListView.builder(
          itemCount: state.companies.length,
          itemBuilder: (_, i) {
            final Company c = state.companies[i];
            return Card(
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shadowColor: Colors.black54,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {}, // optional: expand or navigate
                  hoverColor: const Color.fromARGB(164, 133, 141, 150), // hover effect for web
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      c.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('Reg: ${c.registrationNumber}'),
                    children: c.services.isEmpty
                        ? [
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('No services'),
                            ),
                          ]
                        : c.services
                              .map(
                                (s) => ListTile(
                                  title: Text(s.name),
                                  subtitle: Text(s.description ?? '-'),
                                  trailing: Text(
                                    'RM ${s.price.toStringAsFixed(2)}',
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                ),
              );


          },
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'company',
            onPressed: () => Navigator.pushNamed(context, '/create-company'),
            label: const Text('Add Company'),
            icon: const Icon( Icons.business),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'service',
            onPressed: () => Navigator.pushNamed(context, '/create-service'),
            label: const Text('Add Service'),
            icon: const Icon(Icons.miscellaneous_services),
          ),
        ],
      ),
    );
  }
}
