import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';

class TemperatureMonitoringPage extends StatefulWidget {
  const TemperatureMonitoringPage({super.key});

  @override
  State<TemperatureMonitoringPage> createState() => _TemperatureMonitoringPageState();
}

class _TemperatureMonitoringPageState extends State<TemperatureMonitoringPage> {
  String selectedCrane = 'All Cranes';
  String selectedComponent = 'All Components';
  String selectedDateRange = 'Today';
  int _currentChartIndex = 0;
  bool _showFilters = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> cranes = [
    'All Cranes',
    'Gantry Crane #1 (CRN-001)',
    'Overhead Crane #2 (CRN-002)',
    'Jib Crane #3 (CRN-003)',
    'Bridge Crane #4 (CRN-004)',
    'Gantry Crane #5 (CRN-005)'
  ];

  final List<String> components = [
    'All Components',
    'Hoist Motor',
    'CT Motor',
    'LT Motor',
    'Gearbox',
    'Pulley',
    'Wheels',
    'Hook'
  ];

  final List<String> dateRanges = [
    'Today',
    'This Week',
    'This Month',
    'Custom Range'
  ];

  // Mock chart data
  final List<String> times = [
    '08:00', '09:00', '10:00', '11:00', '12:00', 
    '13:00', '14:00', '15:00', '16:00', '17:00'
  ];

  final List<Map<String, dynamic>> chartData = [
    {
      'label': 'Hoist Motor',
      'color': Colors.red,
      'values': [65.0, 68.0, 72.0, 75.0, 78.0, 82.0, 85.0, 87.0, 84.0, 80.0],
      'icon': Icons.electric_bolt
    },
    {
      'label': 'CT Motor',
      'color': Colors.blue,
      'values': [50.0, 54.0, 58.0, 62.0, 66.0, 70.0, 74.0, 77.0, 74.0, 70.0],
      'icon': Icons.moving
    },
    {
      'label': 'LT Motor',
      'color': Colors.green,
      'values': [60.0, 63.0, 67.0, 70.0, 73.0, 77.0, 80.0, 82.0, 79.0, 76.0],
      'icon': Icons.settings
    },
    {
      'label': 'Gearbox',
      'color': Colors.purple,
      'values': [62.0, 65.0, 69.0, 72.0, 76.0, 79.0, 82.0, 84.0, 81.0, 78.0],
      'icon': Icons.engineering
    },
  ];

  // Mock table data
  final List<Map<String, dynamic>> tableData = [
    {
      'timestamp': '2025-10-14 08:23:45',
      'craneId': 'CRN-001',
      'component': 'Hoist Motor',
      'temperature': 65,
      'warning': 80,
      'critical': 90
    },
    {
      'timestamp': '2025-10-14 10:05:27',
      'craneId': 'CRN-002',
      'component': 'Hoist Motor',
      'temperature': 82,
      'warning': 80,
      'critical': 90
    },
    {
      'timestamp': '2025-10-14 11:15:06',
      'craneId': 'CRN-003',
      'component': 'Hoist Motor',
      'temperature': 92,
      'warning': 80,
      'critical': 90
    },
    {
      'timestamp': '2025-10-14 15:22:47',
      'craneId': 'CRN-004',
      'component': 'Gearbox',
      'temperature': 89,
      'warning': 85,
      'critical': 95
    },
    {
      'timestamp': '2025-10-14 16:45:12',
      'craneId': 'CRN-001',
      'component': 'CT Motor',
      'temperature': 58,
      'warning': 75,
      'critical': 85
    },
    {
      'timestamp': '2025-10-14 17:30:33',
      'craneId': 'CRN-005',
      'component': 'LT Motor',
      'temperature': 72,
      'warning': 80,
      'critical': 90
    },
  ];

  void resetFilters() {
    setState(() {
      selectedCrane = 'All Cranes';
      selectedComponent = 'All Components';
      selectedDateRange = 'Today';
    });
  }

