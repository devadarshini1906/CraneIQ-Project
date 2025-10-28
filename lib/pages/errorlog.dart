// pages/error_log_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
// import '../widgets/sidebar.dart'; // Uncomment and adjust path if sidebar exists

// Define the ErrorLogEntry model class
class ErrorLogEntry {
  final String id;
  final DateTime timestamp;
  final String craneId;
  final String craneName;
  final String errorCode;
  final String? sensor;
  final String type;
  final String severity;
  final String? assignedTo;
  final String status;

  ErrorLogEntry({
    required this.id,
    required this.timestamp,
    required this.craneId,
    required this.craneName,
    required this.errorCode,
    this.sensor,
    required this.type,
    required this.severity,
    this.assignedTo,
    required this.status,
  });
}

class ErrorLogPage extends StatefulWidget {
  const ErrorLogPage({super.key});

  @override
  State<ErrorLogPage> createState() => _ErrorLogPageState();
}

class _ErrorLogPageState extends State<ErrorLogPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ErrorLogEntry> errorLogs = [];
  List<ErrorLogEntry> filteredLogs = [];

  // Filter states
  String? selectedCrane;
  String? selectedSensorType;
  String? selectedErrorType;
  String? selectedSeverity;
  String? selectedDateRange;

  // Mobile-friendly states
  bool _showFilters = false;
  int _selectedTab = 0; // 0: Overview, 1: List

  @override
  void initState() {
    super.initState();
    _loadErrorLogs();
  }

  void _loadErrorLogs() {
    errorLogs = [
      ErrorLogEntry(
        id: '1',
        timestamp: DateTime(2023, 6, 15, 8, 23, 45),
        craneId: 'CRN-001',
        craneName: 'Gantry Crane #1',
        errorCode: 'VFD-ERR-2023-001',
        sensor: 'Vfd',
        type: 'Electrical',
        severity: 'CRITICAL',
        assignedTo: 'JS John Smith',
        status: 'Investigating',
      ),
      ErrorLogEntry(
        id: '2',
        timestamp: DateTime(2023, 6, 15, 8, 45, 12),
        craneId: 'CRN-002',
        craneName: 'Overhead Crane #2',
        errorCode: 'LIM-ERR-2023-002',
        sensor: 'Limit',
        type: 'Mechanical',
        severity: 'ERROR',
        assignedTo: 'SJ Sarah Johnson',
        status: 'Acknowledged',
      ),
      ErrorLogEntry(
        id: '3',
        timestamp: DateTime(2023, 6, 15, 9, 12, 33),
        craneId: 'CRN-001',
        craneName: 'Gantry Crane #1',
        errorCode: 'TEMP-ERR-2023-001',
        sensor: 'Temp',
        type: 'Mechanical',
        severity: 'WARNING',
        assignedTo: 'MC Michael Chen',
        status: 'Unresolved',
      ),
      ErrorLogEntry(
        id: '4',
        timestamp: DateTime(2023, 6, 15, 10, 5, 27),
        craneId: 'CRN-004',
        craneName: 'Bridge Crane #4',
        errorCode: 'LOAD-ERR-2023-001',
        sensor: 'Load',
        type: 'Software',
        severity: 'ERROR',
        assignedTo: 'ED Emma Davis',
        status: 'Resolved',
      ),
      ErrorLogEntry(
        id: '5',
        timestamp: DateTime(2023, 6, 15, 10, 45, 52),
        craneId: 'CRN-002',
        craneName: 'Overhead Crane #2',
        errorCode: 'ROPE-ERR-2023-001',
        sensor: 'Rope',
        type: 'Mechanical',
        severity: 'WARNING',
        assignedTo: 'DW David Wilson',
        status: 'Acknowledged',
      ),
      ErrorLogEntry(
        id: '6',
        timestamp: DateTime(2023, 6, 15, 11, 15, 6),
        craneId: 'CRN-003',
        craneName: 'Jib Crane #3',
        errorCode: 'MAN-ERR-2023-001',
        sensor: 'Manual',
        type: 'Safety',
        severity: 'INFO',
        assignedTo: null,
        status: 'Unresolved',
      ),
      ErrorLogEntry(
        id: '7',
        timestamp: DateTime(2023, 6, 15, 11, 52, 41),
        craneId: 'CRN-001',
        craneName: 'Gantry Crane #1',
        errorCode: 'VFD-ERR-2023-002',
        sensor: 'Vfd',
        type: 'Electrical',
        severity: 'CRITICAL',
        assignedTo: 'JS John Smith',
        status: 'Investigating',
      ),
      ErrorLogEntry(
        id: '8',
        timestamp: DateTime(2023, 6, 15, 12, 30, 15),
        craneId: 'CRN-004',
        craneName: 'Bridge Crane #4',
        errorCode: 'TEMP-ERR-2023-002',
        sensor: 'Temp',
        type: 'Mechanical',
        severity: 'ERROR',
        assignedTo: 'SJ Sarah Johnson',
        status: 'Acknowledged',
      ),
      ErrorLogEntry(
        id: '9',
        timestamp: DateTime(2023, 6, 15, 13, 45, 22),
        craneId: 'CRN-002',
        craneName: 'Overhead Crane #2',
        errorCode: 'SOFT-ERR-2023-001',
        sensor: 'Load',
        type: 'Software',
        severity: 'WARNING',
        assignedTo: 'MC Michael Chen',
        status: 'Investigating',
      ),
      // New rows added
      ErrorLogEntry(
        id: '10',
        timestamp: DateTime(2023, 6, 15, 14, 10, 30),
        craneId: 'CRN-003',
        craneName: 'Jib Crane #3',
        errorCode: 'OVER-ERR-2023-001',
        sensor: 'Overload',
        type: 'Safety',
        severity: 'CRITICAL',
        assignedTo: 'AL Alice Lee',
        status: 'Unresolved',
      ),
      ErrorLogEntry(
        id: '11',
        timestamp: DateTime(2023, 6, 15, 14, 25, 15),
        craneId: 'CRN-004',
        craneName: 'Bridge Crane #4',
        errorCode: 'MOT-ERR-2023-001',
        sensor: 'Motor',
        type: 'Electrical',
        severity: 'ERROR',
        assignedTo: 'RP Robert Patel',
        status: 'Resolved',
      ),
      ErrorLogEntry(
        id: '12',
        timestamp: DateTime(2023, 6, 15, 15, 00, 45),
        craneId: 'CRN-001',
        craneName: 'Gantry Crane #1',
        errorCode: 'HMI-ERR-2023-001',
        sensor: 'HMI',
        type: 'Software',
        severity: 'WARNING',
        assignedTo: 'TK Tom Kelly',
        status: 'Acknowledged',
      ),
      ErrorLogEntry(
        id: '13',
        timestamp: DateTime(2023, 6, 15, 15, 30, 20),
        craneId: 'CRN-002',
        craneName: 'Overhead Crane #2',
        errorCode: 'BRAKE-ERR-2023-001',
        sensor: 'Brake',
        type: 'Mechanical',
        severity: 'INFO',
        assignedTo: null,
        status: 'Unresolved',
      ),
      ErrorLogEntry(
        id: '14',
        timestamp: DateTime(2023, 6, 15, 16, 05, 10),
        craneId: 'CRN-003',
        craneName: 'Jib Crane #3',
        errorCode: 'TEMP-ERR-2023-003',
        sensor: 'Temp',
        type: 'Mechanical',
        severity: 'ERROR',
        assignedTo: 'JD James Doe',
        status: 'Investigating',
      ),
    ];
    filteredLogs = List.from(errorLogs);
  }

  List<PieChartSectionData> _getSeverityChartData() {
    return [
      PieChartSectionData(
        color: const Color(0xFFE53935),
        value: 30,
        title: '30%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: const Color(0xFFFF9800),
        value: 25,
        title: '25%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: const Color(0xFFFFEB3B),
        value: 25,
        title: '25%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: const Color(0xFF42A5F5),
        value: 20,
        title: '20%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }

  List<BarChartGroupData> _getSensorTypeChartData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 7, color: const Color(0xFF7E57C2), width: 12)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 4, color: const Color(0xFF66BB6A), width: 12)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 5, color: const Color(0xFFFF9800), width: 12)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 3, color: const Color(0xFF42A5F5), width: 12)],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 2, color: const Color(0xFF8D6E63), width: 12)],
      ),
    ];
  }

  List<BarChartGroupData> _getErrorTypeChartData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 12, color: const Color(0xFFFF9800), width: 12)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 8, color: const Color(0xFF7E57C2), width: 12)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 6, color: const Color(0xFFE53935), width: 12)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 4, color: const Color(0xFF42A5F5), width: 12)],
      ),
    ];
  }

  void _applyFilters() {
    setState(() {
      filteredLogs = errorLogs.where((log) {
        bool craneMatch = selectedCrane == null || selectedCrane == 'All Cranes' || log.craneId == selectedCrane;
        bool sensorMatch = selectedSensorType == null || selectedSensorType == 'All Sensors' || log.sensor == selectedSensorType;
        bool typeMatch = selectedErrorType == null || selectedErrorType == 'All Types' || log.type == selectedErrorType;
        bool severityMatch = selectedSeverity == null || selectedSeverity == 'All Levels' || log.severity == selectedSeverity;
        bool dateMatch = selectedDateRange == null || selectedDateRange == 'Today' || selectedDateRange == 'Last 30 Days';
        return craneMatch && sensorMatch && typeMatch && severityMatch && dateMatch;
      }).toList();
      _showFilters = false;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedCrane = null;
      selectedSensorType = null;
      selectedErrorType = null;
      selectedSeverity = null;
      selectedDateRange = null;
      filteredLogs = List.from(errorLogs);
      _showFilters = false;
    });
  }

  Widget _buildSeverityChip(String severity) {
    final (color, textColor) = switch (severity) {
      'CRITICAL' => (const Color(0xFFE53935), Colors.white),
      'ERROR' => (const Color(0xFFFF9800), Colors.white),
      'WARNING' => (const Color(0xFFFFEB3B), Colors.black87),
      'INFO' => (const Color(0xFF42A5F5), Colors.white),
      _ => (Colors.grey, Colors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final (color, textColor) = switch (status) {
      'Investigating' => (const Color(0xFFFF9800), Colors.white),
      'Unresolved' => (const Color(0xFFE53935), Colors.white),
      'Acknowledged' => (const Color(0xFF42A5F5), Colors.white),
      'Resolved' => (const Color(0xFF66BB6A), Colors.white),
      _ => (Colors.grey, Colors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorCard(ErrorLogEntry log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    log.errorCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildSeverityChip(log.severity),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.crisis_alert, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${log.craneId} • ${log.craneName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.sensors, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  log.sensor ?? 'Manual',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                const Spacer(),
                Icon(Icons.category, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  log.type,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, HH:mm').format(log.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                const Spacer(),
                _buildStatusChip(log.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    log.assignedTo ?? 'Unassigned',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, size: 16, color: Color(0xFF1976D2)),
                  onPressed: () {
                    // Show error details
                    _showErrorDetails(log);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDetails(ErrorLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  log.errorCode,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildSeverityChip(log.severity),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Crane', '${log.craneId} - ${log.craneName}'),
            _buildDetailRow('Sensor Type', log.sensor ?? 'Manual'),
            _buildDetailRow('Error Type', log.type),
            _buildDetailRow('Timestamp', DateFormat('MMM dd, yyyy HH:mm').format(log.timestamp)),
            _buildDetailRow('Assigned To', log.assignedTo ?? 'Unassigned'),
            _buildDetailRow('Status', log.status),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option),
            selected: value == option,
            onSelected: (selected) => onSelected(selected ? option : null),
            backgroundColor: Colors.grey[100],
            selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
            checkmarkColor: const Color(0xFF1976D2),
            labelStyle: TextStyle(
              color: value == option ? const Color(0xFF1976D2) : Colors.grey[700],
              fontWeight: value == option ? FontWeight.bold : FontWeight.normal,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Error Log',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Color(0xFF1976D2)),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF1976D2)),
              onPressed: _loadErrorLogs,
            ),
          ],
        ),
        body: Column(
          children: [
            // Quick Stats Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Error Overview',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Report', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filteredLogs.length} errors found',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Tab Navigation
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _selectedTab = 0),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedTab == 0 ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          color: _selectedTab == 0 ? const Color(0xFF1976D2) : Colors.grey,
                          fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _selectedTab = 1),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedTab == 1 ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Error List',
                        style: TextStyle(
                          color: _selectedTab == 1 ? const Color(0xFF1976D2) : Colors.grey,
                          fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filters Panel
            if (_showFilters) ...[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('Crane', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    _buildFilterChip(
                      label: 'Crane',
                      value: selectedCrane,
                      options: ['All Cranes', 'CRN-001', 'CRN-002', 'CRN-003', 'CRN-004'],
                      onSelected: (value) => setState(() => selectedCrane = value),
                    ),
                    const SizedBox(height: 12),
                    const Text('Sensor Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    _buildFilterChip(
                      label: 'Sensor',
                      value: selectedSensorType,
                      options: ['All Sensors', 'Vfd', 'Limit', 'Temp', 'Load', 'Rope', 'Manual'],
                      onSelected: (value) => setState(() => selectedSensorType = value),
                    ),
                    const SizedBox(height: 12),
                    const Text('Error Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    _buildFilterChip(
                      label: 'Type',
                      value: selectedErrorType,
                      options: ['All Types', 'Mechanical', 'Electrical', 'Safety', 'Software'],
                      onSelected: (value) => setState(() => selectedErrorType = value),
                    ),
                    const SizedBox(height: 12),
                    const Text('Severity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    _buildFilterChip(
                      label: 'Severity',
                      value: selectedSeverity,
                      options: ['All Levels', 'CRITICAL', 'ERROR', 'WARNING', 'INFO'],
                      onSelected: (value) => setState(() => selectedSeverity = value),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetFilters,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1976D2),
                              side: const BorderSide(color: Color(0xFF1976D2)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _applyFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],

            // Content Area
            Expanded(
              child: _selectedTab == 0 ? _buildOverviewTab() : _buildListTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Severity Chart
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Errors by Severity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sections: _getSeverityChartData(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 30,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem('Critical', const Color(0xFFE53935), '30%'),
                              _buildLegendItem('Error', const Color(0xFFFF9800), '25%'),
                              _buildLegendItem('Warning', const Color(0xFFFFEB3B), '25%'),
                              _buildLegendItem('Info', const Color(0xFF42A5F5), '20%'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Charts Row
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'By Sensor Type',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: const BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const labels = ['VFD', 'Temp', 'Load', 'Rope', 'Manual'];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          labels[value.toInt()],
                                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              barGroups: _getSensorTypeChartData(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'By Error Type',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: const BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const labels = ['Mech', 'Elec', 'Safe', 'Soft'];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          labels[value.toInt()],
                                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              barGroups: _getErrorTypeChartData(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quick Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: selectedSeverity == null,
                  onSelected: (selected) => setState(() => selectedSeverity = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Critical'),
                  selected: selectedSeverity == 'CRITICAL',
                  onSelected: (selected) => setState(() => selectedSeverity = selected ? 'CRITICAL' : null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Errors'),
                  selected: selectedSeverity == 'ERROR',
                  onSelected: (selected) => setState(() => selectedSeverity = selected ? 'ERROR' : null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Warnings'),
                  selected: selectedSeverity == 'WARNING',
                  onSelected: (selected) => setState(() => selectedSeverity = selected ? 'WARNING' : null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) => _buildErrorCard(filteredLogs[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}