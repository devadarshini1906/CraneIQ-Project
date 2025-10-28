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
      home: const AuthScreenManager(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
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
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
      },
    );
  }
}