  String getStatus(int temp, int warn, int critical) {
    if (temp >= critical) return 'CRITICAL';
    if (temp >= warn) return 'WARNING';
    return 'NORMAL';
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'CRITICAL':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Temperature',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Color(0xFF1E3A5F)),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Color(0xFF1E3A5F)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Quick Stats Header
            _buildQuickStats(),
            
            // Filters (Collapsible)
            if (_showFilters) _buildFilterSection(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20), // Added bottom padding
                child: Column(
                  children: [
                    // KPI Cards
                    _buildKPICards(),
                    
                    // Charts Section
                    _buildChartsSection(),
                    
                    // Data Table
                    _buildDataTable(),
                    
                    // Extra bottom padding for safety
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          _buildQuickStatItem('4', 'Alerts', Colors.red),
          const SizedBox(width: 12),
          _buildQuickStatItem('78°C', 'Max Temp', Colors.orange),
          const SizedBox(width: 12),
          _buildQuickStatItem('92%', 'Normal', Colors.green),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICards() {
    final List<Map<String, dynamic>> kpis = [
      {
        'value': '78°C',
        'label': 'Current Temp',
        'subtitle': 'Hoist Motor CRN-001',
        'color': Colors.orange,
        'icon': Icons.thermostat_auto
      },
      {
        'value': '4',
        'label': 'Active Alerts',
        'subtitle': 'Require attention',
        'color': Colors.red,
        'icon': Icons.warning_amber_rounded
      },
      {
        'value': '92%',
        'label': 'Within Range',
        'subtitle': 'Components normal',
        'color': Colors.green,
        'icon': Icons.check_circle_outline_rounded
      },
      {
        'value': '45°C',
        'label': 'Avg Temp',
        'subtitle': 'All components',
        'color': Colors.blue,
        'icon': Icons.analytics_outlined
      },
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4, // Reduced aspect ratio
        ),
        itemCount: kpis.length,
        itemBuilder: (context, index) {
          final kpi = kpis[index];
          final color = kpi['color'] as Color;
          final value = kpi['value'] as String;
          final label = kpi['label'] as String;
          final subtitle = kpi['subtitle'] as String;
          final icon = kpi['icon'] as IconData;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(icon, color: color, size: 14),
                      ),
                      const Spacer(),
                      if (index == 1) // Alert badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
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
        children: [
          Row(
            children: [
              const Text(
                "Filters",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 16),
                onPressed: () {
                  setState(() {
                    _showFilters = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFilterField('Crane', selectedCrane, cranes, Icons.construction_rounded),
          const SizedBox(height: 10),
          _buildFilterField('Component', selectedComponent, components, Icons.settings_rounded),
          const SizedBox(height: 10),
          _buildFilterField('Date Range', selectedDateRange, dateRanges, Icons.calendar_today_rounded),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: resetFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text("Reset", style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("Apply", style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, String value, List<String> options, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                switch (label) {
                  case 'Crane':
                    selectedCrane = newValue!;
                    break;
                  case 'Component':
                    selectedComponent = newValue!;
                    break;
                  case 'Date Range':
                    selectedDateRange = newValue!;
                    break;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  void _applyFilters() {
    setState(() {
      _showFilters = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied: $selectedCrane, $selectedComponent, $selectedDateRange'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
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
              const Text(
                "Temperature Trends",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                onPressed: _currentChartIndex > 0 ? () {
                  setState(() {
                    _currentChartIndex--;
                  });
                } : null,
              ),
              Text(
                '${_currentChartIndex + 1}/${chartData.length}',
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
                onPressed: _currentChartIndex < chartData.length - 1 ? () {
                  setState(() {
                    _currentChartIndex++;
                  });
                } : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCurrentChart(),
          const SizedBox(height: 12),
          _buildChartIndicators(),
        ],
      ),
    );
  }

  Widget _buildCurrentChart() {
    final data = chartData[_currentChartIndex];
    final color = data['color'] as Color;
    final label = data['label'] as String;
    final values = data['values'] as List<double>;
    final icon = data['icon'] as IconData;

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Max: ${values.reduce((a, b) => a > b ? a : b).toInt()}°C',
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180, // Reduced height
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Text(
                          '${value.toInt()}°C',
                          style: const TextStyle(fontSize: 9, color: Colors.black54),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 18,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return index >= 0 && index < times.length 
                          ? Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                times[index],
                                style: const TextStyle(fontSize: 9, color: Colors.black54),
                              ),
                            )
                          : const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              minX: 0,
              maxX: (times.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
                  isCurved: true,
                  color: color,
                  barWidth: 2.5,
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.1),
                  ),
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartIndicators() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(chartData.length, (index) {
        final data = chartData[index];
        final isSelected = index == _currentChartIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentChartIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? data['color'] : data['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? data['color'] : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  data['icon'],
                  size: 10,
                  color: isSelected ? Colors.white : data['color'],
                ),
                const SizedBox(width: 3),
                Text(
                  data['label'],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : data['color'],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
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
            "Recent Readings",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 6),
          const Text(
            "Latest temperature measurements",
            style: TextStyle(color: Colors.black54, fontSize: 11),
          ),
          const SizedBox(height: 12),
          ...tableData.map((row) => _buildDataRow(row)),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Showing ${tableData.length} records",
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> row) {
    final status = getStatus(row['temperature'] as int, row['warning'] as int, row['critical'] as int);
    final statusColor = getStatusColor(status);
    final time = row['timestamp'].toString().split(' ')[1].substring(0, 5);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Time and Crane
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 1),
                Text(
                  row['craneId'].toString(),
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
          ),
          
          // Component
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row['component'].toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 1),
                Text(
                  'Warn: ${row['warning']}°C',
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
          ),
          
          // Temperature and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${row['temperature']}°C',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}