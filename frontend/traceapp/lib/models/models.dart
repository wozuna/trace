enum UserRole { administrador, docente, director, orientador }

UserRole parseRole(String value) => UserRole.values.firstWhere((role) => role.name == value);

class UserSession {
  UserSession({
    required this.token,
    required this.name,
    required this.email,
    required this.role,
  });

  final String token;
  final String name;
  final String email;
  final UserRole role;

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        token: json['token'] as String,
        name: json['profile']['name'] as String,
        email: json['profile']['email'] as String,
        role: parseRole(json['profile']['role'] as String),
      );
}

class Student {
  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.group,
    required this.tutor,
  });

  final String id;
  final String name;
  final int grade;
  final String group;
  final String tutor;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] as String,
        name: json['name'] as String,
        grade: json['grade'] as int,
        group: json['group'] as String,
        tutor: (json['tutor'] ?? 'N/A') as String,
      );
}

class GroupSummary {
  GroupSummary({required this.id, required this.grade, required this.code, required this.teacher, required this.academy});

  final String id;
  final int grade;
  final String code;
  final String teacher;
  final String academy;

  factory GroupSummary.fromJson(Map<String, dynamic> json) => GroupSummary(
        id: json['id'] as String,
        grade: json['grade'] as int,
        code: json['code'] as String,
        teacher: json['teacher'] as String,
        academy: json['academy'] as String,
      );
}

class Activity {
  Activity({
    required this.id,
    required this.groupId,
    required this.type,
    required this.title,
    required this.status,
    required this.scheduledAt,
  });

  final String id;
  final String groupId;
  final String type;
  final String title;
  final String status;
  final String scheduledAt;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        status: json['status'] as String,
        scheduledAt: json['scheduledAt'] as String,
      );
}

class Referral {
  Referral({
    required this.id,
    required this.studentId,
    required this.motive,
    required this.urgency,
    required this.status,
    required this.suggestedDate,
  });

  final String id;
  final String studentId;
  final String motive;
  final String urgency;
  final String status;
  final String suggestedDate;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        motive: json['motive'] as String,
        urgency: json['urgency'] as String,
        status: json['status'] as String,
        suggestedDate: json['suggestedDate'] as String,
      );
}

class ReportSummary {
  ReportSummary({
    required this.alumnos,
    required this.socioRealizadas,
    required this.socioPendientes,
    required this.trayectoriaRealizadas,
    required this.trayectoriaPendientes,
    required this.derivaciones,
    required this.generatedAt,
  });

  final int alumnos;
  final int socioRealizadas;
  final int socioPendientes;
  final int trayectoriaRealizadas;
  final int trayectoriaPendientes;
  final int derivaciones;
  final String generatedAt;

  factory ReportSummary.fromJson(Map<String, dynamic> json) => ReportSummary(
        alumnos: json['alumnos'] as int,
        socioRealizadas: json['actividadesSocioemocionales']['realizadas'] as int,
        socioPendientes: json['actividadesSocioemocionales']['pendientes'] as int,
        trayectoriaRealizadas: json['actividadesTrayectoria']['realizadas'] as int,
        trayectoriaPendientes: json['actividadesTrayectoria']['pendientes'] as int,
        derivaciones: json['derivaciones'] as int,
        generatedAt: (json['timestamp'] ?? '') as String,
      );
}
