import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';

class DocenteModule extends StatefulWidget {
  const DocenteModule({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<DocenteModule> createState() => _DocenteModuleState();
}

class _DocenteModuleState extends State<DocenteModule> {
  late Future<List<Activity>> _activities;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _objectivesController = TextEditingController();
  String _type = 'socioemocional';
  String _status = 'planeada';

  @override
  void initState() {
    super.initState();
    _activities = widget.apiClient.fetchActivities();
  }

  Future<void> _createActivity() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final payload = {
      'groupId': 'g-1a',
      'type': _type,
      'title': _titleController.text,
      'objectives': _objectivesController.text,
      'scheduledAt': DateTime.now().toIso8601String(),
      'status': _status,
      'evidence': [],
    };
    try {
      await widget.apiClient.createActivity(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad registrada')),
      );
      setState(() => _activities = widget.apiClient.fetchActivities());
      _formKey.currentState?.reset();
      _titleController.clear();
      _objectivesController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Actividades del docente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Registro rápido', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Título de actividad'),
                          validator: (value) => (value ?? '').isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _objectivesController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: 'Objetivos'),
                          validator: (value) => (value ?? '').isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _type,
                                decoration: const InputDecoration(labelText: 'Tipo'),
                                items: const [
                                  DropdownMenuItem(value: 'socioemocional', child: Text('Socioemocional')),
                                  DropdownMenuItem(value: 'trayectoria', child: Text('Trayectoria')),
                                ],
                                onChanged: (value) => setState(() => _type = value ?? _type),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _status,
                                decoration: const InputDecoration(labelText: 'Estado'),
                                items: const [
                                  DropdownMenuItem(value: 'planeada', child: Text('Planeada')),
                                  DropdownMenuItem(value: 'realizada', child: Text('Realizada')),
                                  DropdownMenuItem(value: 'pospuesta', child: Text('Pospuesta')),
                                ],
                                onChanged: (value) => setState(() => _status = value ?? _status),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _createActivity,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actividades programadas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Activity>>(
                    future: _activities,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar actividades: ${snapshot.error}');
                      }
                      final data = snapshot.data ?? [];
                      return Column(
                        children: data
                            .map(
                              (activity) => ListTile(
                                leading: Icon(activity.type == 'socioemocional' ? Icons.favorite_outline : Icons.route_outlined),
                                title: Text(activity.title),
                                subtitle: Text('${activity.type} • ${activity.scheduledAt}'),
                                trailing: Chip(label: Text(activity.status)),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
