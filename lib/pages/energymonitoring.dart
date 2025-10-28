import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/sidebar.dart';
import 'dart:developer' as developer;

class EnergyMonitoringDashboard extends StatefulWidget {
  const EnergyMonitoringDashboard({super.key});

  @override
  State<EnergyMonitoringDashboard> createState() => _EnergyMonitoringDashboardState();
}

class _EnergyMonitoringDashboardState extends State<EnergyMonitoringDashboard> {
  String selectedCrane = 'All Cranes';
  String selectedMotorType = 'All Motors';
  String selectedDateRange = 'Today';
  String selectedEnergyMetric = 'Power (kW)';

  final List<Map<String, dynamic>> tableData = [
    {
      'timestamp': '2023-06-15 08:23:45',
      'craneId': 'CRN-001',
      'motorType': 'Hoist',
      'power': 12.5,
      'current': 28.2,
      'voltage': 410,
      'energy': 25.0,
      'cost': 3.75,
      'status': 'NORMAL',
      'loadWeight': 10.0,
    },
    {
      'timestamp': '2023-06-15 08:45:12',
      'craneId': 'CRN-002',
      'motorType': 'Travel',
      'power': 8.2,
      'current': 18.5,
      'voltage': 400,
      'energy': 16.4,
      'cost': 2.46,
      'status': 'NORMAL',
      'loadWeight': 8.0,
    },
    {
      'timestamp': '2023-06-15 09:12:33',
      'craneId': 'CRN-001',
      'motorType': 'Trolley',
      'power': 7.0,
      'current': 15.8,
      'voltage': 410,
      'energy': 14.0,
      'cost': 2.10,
      'status': 'NORMAL',
      'loadWeight': 6.0,
    },
  ];

  static const double energyThreshold = 100.0;

