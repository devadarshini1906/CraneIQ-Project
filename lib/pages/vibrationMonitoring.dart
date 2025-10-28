import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../widgets/sidebar.dart';

class VibrationMonitoringPage extends StatefulWidget {
  const VibrationMonitoringPage({super.key});

  @override
  State<VibrationMonitoringPage> createState() => _VibrationMonitoringPageState();
}

class _VibrationMonitoringPageState extends State<VibrationMonitoringPage> {
  String selectedCrane = 'EOT Crane #1 (CRN-001)';
  String selectedDateRange = 'Today';

  final List<String> cranes = [
    'EOT Crane #1 (CRN-001)',
    'EOT Crane #2 (CRN-002)',
    'Gantry Crane #1 (GCN-003)',
  ];

  final List<String> dateRanges = ['Today', 'This Week', 'This Month'];

  final Map<String, List<double>> vibrationData = {
    "Hoist Motor": [2.5, 3.0, 3.2, 3.8, 4.2, 4.5, 4.1, 3.9],
    "Travel Motor": [1.5, 1.8, 2.2, 2.6, 3.0, 3.2, 2.9, 2.7],
    "Trolley Motor": [2.0, 2.3, 2.7, 3.0, 3.5, 3.8, 3.6, 3.4],
    "Gearbox": [3.0, 3.3, 3.5, 3.9, 4.1, 4.4, 4.0, 3.8],
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          "Vibration Monitoring",
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
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),

            // Filters
            _buildFilterSection(),
            const SizedBox(height: 20),

            // Overview
            _buildOverviewSection(),
            const SizedBox(height: 20),

            // Components
            ...vibrationData.keys.map((component) => 
                _buildComponentSection(component, vibrationData[component]!)),
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
              child: const Icon(Icons.vibration, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Vibration Analysis",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Monitor vibration levels across crane components",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crane',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCrane,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: cranes.map((crane) {
                          return DropdownMenuItem<String>(
                            value: crane,
                            child: Text(crane, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCrane = value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Range',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedDateRange,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: dateRanges.map((range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedDateRange = value!);
                        },
                      ),
                    ),
                  ],
                ),
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

  Widget _buildOverviewSection() {
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
            "Vibration Overview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} mm/s',
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
                      FlSpot(0, 2.0),
                      FlSpot(1, 2.8),
                      FlSpot(2, 3.2),
                      FlSpot(3, 3.8),
                      FlSpot(4, 3.5),
                      FlSpot(5, 3.1),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1E3A5F),
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: const Color(0xFF1E3A5F).withOpacity(0.1)),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    // Fixed the metrics data structure with proper typing
    final List<Map<String, dynamic>> metrics = [
      {
        'label': 'Peak Acceleration',
        'value': '2.8 g',
        'color': Colors.blue
      },
      {
        'label': 'Velocity RMS',
        'value': '4.2 mm/s',
        'color': Colors.green
      },
      {
        'label': 'Displacement',
        'value': '0.12 mm',
        'color': Colors.orange
      },
      {
        'label': 'Frequency',
        'value': '12.5 Hz',
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
        childAspectRatio: 3,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        final color = metric['color'] as Color;
        final value = metric['value'] as String;
        final label = metric['label'] as String;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComponentSection(String title, List<double> data) {
    double currentValue = data.last;
    Color statusColor = _getStatusColor(currentValue);

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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getStatusIcon(currentValue),
                  color: statusColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Text(
                  '${currentValue.toStringAsFixed(1)} mm/s',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildVibrationGauge(currentValue),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildVibrationChart(data),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVibrationGauge(double value) {
    return SizedBox(
      height: 120,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 5,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 2, color: Colors.green),
              GaugeRange(startValue: 2, endValue: 3.5, color: Colors.orange),
              GaugeRange(startValue: 3.5, endValue: 5, color: Colors.red),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: value,
                enableAnimation: true,
                needleColor: const Color(0xFF1E3A5F),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                positionFactor: 0.8,
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVibrationChart(List<double> values) {
    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              color: const Color(0xFF1E3A5F),
              barWidth: 2,
              belowBarData: BarAreaData(show: true, color: const Color(0xFF1E3A5F).withOpacity(0.1)),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(double value) {
    if (value < 2) return Colors.green;
    if (value < 3.5) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(double value) {
    if (value < 2) return Icons.check_circle;
    if (value < 3.5) return Icons.warning;
    return Icons.error;
  }
}