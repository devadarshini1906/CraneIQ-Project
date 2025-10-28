import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.green.shade600, size: 16),
                const SizedBox(width: 6),
                Text('Pro Plan', style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: Sidebar(onItemSelected: (title) {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),

            // Settings Categories
            _buildSettingsCategories(context),
            const SizedBox(height: 20),

            // Account Settings
            _buildAccountSettings(),
            const SizedBox(height: 20),

            // Notification Settings
            _buildNotificationSettings(),
            const SizedBox(height: 20),

            // System Settings
            _buildSystemSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.settings, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Settings & Configuration",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Manage your application settings and preferences",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSettingsCategories(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.build,
        'title': 'Machine Management',
        'subtitle': 'Configure crane settings and parameters',
        'route': '/machine_management',
        'color': Colors.blue
      },
      {
        'icon': Icons.router,
        'title': 'Gateway Management',
        'subtitle': 'Manage IoT gateways and connections',
        'route': '/gateway_management',
        'color': Colors.green
      },
      {
        'icon': Icons.devices,
        'title': 'Device Management',
        'subtitle': 'Configure sensors and monitoring devices',
        'route': '/device_management',
        'color': Colors.orange
      },
      {
        'icon': Icons.notifications,
        'title': 'Alert Settings',
        'subtitle': 'Configure notification preferences',
        'route': '/alerts',
        'color': Colors.purple
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final icon = category['icon'] as IconData;
        final title = category['title'] as String;
        final subtitle = category['subtitle'] as String;
        final route = category['route'] as String;
        final color = category['color'] as Color;

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            Icons.person,
            'Profile Information',
            'Update your personal details and contact information',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.security,
            'Security & Privacy',
            'Manage password and privacy settings',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.workspace_premium,
            'Subscription Plan',
            'Pro Plan - Manage your subscription',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.language,
            'Language & Region',
            'English (US) - Change language preferences',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notification Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          _buildNotificationToggle('Push Notifications', 'Receive alerts on your device', true),
          _buildNotificationToggle('Email Notifications', 'Get reports and alerts via email', true),
          _buildNotificationToggle('SMS Alerts', 'Critical alerts via text message', false),
          _buildNotificationToggle('Sound Alerts', 'Play sound for important notifications', true),
          _buildNotificationToggle('Vibration Alerts', 'Vibrate for critical alerts', true),
        ],
      ),
    );
  }

  Widget _buildSystemSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "System Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            Icons.cloud_download,
            'Data Sync',
            'Auto-sync every 15 minutes - Connected',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.storage,
            'Data Retention',
            'Keep data for 12 months - 45GB used',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.backup,
            'Backup & Restore',
            'Last backup: Today 02:00 AM',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          _buildSettingItem(
            Icons.bug_report,
            'Debug Mode',
            'Enabled - Logging all system events',
            Icons.arrow_forward_ios,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save, size: 18),
              label: const Text("Save All Settings"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData leadingIcon, String title, String subtitle, IconData trailingIcon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(leadingIcon, color: const Color(0xFF1E3A5F), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      trailing: Icon(trailingIcon, color: Colors.grey, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget _buildNotificationToggle(String title, String subtitle, bool value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.notifications, color: Color(0xFF1E3A5F), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {},
        activeThumbColor: const Color(0xFF1E3A5F),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}