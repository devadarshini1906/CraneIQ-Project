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

  // Mock chart data - using doubles to prevent type errors
  final List<String> times = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];

  final List<Map<String, dynamic>> chartData = [
    {
      'label': 'Hoist Motor Temperature',
      'color': Colors.red,
      'values': [65.0, 68.0, 72.0, 75.0, 78.0, 82.0, 85.0, 87.0, 84.0, 80.0]
    },
    {
      'label': 'CT Motor Temperature',
      'color': Colors.blue,
      'values': [50.0, 54.0, 58.0, 62.0, 66.0, 70.0, 74.0, 77.0, 74.0, 70.0]
    },
    {
      'label': 'LT Motor Temperature',
      'color': Colors.green,
      'values': [60.0, 63.0, 67.0, 70.0, 73.0, 77.0, 80.0, 82.0, 79.0, 76.0]
    },
    {
      'label': 'Gearbox Temperature',
      'color': Colors.purple,
      'values': [62.0, 65.0, 69.0, 72.0, 76.0, 79.0, 82.0, 84.0, 81.0, 78.0]
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
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Temperature Monitoring',
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

            // KPI Cards
            _buildKPICards(),
            const SizedBox(height: 20),

            // Filters
            _buildFilterSection(),
            const SizedBox(height: 20),

            // Charts
            _buildChartsSection(),
            const SizedBox(height: 20),

            // Data Table
            _buildDataTable(),
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
              child: const Icon(Icons.thermostat, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Temperature Monitoring",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Real-time and historical temperature measurements for crane components",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
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
        'icon': Icons.warning
      },
      {
        'value': '92%',
        'label': 'Within Range',
        'subtitle': 'Components normal',
        'color': Colors.green,
        'icon': Icons.check_circle
      },
      {
        'value': '45°C',
        'label': 'Avg Temp',
        'subtitle': 'All components',
        'color': Colors.blue,
        'icon': Icons.analytics
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
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
            "Filters",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildFilterRow('Crane', selectedCrane, cranes),
              const SizedBox(height: 12),
              _buildFilterRow('Component', selectedComponent, components),
              const SizedBox(height: 12),
              _buildFilterRow('Date Range', selectedDateRange, dateRanges),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: resetFilters,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Apply filter logic here
                    _applyFilters();
                  },
                  icon: const Icon(Icons.filter_alt, size: 16),
                  label: const Text("Apply Filters"),
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
        ],
      ),
    );
  }

  void _applyFilters() {
    // Implement your filter logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied: $selectedCrane, $selectedComponent, $selectedDateRange'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFilterRow(String label, String value, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: const TextStyle(fontSize: 14)),
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

  Widget _buildChartsSection() {
    return Column(
      children: chartData.map((data) {
        final color = data['color'] as Color;
        final label = data['label'] as String;
        final values = data['values'] as List<double>;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Max: ${values.reduce((a, b) => a > b ? a : b).toInt()}°C',
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
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
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${value.toInt()}°C',
                                style: const TextStyle(fontSize: 10, color: Colors.black54),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            return index >= 0 && index < times.length 
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      times[index],
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
                        barWidth: 3,
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDataTable() {
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
            "Temperature Records",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Latest temperature readings from all crane components",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              dataRowMinHeight: 40,
              headingRowHeight: 40,
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
              columns: const [
                DataColumn(label: Text("Timestamp", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Crane ID", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Component", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Temp (°C)", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Warning", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Critical", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: tableData.map((row) {
                final status = getStatus(row['temperature'] as int, row['warning'] as int, row['critical'] as int);
                final statusColor = getStatusColor(status);
                
                return DataRow(
                  cells: [
                    DataCell(Text(row['timestamp'].toString().split(' ')[1])),
                    DataCell(Text(row['craneId'].toString())),
                    DataCell(Text(row['component'].toString())),
                    DataCell(
                      Text(
                        '${row['temperature']}°C',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    DataCell(Text('${row['warning']}°C')),
                    DataCell(Text('${row['critical']}°C')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Showing ${tableData.length} records",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}