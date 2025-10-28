// pages/load_lift_log.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';

class LoadLiftLogPage extends StatefulWidget {
  const LoadLiftLogPage({super.key});

  @override
  State<LoadLiftLogPage> createState() => _LoadLiftLogPageState();
}

class _LoadLiftLogPageState extends State<LoadLiftLogPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedCrane = 'All Cranes';
  String selectedStatus = 'All Statuses';
  String selectedDate = 'Today';
  bool _showFilters = true;

  final List<String> cranes = ['All Cranes', 'CRN-001', 'CRN-002', 'CRN-003', 'CRN-004', 'CRN-005'];
  final List<String> statuses = ['All Statuses', 'Normal', 'Warning', 'Critical'];
  final List<String> dates = ['Today', 'This Week', 'This Month'];

  final List<Map<String, dynamic>> logs = [
    {'timestamp': '09:00 AM', 'id': 'CRN-001', 'operation': 'Lift', 'load': 3200, 'capacity': 5000},
    {'timestamp': '10:00 AM', 'id': 'CRN-002', 'operation': 'Move', 'load': 4500, 'capacity': 10000},
    {'timestamp': '11:00 AM', 'id': 'CRN-003', 'operation': 'Lift', 'load': 5200, 'capacity': 6000},
    {'timestamp': '12:00 PM', 'id': 'CRN-004', 'operation': 'Move', 'load': 6800, 'capacity': 6800},
    {'timestamp': '01:00 PM', 'id': 'CRN-005', 'operation': 'Lift', 'load': 3900, 'capacity': 8000},
    {'timestamp': '02:00 PM', 'id': 'CRN-001', 'operation': 'Move', 'load': 4800, 'capacity': 5000},
    {'timestamp': '03:00 PM', 'id': 'CRN-003', 'operation': 'Lift', 'load': 5800, 'capacity': 6000},
  ];

  // Innovative feature: Load trend data
  final List<double> loadTrend = [3.2, 4.5, 5.2, 6.8, 3.9, 4.8, 5.8];
  final List<String> trendLabels = ['9AM', '10AM', '11AM', '12PM', '1PM', '2PM', '3PM'];

  @override
  Widget build(BuildContext context) {
    const currentLoad = 4250;
    const avgCapacity = 72;
    const maxCapacity = 6800;
    const status = "Normal";

    return Scaffold(
      key: _scaffoldKey,
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
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF1E3A5F)),
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
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

            // KPI Cards - Fixed overflow by adjusting layout
            _buildKPICards(currentLoad, avgCapacity, maxCapacity, status),
            const SizedBox(height: 20),

            // Quick Stats Row
            _buildQuickStats(),
            const SizedBox(height: 20),

            // Filter Toggle
            _buildFilterToggle(),
            const SizedBox(height: 12),

            // Filters
            if (_showFilters) _buildFilterSection(),
            if (_showFilters) const SizedBox(height: 20),

            // Chart Section with Tabs
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
            // Innovative: Quick action button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_alert, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    "Set Alert",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
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
        'icon': Icons.scale,
        'trend': Icons.trending_up,
        'trendColor': Colors.green,
      },
      {
        'value': '$avgCapacity%',
        'label': 'Avg Utilization',
        'subtitle': 'Capacity rate',
        'color': Colors.green,
        'icon': Icons.percent,
        'trend': Icons.trending_flat,
        'trendColor': Colors.orange,
      },
      {
        'value': '$maxCapacity kg',
        'label': 'Max Today',
        'subtitle': 'CRN-004 (6T capacity)',
        'color': Colors.orange,
        'icon': Icons.trending_up,
        'trend': Icons.trending_up,
        'trendColor': Colors.red,
      },
      {
        'value': status,
        'label': 'System Status',
        'subtitle': 'No active overloads',
        'color': Colors.green,
        'icon': Icons.check_circle,
        'trend': Icons.trending_down,
        'trendColor': Colors.green,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5, // Increased aspect ratio to prevent overflow
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        final color = kpi['color'] as Color;
        final value = kpi['value'] as String;
        final label = kpi['label'] as String;
        final subtitle = kpi['subtitle'] as String;
        final icon = kpi['icon'] as IconData;
        final trend = kpi['trend'] as IconData;
        final trendColor = kpi['trendColor'] as Color;

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
            padding: const EdgeInsets.all(12), // Further reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4), // Reduced padding
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 14), // Reduced icon size
                    ),
                    Icon(trend, color: trendColor, size: 14), // Trend indicator
                  ],
                ),
                const SizedBox(height: 6), // Reduced spacing
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 2), // Minimal spacing
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10, // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 1), // Minimal spacing
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 8, // Reduced font size
                    color: Colors.black54,
                  ),
                  maxLines: 2, // Prevent text overflow
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStatItem('Total Ops', '${logs.length}', Icons.list_alt, Colors.blue),
          _buildQuickStatItem('Avg Load', '4.8T', Icons.analytics, Colors.green),
          _buildQuickStatItem('Peak Today', '6.8T', Icons.flag, Colors.orange),
          _buildQuickStatItem('Safety', '100%', Icons.security, Colors.green),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          const Text(
            'Advanced Filters',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const Spacer(),
          Switch(
            value: _showFilters,
            onChanged: (value) => setState(() => _showFilters = value),
            activeThumbColor: const Color(0xFF1E3A5F),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
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
          // Responsive filter layout for different screen sizes
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Desktop layout
                return Row(
                  children: [
                    Expanded(child: _buildFilterDropdown('Crane', cranes, selectedCrane)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFilterDropdown('Load Status', statuses, selectedStatus)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFilterDropdown('Date Range', dates, selectedDate)),
                  ],
                );
              } else {
                // Mobile layout
                return Column(
                  children: [
                    _buildFilterDropdown('Crane', cranes, selectedCrane),
                    const SizedBox(height: 12),
                    _buildFilterDropdown('Load Status', statuses, selectedStatus),
                    const SizedBox(height: 12),
                    _buildFilterDropdown('Date Range', dates, selectedDate),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _applyFilters,
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
                  onPressed: _resetFilters,
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
            "Load Analytics",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 12),
          
          // Innovative: Chart type selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildChartTypeButton('Distribution', true),
                const SizedBox(width: 8),
                _buildChartTypeButton('Trend', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 200, // Adjusted height for better fit
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8, // Set maximum Y value to prevent overflow
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
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '${value.toInt()}T',
                          style: const TextStyle(fontSize: 9, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        final cranes = ['CRN-001', 'CRN-002', 'CRN-003', 'CRN-004', 'CRN-005'];
                        return value.toInt() < cranes.length 
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  cranes[value.toInt()],
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
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0, 
                    barRods: [BarChartRodData(
                      toY: 3.2, 
                      color: _getLoadColor(3.2, 5.0),
                      width: 10, // Reduced width
                      borderRadius: BorderRadius.circular(4),
                    )]
                  ),
                  BarChartGroupData(
                    x: 1, 
                    barRods: [BarChartRodData(
                      toY: 4.5, 
                      color: _getLoadColor(4.5, 10.0),
                      width: 10, // Reduced width
                      borderRadius: BorderRadius.circular(4),
                    )]
                  ),
                  BarChartGroupData(
                    x: 2, 
                    barRods: [BarChartRodData(
                      toY: 5.2, 
                      color: _getLoadColor(5.2, 6.0),
                      width: 10, // Reduced width
                      borderRadius: BorderRadius.circular(4),
                    )]
                  ),
                  BarChartGroupData(
                    x: 3, 
                    barRods: [BarChartRodData(
                      toY: 6.8, 
                      color: _getLoadColor(6.8, 6.8),
                      width: 10, // Reduced width
                      borderRadius: BorderRadius.circular(4),
                    )]
                  ),
                  BarChartGroupData(
                    x: 4, 
                    barRods: [BarChartRodData(
                      toY: 3.9, 
                      color: _getLoadColor(3.9, 8.0),
                      width: 10, // Reduced width
                      borderRadius: BorderRadius.circular(4),
                    )]
                  ),
                ],
              ),
            ),
          ),
          
          // Innovative: Chart insights
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "CRN-004 operating at maximum capacity. Consider load balancing.",
                    style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E3A5F) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getLoadColor(double load, double capacity) {
    final percentage = (load / capacity) * 100;
    if (percentage >= 90) return Colors.red;
    if (percentage >= 75) return Colors.orange;
    return Colors.green;
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
          Row(
            children: [
              const Text(
                "Recent Load Operations",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
              const Spacer(),
              // Innovative: Export button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download, size: 14, color: Colors.black54),
                    SizedBox(width: 4),
                    Text(
                      "Export",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16, // Reduced column spacing
              dataRowMinHeight: 36, // Reduced row height
              headingRowHeight: 36, // Reduced heading height
              columns: const [
                DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Crane ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Operation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Load (kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Utilization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
              ],
              rows: logs.map((log) {
                final percentage = ((log['load'] as int) / (log['capacity'] as int) * 100).toStringAsFixed(1);
                Color statusColor = _getLoadStatusColor(log['load'] as int, log['capacity'] as int);
                String statusText = _getStatusText(log['load'] as int, log['capacity'] as int);
                
                return DataRow(
                  cells: [
                    DataCell(Text(log['timestamp'].toString(), style: const TextStyle(fontSize: 10))),
                    DataCell(Text(log['id'].toString(), style: const TextStyle(fontSize: 10))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text('${log['load']} kg', style: const TextStyle(fontSize: 10))),
                    DataCell(Text('${log['capacity']} kg', style: const TextStyle(fontSize: 10))),
                    DataCell(Text('$percentage%', style: const TextStyle(fontSize: 10))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
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

  String _getStatusText(int load, int capacity) {
    final percentage = (load / capacity) * 100;
    if (percentage >= 90) return 'Critical';
    if (percentage >= 75) return 'Warning';
    return 'Normal';
  }

  void _applyFilters() {
    // Filter logic would go here
    setState(() {
      _showFilters = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters applied successfully'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCrane = 'All Cranes';
      selectedStatus = 'All Statuses';
      selectedDate = 'Today';
      _showFilters = false;
    });
  }
}