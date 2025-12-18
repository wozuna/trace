import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReportSummary>(
      future: apiClient.fetchSummary(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard ejecutivo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _KpiCard(
                    label: 'Alumnos inscritos',
                    value: summary.alumnos.toString(),
                    color: TraceTheme.primaryGreen,
                    icon: Icons.school_outlined,
                  ),
                  _KpiCard(
                    label: 'Socioemocionales realizadas',
                    value: summary.socioRealizadas.toString(),
                    color: TraceTheme.secondaryGreen,
                    icon: Icons.favorite_outline,
                  ),
                  _KpiCard(
                    label: 'Trayectoria pendientes',
                    value: summary.trayectoriaPendientes.toString(),
                    color: TraceTheme.accentOrange,
                    icon: Icons.route_outlined,
                  ),
                  _KpiCard(
                    label: 'Derivaciones',
                    value: summary.derivaciones.toString(),
                    color: TraceTheme.softOrange,
                    icon: Icons.support_agent_outlined,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value, required this.color, required this.icon});

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 250 : double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