  List<Map<String, dynamic>> get filteredTableData {
    return tableData.where((data) {
      bool craneMatch = selectedCrane == 'All Cranes' || data['craneId'] == selectedCrane;
      bool motorMatch = selectedMotorType == 'All Motors' || data['motorType'] == selectedMotorType;
      return craneMatch && motorMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Energy Monitoring',
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
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(isMobile),
            const SizedBox(height: 20),

            // Energy Gauge
            _buildEnergyGauge(isMobile),
            const SizedBox(height: 20),

            // KPI Cards
            _buildKPICards(isMobile),
            const SizedBox(height: 20),

            // Filters
            _buildFilters(isMobile),
            const SizedBox(height: 20),

            // Charts
            _buildChartsSection(isMobile),
            const SizedBox(height: 20),

            // Data Table
            _buildDataTable(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
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
              child: const Icon(Icons.bolt, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Energy Consumption',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Monitor power usage and optimize energy efficiency',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEnergyGauge(bool isMobile) {
    double currentEnergy = filteredTableData.isNotEmpty
        ? filteredTableData.last['energy']
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Current Energy Level',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: isMobile ? 180 : 200,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: energyThreshold,
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 0, endValue: 30, color: Colors.green),
                    GaugeRange(startValue: 30, endValue: 70, color: Colors.orange),
                    GaugeRange(startValue: 70, endValue: energyThreshold, color: Colors.red),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: currentEnergy,
                      enableAnimation: true,
                      needleColor: const Color(0xFF1E3A5F),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentEnergy.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                          ),
                          const Text(
                            'kWh',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      positionFactor: 0.5,
                      angle: 90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards(bool isMobile) {
    // Fixed the KPI data structure - removed the problematic syntax
    final List<Map<String, dynamic>> kpis = [
      {
        'value': '24.8 kW',
        'label': 'Total Power',
        'color': Colors.blue,
        'icon': Icons.bolt
      },
      {
        'value': '\$18.42',
        'label': 'Hourly Cost',
        'color': Colors.green,
        'icon': Icons.attach_money
      },
      {
        'value': '87%',
        'label': 'Efficiency',
        'color': Colors.orange,
        'icon': Icons.trending_up
      },
      {
        'value': '1.2 kWh/T',
        'label': 'Per Ton',
        'color': Colors.purple,
        'icon': Icons.scale
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                    color: (kpi['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(kpi['icon'] as IconData, color: kpi['color'] as Color, size: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  kpi['value'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kpi['color'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kpi['label'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilters(bool isMobile) {
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
            'Filters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildFilterRow('Crane', selectedCrane, ['All Cranes', 'CRN-001', 'CRN-002', 'CRN-003']),
              const SizedBox(height: 12),
              _buildFilterRow('Motor Type', selectedMotorType, ['All Motors', 'Hoist', 'Travel', 'Trolley']),
              const SizedBox(height: 12),
              _buildFilterRow('Date Range', selectedDateRange, ['Today', 'This Week', 'This Month']),
              const SizedBox(height: 12),
              _buildFilterRow('Metric', selectedEnergyMetric, ['Power (kW)', 'Current (A)', 'Voltage (V)', 'Energy (kWh)']),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
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
                  case 'Motor Type':
                    selectedMotorType = newValue!;
                    break;
                  case 'Date Range':
                    selectedDateRange = newValue!;
                    break;
                  case 'Metric':
                    selectedEnergyMetric = newValue!;
                    break;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(bool isMobile) {
    return Column(
      children: [
        _buildChartCard('Power Consumption', _buildPowerChart(), isMobile),
        const SizedBox(height: 16),
        _buildChartCard('Energy Usage Trend', _buildEnergyChart(), isMobile),
        const SizedBox(height: 16),
        _buildChartCard('Cost Analysis', _buildCostChart(), isMobile),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart, bool isMobile) {
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
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawHorizontalLine: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()} kW',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                final hours = ['8:00', '10:00', '12:00', '14:00', '16:00', '18:00'];
                return value.toInt() < hours.length 
                    ? Text(
                        hours[value.toInt()],
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      )
                    : const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 12),
              FlSpot(1, 15),
              FlSpot(2, 18),
              FlSpot(3, 14),
              FlSpot(4, 16),
              FlSpot(5, 13),
            ],
            isCurved: true,
            color: const Color(0xFF1E3A5F),
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: const Color(0xFF1E3A5F).withOpacity(0.1)),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(show: true, drawHorizontalLine: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()} kWh',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                return value.toInt() < days.length 
                    ? Text(
                        days[value.toInt()],
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      )
                    : const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 25, color: Colors.blue)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 30, color: Colors.blue)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 22, color: Colors.blue)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 28, color: Colors.blue)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 26, color: Colors.blue)]),
        ],
      ),
    );
  }

  Widget _buildCostChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawHorizontalLine: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '\$${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                final hours = ['8:00', '10:00', '12:00', '14:00', '16:00', '18:00'];
                return value.toInt() < hours.length 
                    ? Text(
                        hours[value.toInt()],
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      )
                    : const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2.5),
              FlSpot(1, 3.2),
              FlSpot(2, 4.1),
              FlSpot(3, 3.4),
              FlSpot(4, 3.8),
              FlSpot(5, 2.9),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(bool isMobile) {
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
            'Energy Data',
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
                DataColumn(label: Text('Crane', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Power', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Energy', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cost', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: filteredTableData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data['timestamp'].toString().split(' ')[1])),
                  DataCell(Text(data['craneId'].toString())),
                  DataCell(Text('${data['power']} kW')),
                  DataCell(Text('${data['energy']} kWh')),
                  DataCell(Text('\$${data['cost']}')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: data['status'] == 'NORMAL' ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: data['status'] == 'NORMAL' ? Colors.green.shade200 : Colors.orange.shade200,
                        ),
                      ),
                      child: Text(
                        data['status'],
                        style: TextStyle(
                          color: data['status'] == 'NORMAL' ? Colors.green.shade700 : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCrane = 'All Cranes';
      selectedMotorType = 'All Motors';
      selectedDateRange = 'Today';
      selectedEnergyMetric = 'Power (kW)';
    });
  }

  void _onItemSelected(String title) {
    if (!mounted) return;
    developer.log('Navigating to: $title');
    if (title == 'Energy Monitoring') {
      return;
    }
    Navigator.pop(context);
    switch (title) {
      case 'Dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Vibration Monitoring':
        Navigator.pushNamed(context, '/vibration');
        break;
      case 'Operations Log':
        Navigator.pushNamed(context, '/operations_log');
        break;
      case 'Load':
        Navigator.pushNamed(context, '/load');
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
      case 'Help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'Machine Management':
        Navigator.pushNamed(context, '/machine_management');
        break;
      case 'Gateway Management':
        Navigator.pushNamed(context, '/gateway_management');
        break;
      case 'Device Management':
        Navigator.pushNamed(context, '/device_management');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped $title (not implemented)'), duration: const Duration(seconds: 1)),
        );
        break;
    }
  }
}