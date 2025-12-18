import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';

class OrientadorModule extends StatefulWidget {
  const OrientadorModule({super.key, required this.apiClient, required this.docenteMode});

  final ApiClient apiClient;
  final bool docenteMode;

  @override
  State<OrientadorModule> createState() => _OrientadorModuleState();
}

class _OrientadorModuleState extends State<OrientadorModule> {
  late Future<List<Referral>> _referrals;
  final _formKey = GlobalKey<FormState>();
  final _studentController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _urgency = 'media';
  String _motive = 'situación psicológica';

  @override
  void initState() {
    super.initState();
    _referrals = widget.apiClient.fetchReferrals();
  }

  Future<void> _createReferral() async {
    if (!widget.docenteMode) return;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    try {
      await widget.apiClient.createReferral({
        'studentId': _studentController.text,
        'motive': _motive,
        'urgency': _urgency,
        'suggestedDate': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'description': _descriptionController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Derivación enviada')),
      );
      setState(() => _referrals = widget.apiClient.fetchReferrals());
      _formKey.currentState?.reset();
      _studentController.clear();
      _descriptionController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar la derivación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(widget.docenteMode ? 'Derivación a orientación' : 'Agenda de orientación',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (widget.docenteMode)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _studentController,
                        decoration: const InputDecoration(labelText: 'ID del alumno'),
                        validator: (value) => (value ?? '').isEmpty ? 'Obligatorio' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Descripción del caso'),
                        validator: (value) => (value ?? '').isEmpty ? 'Obligatorio' : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _motive,
                        decoration: const InputDecoration(labelText: 'Motivo'),
                        items: const [
                          DropdownMenuItem(value: 'situación psicológica', child: Text('Situación psicológica')),
                          DropdownMenuItem(value: 'faltas', child: Text('Faltas')),
                          DropdownMenuItem(value: 'tareas no entregadas', child: Text('Tareas no entregadas')),
                          DropdownMenuItem(value: 'enfermedad', child: Text('Enfermedad')),
                        ],
                        onChanged: (value) => setState(() => _motive = value ?? _motive),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _urgency,
                        decoration: const InputDecoration(labelText: 'Urgencia'),
                        items: const [
                          DropdownMenuItem(value: 'alta', child: Text('Alta')),
                          DropdownMenuItem(value: 'media', child: Text('Media')),
                          DropdownMenuItem(value: 'baja', child: Text('Baja')),
                        ],
                        onChanged: (value) => setState(() => _urgency = value ?? _urgency),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: _createReferral,
                          icon: const Icon(Icons.send_outlined),
                          label: const Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
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
                  const Text('Citas y casos', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Referral>>(
                    future: _referrals,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar derivaciones: ${snapshot.error}');
                      }
                      final data = snapshot.data ?? [];
                      return Column(
                        children: data
                            .map(
                              (referral) => ListTile(
                                leading: const Icon(Icons.support_agent_outlined),
                                title: Text('Caso ${referral.studentId}'),
                                subtitle: Text('${referral.motive} • ${referral.suggestedDate}'),
                                trailing: Chip(label: Text('${referral.status} | ${referral.urgency}')),
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
