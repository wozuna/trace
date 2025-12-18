import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';

class AdminModule extends StatefulWidget {
  const AdminModule({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<AdminModule> createState() => _AdminModuleState();
}

class _AdminModuleState extends State<AdminModule> {
  late Future<List<Student>> _students;
  late Future<List<GroupSummary>> _groups;

  @override
  void initState() {
    super.initState();
    _students = widget.apiClient.fetchStudents();
    _groups = widget.apiClient.fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text('Control escolar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Alumnos, tutores y estructura académica centralizados.'),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alumnos', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Student>>(
                    future: _students,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar alumnos: ${snapshot.error}');
                      }
                      final data = snapshot.data ?? [];
                      return Column(
                        children: data
                            .map(
                              (student) => ListTile(
                                dense: true,
                                leading: const Icon(Icons.person_outline),
                                title: Text(student.name),
                                subtitle: Text('Semestre ${student.grade} • Grupo ${student.group}'),
                                trailing: Text(student.tutor),
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
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Grupos y academias', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<GroupSummary>>(
                    future: _groups,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar grupos: ${snapshot.error}');
                      }
                      final data = snapshot.data ?? [];
                      return Column(
                        children: data
                            .map(
                              (group) => ListTile(
                                leading: const Icon(Icons.class_outlined),
                                title: Text('Semestre ${group.grade} • Grupo ${group.code}'),
                                subtitle: Text(group.academy),
                                trailing: Text(group.teacher),
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
