import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../widgets/summary_cards.dart';
import 'modules/admin_module.dart';
import 'modules/docente_module.dart';
import 'modules/orientador_module.dart';
import 'modules/director_module.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.session, required this.apiClient, required this.onLogout});

  final UserSession session;
  final ApiClient apiClient;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;

  List<Widget> _buildTabs() {
    final role = widget.session.role;
    if (role == UserRole.administrador) {
      return [
        SummaryCards(apiClient: widget.apiClient),
        AdminModule(apiClient: widget.apiClient),
      ];
    }
    if (role == UserRole.docente) {
      return [
        SummaryCards(apiClient: widget.apiClient),
        DocenteModule(apiClient: widget.apiClient),
        OrientadorModule(apiClient: widget.apiClient, docenteMode: true),
      ];
    }
    if (role == UserRole.director) {
      return [
        SummaryCards(apiClient: widget.apiClient),
        DirectorModule(apiClient: widget.apiClient),
      ];
    }
    return [
      SummaryCards(apiClient: widget.apiClient),
      OrientadorModule(apiClient: widget.apiClient, docenteMode: false),
    ];
  }

  List<BottomNavigationBarItem> _buildNavigation() {
    final role = widget.session.role;
    if (role == UserRole.administrador) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Estructura'),
      ];
    }
    if (role == UserRole.docente) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Actividades'),
        BottomNavigationBarItem(icon: Icon(Icons.support_agent_outlined), label: 'Derivaciones'),
      ];
    }
    if (role == UserRole.director) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf_outlined), label: 'Reportes'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.event_available_outlined), label: 'Citas'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _buildTabs();
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACE'),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        items: _buildNavigation(),
        onTap: (index) => setState(() => _tabIndex = index),
      ),
    );
  }
}
