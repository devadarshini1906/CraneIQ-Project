// pages/dataHub.dart
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class DataHubPage extends StatefulWidget {
  const DataHubPage({super.key});

  @override
  State<DataHubPage> createState() => _DataHubPageState();
}

class _DataHubPageState extends State<DataHubPage> {
  Map<String, dynamic>? _selectedMachinePoint;
  Map<String, dynamic>? _selectedGatewayPoint;
  final List<Map<String, dynamic>> _connections = [];
  int _currentTab = 0; // 0: Overview, 1: Linking, 2: Visualization
  int _selectedConnectionIndex = 0; // For visualization tab

  // Enhanced sample data
  final List<Map<String, dynamic>> _machinePoints = [
    {
      'name': 'Load Weight', 
      'unit': 'kg', 
      'source': 'Crane-101', 
      'value': '4.2', 
      'id': 'load_weight',
      'icon': Icons.fitness_center,
      'color': Colors.blue,
    },
    {
      'name': 'Power Consumption', 
      'unit': 'kW', 
      'source': 'Crane-101', 
      'value': '--', 
      'id': 'power_consumption',
      'icon': Icons.bolt,
      'color': Colors.orange,
    },
    {
      'name': 'Motor Temperature', 
      'unit': '°C', 
      'source': 'Crane-101', 
      'value': '--', 
      'id': 'motor_temp',
      'icon': Icons.thermostat,
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _gatewayPoints = [
    {
      'name': 'Load Sensor', 
      'value': '425', 
      'unit': 'kg', 
      'source': 'Gateway-101', 
      'id': 'load_sensor',
      'icon': Icons.sensors,
      'color': Colors.green,
    },
    {
      'name': 'Power Meter', 
      'value': '4.2', 
      'unit': 'kW', 
      'source': 'Gateway-101', 
      'id': 'power_meter',
      'icon': Icons.electric_bolt,
      'color': Colors.purple,
    },
    {
      'name': 'Temp Sensor', 
      'value': '68.3', 
      'unit': '°C', 
      'source': 'Gateway-101', 
      'id': 'temp_sensor',
      'icon': Icons.device_thermostat,
      'color': Colors.amber,
    },
  ];

  final Map<String, List<double>> _timeSeriesData = {
    'load_weight': [4.2, 4.1, 4.3, 4.0, 4.2, 4.4, 4.1, 4.3, 4.2, 4.1],
    'power_consumption': [4.2, 4.3, 4.1, 4.4, 4.2, 4.0, 4.3, 4.1, 4.2, 4.3],
    'motor_temp': [68.3, 68.5, 68.1, 68.7, 68.4, 68.2, 68.6, 68.3, 68.5, 68.4],
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _createLink() {
    if (_selectedMachinePoint != null && _selectedGatewayPoint != null) {
      setState(() {
        _connections.add({
          'machinePoint': _selectedMachinePoint,
          'gatewayPoint': _selectedGatewayPoint,
          'timestamp': DateTime.now(),
        });
        
        final machineIndex = _machinePoints.indexWhere(
          (point) => point['id'] == _selectedMachinePoint!['id']
        );
        
        if (machineIndex != -1) {
          _machinePoints[machineIndex]['value'] = _selectedGatewayPoint!['value'];
        }
        
        _selectedMachinePoint = null;
        _selectedGatewayPoint = null;
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data points linked successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  void _clearSelections() {
    setState(() {
      _selectedMachinePoint = null;
      _selectedGatewayPoint = null;
    });
  }

  void _deleteConnection(int index) {
    setState(() {
      _connections.removeAt(index);
      if (_selectedConnectionIndex >= _connections.length) {
        _selectedConnectionIndex = _connections.isEmpty ? 0 : _connections.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        title: const Text(
          "Data Hub",
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF1E3A5F)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ],
      ),
      drawer: Sidebar(onItemSelected: (title) {
        // Handle sidebar item selection if needed
        print('Selected: $title');
      }),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab(0, 'Overview', Icons.dashboard),
                  _buildTab(1, 'Data Linking', Icons.link),
                  _buildTab(2, 'Visualization', Icons.analytics),
                ],
              ),
            ),
          ),
          
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentTab(),
            ),
          ),
        ],
      ),
      
      // Floating Action Button for Quick Actions
      floatingActionButton: _currentTab == 1 ? FloatingActionButton(
        onPressed: _createLink,
        backgroundColor: 
          (_selectedMachinePoint != null && _selectedGatewayPoint != null) 
            ? Colors.blueAccent 
            : Colors.grey,
        child: const Icon(Icons.link, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildTab(int tabIndex, String title, IconData icon) {
    final isSelected = _currentTab == tabIndex;
    
    return GestureDetector(
      onTap: () => setState(() => _currentTab = tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, 
                size: 18, 
                color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildLinkingTab();
      case 2:
        return _buildVisualizationTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Stats
        _buildQuickStats(),
        const SizedBox(height: 20),
        
        // Machines Section
        _buildSectionHeader('Machines', Icons.precision_manufacturing),
        const SizedBox(height: 12),
        _buildMachinesGrid(),
        const SizedBox(height: 20),
        
        // Gateways Section
        _buildSectionHeader('Gateways', Icons.sensors),
        const SizedBox(height: 12),
        _buildGatewaysGrid(),
        const SizedBox(height: 20),
        
        // Recent Connections
        _buildSectionHeader('Recent Connections', Icons.history),
        const SizedBox(height: 12),
        _buildRecentConnections(),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Connected Machines', '3', Icons.precision_manufacturing, Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Active Gateways', '2', Icons.sensors, Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Data Links', _connections.length.toString(), Icons.link, Colors.orange),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMachinesGrid() {
    final machines = [
      {
        'name': 'Crane-101',
        'id': 'M-C101',
        'updated': '2 min ago',
        'gateways': 2,
        'points': 8,
        'online': true,
        'icon': Icons.build,
      },
      {
        'name': 'Conveyor-205',
        'id': 'M-C205',
        'updated': '5 min ago',
        'gateways': 1,
        'points': 5,
        'online': true,
        'icon': Icons.move_to_inbox,
      },
      {
        'name': 'Robotic Arm-307',
        'id': 'M-RA307',
        'updated': '1 day ago',
        'gateways': 1,
        'points': 6,
        'online': false,
        'icon': Icons.construction,
      },
    ];

    return Column(
      children: machines.map((machine) => _buildMachineListItem(machine)).toList(),
    );
  }

  Widget _buildMachineListItem(Map<String, dynamic> machine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: machine['online'] ? Colors.blue.shade50 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(machine['icon'] ?? Icons.device_hub, 
                color: machine['online'] ? Colors.blue : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(machine['name'], 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Icon(Icons.circle, 
                        size: 8, 
                        color: machine['online'] ? Colors.green : Colors.red),
                  ],
                ),
                Text('ID: ${machine['id']}', 
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(machine['updated'], 
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text('${machine['points']} points', 
                  style: const TextStyle(fontSize: 12, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGatewaysGrid() {
    final gateways = [
      {
        'name': 'Gateway-101',
        'ip': '192.168.1.101',
        'lastSeen': '2 min ago',
        'dataPoints': 12,
        'connectedTo': 'Crane-101',
        'online': true,
      },
      {
        'name': 'Gateway-102',
        'ip': '192.168.1.102',
        'lastSeen': '5 min ago',
        'dataPoints': 8,
        'connectedTo': 'Crane-101',
        'online': true,
      },
    ];

    return Column(
      children: gateways.map((gateway) => _buildGatewayListItem(gateway)).toList(),
    );
  }

  Widget _buildGatewayListItem(Map<String, dynamic> gateway) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gateway['online'] ? Colors.green.shade100 : Colors.red.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: gateway['online'] ? Colors.green.shade50 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.sensors, 
                color: gateway['online'] ? Colors.green : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gateway['name'], 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(gateway['ip'], 
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, 
                      size: 8, 
                      color: gateway['online'] ? Colors.green : Colors.red),
                  const SizedBox(width: 4),
                  Text(gateway['online'] ? 'Online' : 'Offline',
                      style: TextStyle(
                          fontSize: 12,
                          color: gateway['online'] ? Colors.green : Colors.red)),
                ],
              ),
              Text('${gateway['dataPoints']} points',
                  style: const TextStyle(fontSize: 12, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentConnections() {
    if (_connections.isEmpty) {
      return _buildEmptyState(
        Icons.link_off,
        'No connections yet',
        'Create your first data link to see connections here',
      );
    }

    final recentConnections = _connections.take(3).toList();

    return Column(
      children: recentConnections.map((connection) => 
        _buildConnectionListItem(connection)
      ).toList(),
    );
  }

  Widget _buildConnectionListItem(Map<String, dynamic> connection) {
    final machine = connection['machinePoint'];
    final gateway = connection['gatewayPoint'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.link, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${machine['name']} → ${gateway['name']}',
                    style: const TextStyle(fontSize: 12)),
                Text('${machine['value']} ${machine['unit']}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Text(
            _formatTimeAgo(connection['timestamp']),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Data Point Linking', Icons.link),
        const SizedBox(height: 16),
        
        // Selection Status
        if (_selectedMachinePoint != null || _selectedGatewayPoint != null)
          _buildSelectionStatus(),
        
        const SizedBox(height: 16),
        
        // Data Points Grid
        Column(
          children: [
            _buildDataPointsSection('Machine Data Points', _machinePoints, true),
            const SizedBox(height: 16),
            _buildDataPointsSection('Gateway Data Points', _gatewayPoints, false),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Connections List
        _buildConnectionsList(),
      ],
    );
  }

  Widget _buildSelectionStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedMachinePoint != null)
                  Text('Selected Machine: ${_selectedMachinePoint!['name']}',
                      style: TextStyle(color: Colors.blue.shade800)),
                if (_selectedGatewayPoint != null)
                  Text('Selected Gateway: ${_selectedGatewayPoint!['name']}',
                      style: TextStyle(color: Colors.blue.shade800)),
              ],
            ),
          ),
          if (_selectedMachinePoint != null && _selectedGatewayPoint != null)
            Text('Ready to Link', 
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDataPointsSection(String title, List<Map<String, dynamic>> points, bool isMachine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: points.map((point) => _buildDataPointChip(point, isMachine)).toList(),
        ),
      ],
    );
  }

  Widget _buildDataPointChip(Map<String, dynamic> point, bool isMachine) {
    bool isSelected;
    if (isMachine) {
      isSelected = _selectedMachinePoint != null && _selectedMachinePoint!['id'] == point['id'];
    } else {
      isSelected = _selectedGatewayPoint != null && _selectedGatewayPoint!['id'] == point['id'];
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isMachine) {
            _selectedMachinePoint = _selectedMachinePoint?['id'] == point['id'] ? null : point;
          } else {
            _selectedGatewayPoint = _selectedGatewayPoint?['id'] == point['id'] ? null : point;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? point['color'].withOpacity(0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? point['color'] : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(point['icon'], size: 16, color: point['color']),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(point['name'], 
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? point['color'] : Colors.black87)),
                Text('${point['value']} ${point['unit']}', 
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionsList() {
    if (_connections.isEmpty) {
      return _buildEmptyState(
        Icons.link_off,
        'No Data Links',
        'Select one machine data point and one gateway data point to create your first link',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Active Connections (${_connections.length})', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _connections.clear();
                  _selectedConnectionIndex = 0;
                });
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._connections.asMap().entries.map((entry) => 
          _buildConnectionCard(entry.value, entry.key)
        ),
      ],
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection, int index) {
    final machine = connection['machinePoint'];
    final gateway = connection['gatewayPoint'];

    return Dismissible(
      key: Key(connection['timestamp'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.red.shade400),
      ),
      onDismissed: (direction) => _deleteConnection(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: machine['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(machine['icon'], color: machine['color'], size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(machine['name'], 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${machine['value']} ${machine['unit']}', 
                      style: TextStyle(color: machine['color'])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: gateway['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(gateway['icon'], color: gateway['color'], size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gateway['name'], 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${gateway['value']} ${gateway['unit']}', 
                      style: TextStyle(color: gateway['color'])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationTab() {
    if (_connections.isEmpty) {
      return _buildEmptyState(
        Icons.analytics_outlined,
        'No Data to Visualize',
        'Create data links between machine and gateway points to see visualizations',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Live Data Visualization', Icons.analytics),
        const SizedBox(height: 16),
        
        // Connection Selector
        _buildConnectionSelector(),
        const SizedBox(height: 20),
        
        // Visualization Chart
        _buildInteractiveChart(),
      ],
    );
  }

  Widget _buildConnectionSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _connections.asMap().entries.map((entry) {
          final connection = entry.value;
          final machine = connection['machinePoint'];
          final isSelected = entry.key == _selectedConnectionIndex;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(machine['name']),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedConnectionIndex = entry.key;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInteractiveChart() {
    if (_connections.isEmpty) return Container();
    
    final connection = _connections[_selectedConnectionIndex];
    final machinePoint = connection['machinePoint'];
    final dataKey = machinePoint['id'];
    final data = _timeSeriesData[dataKey] ?? List.filled(10, 0.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Icon(machinePoint['icon'], color: machinePoint['color']),
              const SizedBox(width: 8),
              Text(machinePoint['name'], 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Live', 
                    style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _LineChartPainter(data, machinePoint['color']),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartStats(data, machinePoint),
        ],
      ),
    );
  }

  Widget _buildChartStats(List<double> data, Map<String, dynamic> point) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final avgVal = data.reduce((a, b) => a + b) / data.length;

    return Row(
      children: [
        _buildStatItem('Max', '$maxVal ${point['unit']}', Icons.arrow_upward),
        const SizedBox(width: 16),
        _buildStatItem('Min', '$minVal ${point['unit']}', Icons.arrow_downward),
        const SizedBox(width: 16),
        _buildStatItem('Avg', '${avgVal.toStringAsFixed(1)} ${point['unit']}', Icons.show_chart),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _LineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final points = _calculatePoints(size);
    
    // Draw filled area
    final path = Path();
    path.moveTo(points.first.dx, size.height);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, size.height);
    path.close();
    canvas.drawPath(path, fillPaint);

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 3, paint..style = PaintingStyle.fill);
    }
  }

  List<Offset> _calculatePoints(Size size) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);

    return data.asMap().entries.map((entry) {
      final x = (entry.key / (data.length - 1)) * size.width;
      final y = size.height - ((entry.value - minVal) / range) * size.height * 0.8;
      return Offset(x, y);
    }).toList();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}