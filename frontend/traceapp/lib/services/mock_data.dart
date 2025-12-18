import '../models/models.dart';

class MockData {
  static ReportSummary summary = ReportSummary(
    alumnos: 2,
    socioRealizadas: 1,
    socioPendientes: 1,
    trayectoriaRealizadas: 0,
    trayectoriaPendientes: 1,
    derivaciones: 1,
    generatedAt: '',
  );

  static List<GroupSummary> groups = [
    GroupSummary(id: 'g-1a', grade: 1, code: 'A', teacher: 'Docente 1', academy: 'Matemáticas'),
    GroupSummary(id: 'g-3b', grade: 3, code: 'B', teacher: 'Docente 2', academy: 'Programación'),
  ];

  static List<Activity> activities = [
    Activity(
      id: 'act-001',
      groupId: 'g-1a',
      type: 'socioemocional',
      title: 'Integración grupal',
      status: 'realizada',
      scheduledAt: '2025-02-01',
    ),
    Activity(
      id: 'act-002',
      groupId: 'g-3b',
      type: 'trayectoria',
      title: 'Proyecto vocacional',
      status: 'planeada',
      scheduledAt: '2025-03-15',
    ),
  ];

  static List<Referral> referrals = [
    Referral(
      id: 'ref-001',
      studentId: 'a-001',
      motive: 'situación psicológica',
      urgency: 'alta',
      status: 'pendiente',
      suggestedDate: '2025-02-05',
    ),
  ];

  static List<Student> students = [
    Student(id: 'a-001', name: 'María López', grade: 1, group: 'A', tutor: 'Ana López'),
    Student(id: 'a-002', name: 'José Ramírez', grade: 3, group: 'B', tutor: 'Carlos Ramírez'),
  ];
}
