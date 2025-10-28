import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';

class AlertsDashboardPage extends StatefulWidget {
  const AlertsDashboardPage({super.key});

  @override
  State<AlertsDashboardPage> createState() => _AlertsDashboardPageState();
}

class _AlertsDashboardPageState extends State<AlertsDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTimeRange = 'Today';
  String _selectedCrane = 'All Cranes';
  String _selectedAlertType = 'All Types';
  
  bool _criticalAlerts = true;
  bool _warningAlerts = true;
  bool _infoAlerts = false;
  bool _inAppNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _notifications247 = true;
  bool _businessHoursOnly = false;
  bool _quietHours = false;

  final List<String> _craneOptions = [
    'All Cranes',
    'Gantry Crane #1 (CRN-001)',
    'Overhead Crane #2 (CRN-002)',
    'Jib Crane #3 (CRN-003)',
    'Bridge Crane #4 (CRN-004)',
  ];

  final List<String> _alertTypeOptions = [
    'All Types',
    'Overload',
    'Temperature',
    'Voltage',
    'Maintenance',
    'Operation',
  ];

  final List<Map<String, String>> _recentAlerts = [
    {
      "time": "08:23 AM",
      "type": "Critical", 
      "msg": "Overload detected on CRN-001 (15.8 tons)",
      "color": "red"
    },
    {
      "time": "08:45 AM",
      "type": "Warning", 
      "msg": "High temperature on CRN-002 hoist motor (78°C)",
      "color": "orange"
    },
    {
      "time": "09:12 AM", 
      "type": "Critical", 
      "msg": "Voltage drop on CRN-003 hoist motor (350V)",
      "color": "red"
    },
    {
      "time": "10:05 AM",
      "type": "Info", 
      "msg": "Scheduled maintenance due in 3 days for CRN-001",
      "color": "teal"
    },
  ];

  final List<Map<String, dynamic>> _alertSummary = [
    {
      "count": "12", 
      "title": "Critical Alerts", 
      "subtitle": "Today",
      "color": Colors.red,
      "bgColor": Colors.red.shade50,
      "icon": Icons.error_outline
    },
    {
      "count": "24", 
      "title": "Warning Alerts", 
      "subtitle": "Today",
      "color": Colors.orange,
      "bgColor": Colors.orange.shade50,
      "icon": Icons.warning_amber_outlined
    },
    {
      "count": "8", 
      "title": "Info Alerts", 
      "subtitle": "Today",
      "color": Colors.teal,
      "bgColor": Colors.teal.shade50,
      "icon": Icons.info_outline
    },
    {
      "count": "42", 
      "title": "Resolved Alerts", 
      "subtitle": "Today",
      "color": Colors.green,
      "bgColor": Colors.green.shade50,
      "icon": Icons.check_circle_outline
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFD),
      drawer: Sidebar(onItemSelected: (title) {
        // Navigation handled in Sidebar
      }),
      appBar: AppBar(
        title: const Text(
          "Alerts & Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF1E3A5F)),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/dashboard', 
                (route) => false
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 20),

              // Alert Summary
              _buildAlertSummary(isMobile),
              const SizedBox(height: 20),

              // Quick Filters
              _buildQuickFilters(),
              const SizedBox(height: 20),

              // Chart Section
              _buildChartSection(isMobile),
              const SizedBox(height: 20),

              // Recent Alerts
              _buildRecentAlerts(),
              const SizedBox(height: 20),

              // Filter Section
              _buildFilterSection(isMobile),
              const SizedBox(height: 20),

              // Notification Settings
              _buildNotificationSettings(isMobile),
            ],
          ),
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
              child: const Icon(Icons.notifications_active, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Alerts Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Monitor and manage system alerts in real-time",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAlertSummary(bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _alertSummary.length,
      itemBuilder: (context, index) {
        final alert = _alertSummary[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: alert["bgColor"] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(alert["icon"] as IconData, color: alert["color"] as Color, size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  alert["count"] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: alert["color"] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert["title"] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  alert["subtitle"] as String,
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickFilters() {
    final filters = [
      {"label": "All Alerts", "color": const Color(0xFF1E3A5F)},
      {"label": "Critical", "color": Colors.red},
      {"label": "Warning", "color": Colors.orange},
      {"label": "Info", "color": Colors.blue},
      {"label": "Resolved", "color": Colors.green},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Container(
            margin: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(
                filter["label"] as String,
                style: const TextStyle(fontSize: 12),
              ),
              selected: false,
              onSelected: (_) {},
              backgroundColor: (filter["color"] as Color).withOpacity(0.1),
              selectedColor: filter["color"] as Color,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: filter["color"] as Color,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: (filter["color"] as Color).withOpacity(0.2)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alert Trends (Last 7 Days)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: isMobile ? 160 : 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return value.toInt() < days.length 
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  days[value.toInt()],
                                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              )
                            : const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 20,
                lineBarsData: [
                  _createLineData([5, 8, 12, 6, 9, 3, 7], Colors.red, "Critical"),
                  _createLineData([10, 15, 8, 12, 7, 10, 14], Colors.orange, "Warning"),
                  _createLineData([4, 5, 2, 6, 7, 5, 4], Colors.blue, "Info"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _createLineData(List<double> values, Color color, String label) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
      spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
    );
  }

  Widget _buildRecentAlerts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.timeline, color: Color(0xFF1E3A5F), size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "Recent Alerts",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: _recentAlerts.map((alert) {
              Color color;
              IconData icon;
              switch (alert["color"]) {
                case "red":
                  color = Colors.red;
                  icon = Icons.error;
                  break;
                case "orange":
                  color = Colors.orange;
                  icon = Icons.warning;
                  break;
                case "teal":
                  color = Colors.blue;
                  icon = Icons.info;
                  break;
                default:
                  color = Colors.grey;
                  icon = Icons.notifications;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['msg']!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Today, ${alert['time']}",
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.filter_alt, color: Color(0xFF1E3A5F), size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "Filter Alerts",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _buildFilterDropdown("Time Range", _selectedTimeRange, ['Today', 'Last 7 Days', 'Last 30 Days', 'Custom Range']),
              const SizedBox(height: 8),
              _buildFilterDropdown("Crane Selection", _selectedCrane, _craneOptions),
              const SizedBox(height: 8),
              _buildFilterDropdown("Alert Type", _selectedAlertType, _alertTypeOptions),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _applyFilters,
                  icon: const Icon(Icons.filter_alt, size: 16),
                  label: const Text("Apply Filters"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                switch (label) {
                  case "Time Range":
                    _selectedTimeRange = newValue!;
                    break;
                  case "Crane Selection":
                    _selectedCrane = newValue!;
                    break;
                  case "Alert Type":
                    _selectedAlertType = newValue!;
                    break;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.settings, color: Color(0xFF1E3A5F), size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "Notification Settings",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _buildNotificationSection("Alert Preferences", [
                _buildNotificationToggle("Critical Alerts", "Immediate attention required", _criticalAlerts, Icons.error),
                _buildNotificationToggle("Warning Alerts", "Potential issues that need monitoring", _warningAlerts, Icons.warning),
                _buildNotificationToggle("Info Alerts", "Informational messages", _infoAlerts, Icons.info),
              ]),
              const SizedBox(height: 12),
              _buildNotificationSection("Delivery Methods", [
                _buildNotificationToggle("In-App Notifications", "Receive alerts within the app", _inAppNotifications, Icons.notifications),
                _buildNotificationToggle("Email Notifications", "Alerts sent to your email", _emailNotifications, Icons.email),
                _buildNotificationToggle("SMS Notifications", "Text messages for critical alerts", _smsNotifications, Icons.sms),
              ]),
              const SizedBox(height: 12),
              _buildNotificationSection("Schedule", [
                _buildNotificationToggle("24/7 Notifications", "Get alerts at any time", _notifications247, Icons.public),
                _buildNotificationToggle("Business Hours Only", "8:00 AM - 6:00 PM, Mon-Fri", _businessHoursOnly, Icons.work),
                _buildNotificationToggle("Quiet Hours", "No notifications 10:00 PM - 6:00 AM", _quietHours, Icons.nightlight_round),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save, size: 16),
              label: const Text("Save Settings"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(String title, List<Widget> toggles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F)),
        ),
        const SizedBox(height: 8),
        ...toggles,
      ],
    );
  }

  Widget _buildNotificationToggle(String title, String subtitle, bool value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A5F), size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                if (title == "Critical Alerts") {
                  _criticalAlerts = newValue;
                } else if (title == "Warning Alerts") _warningAlerts = newValue;
                else if (title == "Info Alerts") _infoAlerts = newValue;
                else if (title == "In-App Notifications") _inAppNotifications = newValue;
                else if (title == "Email Notifications") _emailNotifications = newValue;
                else if (title == "SMS Notifications") _smsNotifications = newValue;
                else if (title == "24/7 Notifications") _notifications247 = newValue;
                else if (title == "Business Hours Only") _businessHoursOnly = newValue;
                else if (title == "Quiet Hours") _quietHours = newValue;
              });
            },
            activeColor: const Color(0xFF1E3A5F),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied: $_selectedTimeRange, $_selectedCrane, $_selectedAlertType'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedTimeRange = 'Today';
      _selectedCrane = 'All Cranes';
      _selectedAlertType = 'All Types';
    });
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}