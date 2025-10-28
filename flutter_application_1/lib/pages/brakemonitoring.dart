// pages/brakemonitoring.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';

class BrakeMonitoringPage extends StatefulWidget {
  const BrakeMonitoringPage({super.key});

  @override
  State<BrakeMonitoringPage> createState() => _BrakeMonitoringPageState();
}

class _BrakeMonitoringPageState extends State<BrakeMonitoringPage> {
  String selectedCrane = 'All Cranes';
  String selectedBrake = 'All Brakes';
  String selectedDateRange = 'Today';

  // Mock Data
  final int totalActivations = 12487;
  final double averageWearRate = 2.3;
  final double averageAirGap = 1.8;
  final int predictedLifespan = 342;

  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> activationCounts = [120, 150, 100, 180, 200, 80, 50];
  final List<double> wearStatus = [10, 15, 20, 25, 28, 30, 32];
  final List<double> airGap = [1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1];

  final List<Map<String, dynamic>> brakeData = [
    {
      'timestamp': '2023-06-15 08:23:45',
      'crane': 'CRN-001',
      'type': 'Hoist Brake',
      'activation': 120,
      'shoe': 'Good',
      'wear': 15,
      'gap': 1.5,
      'lifetime': 12487,
      'status': 'NORMAL'
    },
    {
      'timestamp': '2023-06-15 08:45:12',
      'crane': 'CRN-002',
      'type': 'Trolley Brake',
      'activation': 85,
      'shoe': 'Fair',
      'wear': 28,
      'gap': 2.1,
      'lifetime': 8742,
      'status': 'NORMAL'
    },
    {
      'timestamp': '2023-06-15 10:05:27',
      'crane': 'CRN-004',
      'type': 'Hoist Brake',
      'activation': 201,
      'shoe': 'Poor',
      'wear': 42,
      'gap': 2.4,
      'lifetime': 15892,
      'status': 'CRITICAL'
    },
    {
      'timestamp': '2023-06-15 11:15:06',
      'crane': 'CRN-005',
      'type': 'Hoist Brake',
      'activation': 178,
      'shoe': 'Fair',
      'wear': 35,
      'gap': 2.2,
      'lifetime': 14237,
      'status': 'WARNING'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isSmallMobile = width < 400;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Brake Monitoring',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ],
      ),
      drawer: const Sidebar(onItemSelected: null),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[50], size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Brake Monitoring Dashboard',
                          style: TextStyle(
                            fontSize: isSmallMobile ? 18 : 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Real-time brake performance and wear analysis',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSmallMobile ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
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
                        Icon(Icons.filter_list, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isMobile)
                      Column(
                        children: [
                          _buildFilterDropdown('Crane', selectedCrane, [
                            'All Cranes',
                            'Gantry Crane #1 (CRN-001)',
                            'Overhead Crane #2 (CRN-002)',
                            'Jib Crane #3 (CRN-003)',
                            'Bridge Crane #4 (CRN-004)',
                            'Gantry Crane #5 (CRN-005)',
                          ]),
                          const SizedBox(height: 12),
                          _buildFilterDropdown('Brake Type', selectedBrake, [
                            'All Brakes',
                            'Hoist Brake',
                            'Trolley Brake',
                            'Bridge Brake'
                          ]),
                          const SizedBox(height: 12),
                          _buildFilterDropdown('Date Range', selectedDateRange, [
                            'Today',
                            'This Week',
                            'This Month',
                            'Custom Range'
                          ]),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown('Crane', selectedCrane, [
                              'All Cranes',
                              'Gantry Crane #1 (CRN-001)',
                              'Overhead Crane #2 (CRN-002)',
                              'Jib Crane #3 (CRN-003)',
                              'Bridge Crane #4 (CRN-004)',
                              'Gantry Crane #5 (CRN-005)',
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFilterDropdown('Brake Type', selectedBrake, [
                              'All Brakes',
                              'Hoist Brake',
                              'Trolley Brake',
                              'Bridge Brake'
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFilterDropdown('Date Range', selectedDateRange, [
                              'Today',
                              'This Week',
                              'This Month',
                              'Custom Range'
                            ]),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_alt, size: 18),
                            label: const Text('Apply Filters'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedCrane = 'All Cranes';
                                selectedBrake = 'All Brakes';
                                selectedDateRange = 'Today';
                              });
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Reset'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // KPI Cards
              GridView.count(
                crossAxisCount: isMobile ? 2 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isSmallMobile ? 0.9 : 1.0,
                children: [
                  _buildKpiCard(
                    title: 'Total Brake Activations',
                    value: '12,487',
                    subtitle: '↑3.2% from last week',
                    color: const Color(0xFFFF5252),
                    icon: Icons.trending_up,
                  ),
                  _buildKpiCard(
                    title: 'Avg Wear Rate',
                    value: '2.3%',
                    subtitle: '↓0.5% from last month',
                    color: const Color(0xFF4CAF50),
                    icon: Icons.trending_down,
                  ),
                  _buildKpiCard(
                    title: 'Avg Air Gap',
                    value: '1.8 mm',
                    subtitle: '↓0.2mm from last month',
                    color: const Color(0xFF4CAF50),
                    icon: Icons.trending_down,
                  ),
                  _buildKpiCard(
                    title: 'Predicted Lifespan',
                    value: '342 days',
                    subtitle: '↑12 days from last month',
                    color: const Color(0xFF4CAF50),
                    icon: Icons.trending_up,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Charts Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
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
                        Icon(Icons.analytics, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Brake Performance Analytics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildChartSection(
                      title: 'Brake Activation Count',
                      chart: _buildActivationChart(),
                    ),
                    const SizedBox(height: 24),
                    _buildChartSection(
                      title: 'Brake Wear Status',
                      chart: _buildWearChart(),
                    ),
                    const SizedBox(height: 24),
                    _buildChartSection(
                      title: 'Air Gap Measurement',
                      chart: _buildAirGapChart(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Data Table Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
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
                        Icon(Icons.table_chart, color: Colors.green[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Brake Performance Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isMobile) _buildMobileDataTable() else _buildDesktopDataTable(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods

  Widget _buildFilterDropdown(String label, String value, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        onChanged: (String? newValue) {
          if (newValue == null) return;
          setState(() {
            if (label == 'Crane') {
              selectedCrane = newValue;
            } else if (label == 'Brake Type') {
              selectedBrake = newValue;
            } else if (label == 'Date Range') {
              selectedDateRange = newValue;
            }
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.grey[800], fontSize: 14),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subtitle.split(' ').first,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: chart,
        ),
      ],
    );
  }

  Widget _buildActivationChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  weekDays[value.toInt() % weekDays.length],
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ),
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(enabled: false),
        barGroups: List.generate(
          activationCounts.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: activationCounts[i].toDouble(),
                color: const Color(0xFF1976D2),
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWearChart() {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(wearStatus.length, (i) => FlSpot(i.toDouble(), wearStatus[i])),
            isCurved: true,
            color: const Color(0xFFFF5252),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFFF5252).withOpacity(0.1),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildAirGapChart() {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(airGap.length, (i) => FlSpot(i.toDouble(), airGap[i])),
            isCurved: true,
            color: const Color(0xFF1976D2),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF1976D2).withOpacity(0.1),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          return Colors.white;
        }),
        border: TableBorder.all(color: Colors.grey[300]!),
        columns: [
          DataColumn(label: Text('Timestamp', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Crane ID', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Brake Type', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Activation', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Shoe Status', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Wear %', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Air Gap', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Lifetime', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
          DataColumn(label: Text('Status', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
        ],
        rows: brakeData.map((row) {
          Color color;
          switch (row['status']) {
            case 'CRITICAL':
              color = const Color(0xFFFF5252);
              break;
            case 'WARNING':
              color = const Color(0xFFFF9800);
              break;
            default:
              color = const Color(0xFF4CAF50);
          }
          return DataRow(cells: [
            DataCell(Text('${row['timestamp']}', style: TextStyle(color: Colors.grey[600]))),
            DataCell(Text('${row['crane']}', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Text('${row['type']}', style: TextStyle(color: Colors.grey[600]))),
            DataCell(Text('${row['activation']}', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Text('${row['shoe']}', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Text('${row['wear']}%', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Text('${row['gap']} mm', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Text('${row['lifetime']}', style: TextStyle(color: Colors.grey[800]))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text('${row['status']}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildMobileDataTable() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brakeData.length,
      itemBuilder: (context, index) {
        final row = brakeData[index];
        Color color;
        switch (row['status']) {
          case 'CRITICAL':
            color = const Color(0xFFFF5252);
            break;
          case 'WARNING':
            color = const Color(0xFFFF9800);
            break;
          default:
            color = const Color(0xFF4CAF50);
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${row['crane']}', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text('${row['status']}',
                        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildMobileTableRow('Brake Type', '${row['type']}'),
              _buildMobileTableRow('Timestamp', '${row['timestamp']}'),
              _buildMobileTableRow('Activation Count', '${row['activation']}'),
              _buildMobileTableRow('Shoe Status', '${row['shoe']}'),
              _buildMobileTableRow('Wear', '${row['wear']}%'),
              _buildMobileTableRow('Air Gap', '${row['gap']} mm'),
              _buildMobileTableRow('Lifetime', '${row['lifetime']}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}