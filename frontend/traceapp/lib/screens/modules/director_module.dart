import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';

class DirectorModule extends StatefulWidget {
  const DirectorModule({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<DirectorModule> createState() => _DirectorModuleState();
}

class _DirectorModuleState extends State<DirectorModule> {
  late Future<ReportSummary> _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.apiClient.fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reportes ejecutivos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Genera PDF institucional con KPIs, evidencias y seguimiento socioemocional.'),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<ReportSummary>(
              future: _summary,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('No se pudo cargar el resumen: ${snapshot.error}'));
                }
                if (!snapshot.hasData) return const Center(child: Text('Sin datos'));
                final summary = snapshot.data!;
                return ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.groups_outlined),
                      title: const Text('Alumnos inscritos'),
                      trailing: Text('${summary.alumnos}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text('Socioemocionales'),
                      subtitle: const Text('Realizadas vs Pendientes'),
                      trailing: Text('${summary.socioRealizadas} / ${summary.socioPendientes}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.route_outlined),
                      title: const Text('Trayectoria'),
                      subtitle: const Text('Realizadas vs Pendientes'),
                      trailing: Text('${summary.trayectoriaRealizadas} / ${summary.trayectoriaPendientes}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.support_agent_outlined),
                      title: const Text('Derivaciones registradas'),
                      trailing: Text('${summary.derivaciones}'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exporta el PDF usando el backend de reportes.')),
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('Generar reporte PDF'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
