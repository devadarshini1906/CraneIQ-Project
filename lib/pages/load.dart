import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';

class LoadLiftLogPage extends StatefulWidget {
  const LoadLiftLogPage({super.key});

  @override
  State<LoadLiftLogPage> createState() => _LoadLiftLogPageState();
}

class _LoadLiftLogPageState extends State<LoadLiftLogPage> {
  String selectedCrane = 'All Cranes';
  String selectedStatus = 'All Statuses';
  String selectedDate = 'Today';

  final List<String> cranes = ['All Cranes', 'CRN-001', 'CRN-002', 'CRN-003', 'CRN-004', 'CRN-005'];
  final List<String> statuses = ['All Statuses', 'Normal', 'Warning', 'Critical'];
  final List<String> dates = ['Today', 'This Week', 'This Month'];

  final List<Map<String, dynamic>> logs = [
    {'timestamp': '09:00 AM', 'id': 'CRN-001', 'operation': 'Lift', 'load': 3200, 'capacity': 5000},
    {'timestamp': '10:00 AM', 'id': 'CRN-002', 'operation': 'Move', 'load': 4500, 'capacity': 10000},
    {'timestamp': '11:00 AM', 'id': 'CRN-003', 'operation': 'Lift', 'load': 5200, 'capacity': 6000},
    {'timestamp': '12:00 PM', 'id': 'CRN-004', 'operation': 'Move', 'load': 6800, 'capacity': 6800},
    {'timestamp': '01:00 PM', 'id': 'CRN-005', 'operation': 'Lift', 'load': 3900, 'capacity': 8000},
  ];

  @override
  Widget build(BuildContext context) {
    const currentLoad = 4250;
    const avgCapacity = 72;
    const maxCapacity = 6800;
    const status = "Normal";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Load Monitoring',
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
            _buildKPICards(currentLoad, avgCapacity, maxCapacity, status),
            const SizedBox(height: 20),

            // Filters
            _buildFilterSection(),
            const SizedBox(height: 20),

            // Chart
            _buildChartSection(),
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
              child: const Icon(Icons.fitness_center, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Load Lift Log",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Records of all load weight measurements",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildKPICards(int currentLoad, int avgCapacity, int maxCapacity, String status) {
    final List<Map<String, dynamic>> kpis = [
      {
        'value': '$currentLoad kg',
        'label': 'Current Load',
        'subtitle': 'Across all cranes',
        'color': Colors.blue,
        'icon': Icons.scale
      },
      {
        'value': '$avgCapacity%',
        'label': 'Avg Capacity',
        'subtitle': 'Utilization rate',
        'color': Colors.green,
        'icon': Icons.percent
      },
      {
        'value': '$maxCapacity kg',
        'label': 'Max Capacity',
        'subtitle': 'CRN-004 (6T capacity)',
        'color': Colors.orange,
        'icon': Icons.trending_up
      },
      {
        'value': status,
        'label': 'Overall Status',
        'subtitle': 'No active overloads',
        'color': Colors.green,
        'icon': Icons.check_circle
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
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown('Crane', cranes, selectedCrane),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown('Load Status', statuses, selectedStatus),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown('Date Range', dates, selectedDate),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
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
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
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

  Widget _buildFilterDropdown(String label, List<String> items, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
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
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                switch (label) {
                  case 'Crane':
                    selectedCrane = newValue!;
                    break;
                  case 'Load Status':
                    selectedStatus = newValue!;
                    break;
                  case 'Date Range':
                    selectedDate = newValue!;
                    break;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
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
            "Load Distribution",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(show: true, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}T',
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final cranes = ['CRN-001', 'CRN-002', 'CRN-003', 'CRN-004', 'CRN-005'];
                        return value.toInt() < cranes.length 
                            ? Text(
                                cranes[value.toInt()],
                                style: const TextStyle(fontSize: 10, color: Colors.black54),
                              )
                            : const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3.2, color: Colors.blue)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 4.5, color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5.2, color: Colors.orange)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6.8, color: Colors.red)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3.9, color: Colors.purple)]),
                ],
              ),
            ),
          ),
        ],
      ),
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
            "Recent Load Operations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              dataRowMinHeight: 40,
              headingRowHeight: 40,
              columns: const [
                DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Crane ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Operation', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Load (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Percentage', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: logs.map((log) {
                final percentage = ((log['load'] as int) / (log['capacity'] as int) * 100).toStringAsFixed(1);
                Color statusColor = _getLoadStatusColor(log['load'] as int, log['capacity'] as int);
                
                return DataRow(cells: [
                  DataCell(Text(log['timestamp'].toString())),
                  DataCell(Text(log['id'].toString())),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        log['operation'].toString(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(log['load'].toString())),
                  DataCell(Text(log['capacity'].toString())),
                  DataCell(Text('$percentage%')),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLoadStatusColor(int load, int capacity) {
    final percentage = (load / capacity) * 100;
    if (percentage >= 90) return Colors.red;
    if (percentage >= 75) return Colors.orange;
    return Colors.green;
  }
}