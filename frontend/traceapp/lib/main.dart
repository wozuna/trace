import 'package:flutter/material.dart';
import 'models/models.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'services/api_client.dart';
import 'theme.dart';

void main() {
  runApp(const TraceApp());
}

class TraceApp extends StatefulWidget {
  const TraceApp({super.key});

  @override
  State<TraceApp> createState() => _TraceAppState();
}

class _TraceAppState extends State<TraceApp> {
  final ApiClient _apiClient = ApiClient();
  UserSession? _session;

  void _onLogin(UserSession session) {
    setState(() => _session = session);
  }

  void _onLogout() {
    setState(() => _session = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRACE',
      debugShowCheckedModeBanner: false,
      theme: TraceTheme.themeData,
      home: _session == null
          ? LoginScreen(apiClient: _apiClient, onLoggedIn: _onLogin)
          : HomeShell(session: _session!, apiClient: _apiClient, onLogout: _onLogout),
    );
  }
}
