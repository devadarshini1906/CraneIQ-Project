import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class Sidebar extends StatelessWidget {
  final Function(String)? onItemSelected;

  const Sidebar({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E3A5F),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF152642),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.apartment, color: Color(0xFF1E3A5F)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CraneIQ Pro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Industrial Monitoring',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildSectionHeader('MONITORING'),
                  _drawerItem(Icons.dashboard, 'Dashboard', context, isActive: true),
                  _drawerItem(Icons.history, 'Operations Log', context),
                  _drawerItem(Icons.monitor_weight, 'Load Monitoring', context),
                  _drawerItem(Icons.vibration, 'Vibration', context),
                  _drawerItem(Icons.flash_on, 'Energy', context),
                  _drawerItem(Icons.thermostat, 'Temperature', context),
                  _drawerItem(Icons.warning_amber, 'Brake Monitoring', context),
                  _drawerItem(Icons.map, 'Zone Control', context),
                  
                  _buildSectionHeader('MANAGEMENT'),
                  _drawerItem(Icons.rule, 'Rule Engine', context),
                  _drawerItem(Icons.storage, 'Data Hub', context),
                  _drawerItem(Icons.error, 'Error Log', context),
                  _drawerItem(Icons.description, 'Reports', context),
                  _drawerItem(Icons.notifications, 'Alerts', context),
                  
                  _buildSectionHeader('SETTINGS'),
                  _drawerItem(Icons.settings, 'Settings', context),
                  _drawerItem(Icons.build, 'Machine Management', context),
                  _drawerItem(Icons.router, 'IOT-Gateway Management', context),
                  _drawerItem(Icons.devices, 'Device Management', context),
                  _drawerItem(Icons.help_outline, 'Help', context),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF152642),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hilton User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Pro Plan',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, BuildContext context, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2D4A7C) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        minLeadingWidth: 0,
        onTap: () {
          Navigator.pop(context);
          developer.log('Sidebar item tapped: $title');
          if (onItemSelected != null) {
            onItemSelected!(title);
          }
          _navigateToPage(title, context);
        },
      ),
    );
  }

  void _navigateToPage(String title, BuildContext context) {
    switch (title) {
      case 'Dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'Operations Log':
        Navigator.pushNamed(context, '/operations_log');
        break;
      case 'Load Monitoring':
        Navigator.pushNamed(context, '/load');
        break;
      case 'Vibration':
        Navigator.pushNamed(context, '/vibration');
        break;
      case 'Energy':
        Navigator.pushNamed(context, '/energy_monitoring');
        break;
      case 'Temperature':
        Navigator.pushNamed(context, '/temperature');
        break;
      case 'Brake Monitoring':
        Navigator.pushNamed(context, '/brakemonitoring');
        break;
      case 'Zone Control':
        Navigator.pushNamed(context, '/zonecontrol');
        break;
      case 'Rule Engine':
        Navigator.pushNamed(context, '/ruleengine');
        break;
      case 'Data Hub':
        Navigator.pushNamed(context, '/datahub');
        break;
      case 'Error Log':
        Navigator.pushNamed(context, '/errorlog');
        break;
      case 'Reports':
        Navigator.pushNamed(context, '/reports');
        break;
      case 'Alerts':
        Navigator.pushNamed(context, '/alerts');
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'Machine Management':
        Navigator.pushNamed(context, '/machine_management');
        break;
      case 'IOT-Gateway Management':
        Navigator.pushNamed(context, '/gateway_management');
        break;
      case 'Device Management':
        Navigator.pushNamed(context, '/device_management');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tapped $title'),
            duration: const Duration(milliseconds: 800),
          ),
        );
        break;
    }
  }
}