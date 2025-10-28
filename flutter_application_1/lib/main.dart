import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'pages/dashboard_page.dart';
import 'theme/app_theme.dart';
import 'pages/help.dart';
import 'pages/ruleengine.dart';
import 'pages/errorlog.dart';
import 'pages/vibrationmonitoring.dart';
import 'pages/load.dart';
import 'pages/datahub.dart';
import 'pages/reports.dart';
import 'pages/alerts.dart';
import 'pages/settings.dart';
import 'pages/machine_management.dart';
import 'pages/gateway_management.dart';
import 'pages/device_management.dart';
import 'pages/operationslog.dart';
import 'pages/cranemonitoring.dart';
import 'pages/brakemonitoring.dart';
import 'pages/temperaturemonitor.dart';
import 'pages/energymonitoring.dart';
import 'auth_screen_manager.dart';
import 'widgets/sidebar.dart'; // Keep your sidebar import
import 'professional_bot.dart'; // ADDED: Import professional bot

void main() {
  runApp(const CraneIQApp());
}

class CraneIQApp extends StatelessWidget {
  const CraneIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      developer.log('Error Caught: ${errorDetails.exception}',
          error: errorDetails.exception, stackTrace: errorDetails.stack);
      return Container(
        color: Colors.red,
        child: Center(
          child: Text(
            'An error occurred: ${errorDetails.exception}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    };

    return MaterialApp(
      title: 'CraneIQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      home: const AuthScreenManagerWrapper(), // CHANGED: Use wrapper
      routes: {
        '/dashboard': (context) => const DashboardWrapper(), // CHANGED: Use wrapper
        '/help': (context) => const HelpPage(),
        '/ruleengine': (context) => const RulesEnginePage(),
        '/errorlog': (context) => const ErrorLogPage(),
        '/vibration': (context) => const VibrationMonitoringPage(),
        '/load': (context) => const LoadLiftLogPage(),
        '/datahub': (context) => const DataHubPage(),
        '/reports': (context) => ReportsPage(),
        '/alerts': (context) => const AlertsDashboardPage(),
        '/settings': (context) => const SettingsPage(),
        '/machine_management': (context) => const MachineManagementPage(),
        '/gateway_management': (context) => const GatewayManagementPage(),
        '/device_management': (context) => const DeviceManagementPage(),
        '/operations_log': (context) => const OperationsLogPage(),
        '/zonecontrol': (context) => const CraneMonitoringScreen(),
        '/brakemonitoring': (context) => const BrakeMonitoringPage(),
        '/temperature': (context) => const TemperatureMonitoringPage(),
        '/energy_monitoring': (context) => const EnergyMonitoringDashboard(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == null) return null;
        developer.log('Navigating to undefined route: ${settings.name}',
            error: 'Route not found');
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
              ],
            ),
            drawer: const Sidebar(onItemSelected: null), // Keep your sidebar
            body: const Center(child: Text('Page Not Found')),
          ),
        );
      },
    );
  }
}

// ADDED: Wrapper widget to include professional bot on auth screen
class AuthScreenManagerWrapper extends StatelessWidget {
  const AuthScreenManagerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthScreenManager(),
          const ProfessionalBot(), // ADDED: AI Bot
        ],
      ),
    );
  }
}

// ADDED: Wrapper for Dashboard to include professional bot
class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DashboardPage(),
          const ProfessionalBot(), // ADDED: AI Bot
        ],
      ),
    );
  }
}