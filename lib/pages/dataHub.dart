// pages/dataHub.dart
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';  // Import the shared sidebar

class DataHubPage extends StatefulWidget {
  const DataHubPage({super.key});

  @override
  State<DataHubPage> createState() => _DataHubPageState();
}

class _DataHubPageState extends State<DataHubPage> {
  // Selected data points for linking
  Map<String, dynamic>? _selectedMachinePoint;
  Map<String, dynamic>? _selectedGatewayPoint;
  
  // List of connections
  final List<Map<String, dynamic>> _connections = [];

  // Sample data with actual values from the screenshot
  final List<Map<String, dynamic>> _machinePoints = [
    {'name': 'Load Weight', 'unit': 'kg', 'source': 'Crane-101', 'value': '4.2', 'id': 'load_weight'},
    {'name': 'Power Consumption', 'unit': 'kW', 'source': 'Crane-101', 'value': '--', 'id': 'power_consumption'},
    {'name': 'Motor Temperature', 'unit': '°C', 'source': 'Crane-101', 'value': '--', 'id': 'motor_temp'},
  ];

  final List<Map<String, dynamic>> _gatewayPoints = [
    {'name': 'Load Sensor', 'value': '425', 'unit': 'kg', 'source': 'Gateway-101', 'id': 'load_sensor'},
    {'name': 'Power Meter', 'value': '4.2', 'unit': 'kW', 'source': 'Gateway-101', 'id': 'power_meter'},
    {'name': 'Temp Sensor', 'value': '68.3', 'unit': '°C', 'source': 'Gateway-101', 'id': 'temp_sensor'},
  ];

  // Time series data for visualization
  final Map<String, List<double>> _timeSeriesData = {
    'load_weight': [4.2, 4.1, 4.3, 4.0, 4.2, 4.4, 4.1, 4.3, 4.2, 4.1],
  };

  void _createLink() {
    if (_selectedMachinePoint != null && _selectedGatewayPoint != null) {
      setState(() {
        _connections.add({
          'machinePoint': _selectedMachinePoint,
          'gatewayPoint': _selectedGatewayPoint,
        });
        
        // Update the machine point value with gateway data
        final machineIndex = _machinePoints.indexWhere(
          (point) => point['id'] == _selectedMachinePoint!['id']
        );
        
        if (machineIndex != -1) {
          _machinePoints[machineIndex]['value'] = _selectedGatewayPoint!['value'];
        }
        
        // Clear selections
        _selectedMachinePoint = null;
        _selectedGatewayPoint = null;
      });
    }
  }

  void _clearSelections() {
    setState(() {
      _selectedMachinePoint = null;
      _selectedGatewayPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              "CraneIQ",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.home, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Sidebar(onItemSelected: (title) {}),  // Add the sidebar as drawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Hub",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              "Monitor and manage machine data points in real-time",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildMachinesSection(isMobile),
            const SizedBox(height: 24),
            _buildGatewaysSection(isMobile),
            const SizedBox(height: 24),
            _buildDataPointLinking(isMobile),
            const SizedBox(height: 24),
            _buildDataVisualization(),
          ],
        ),
      ),
    );
  }

  Widget _buildMachinesSection(bool isMobile) {
    final machines = [
      {
        'name': 'Crane-101',
        'id': 'M-C101',
        'updated': '2 min ago',
        'gateways': 2,
        'points': 8,
        'online': true
      },
      {
        'name': 'Conveyor-205',
        'id': 'M-C205',
        'updated': '5 min ago',
        'gateways': 1,
        'points': 5,
        'online': true
      },
      {
        'name': 'Robotic Arm-307',
        'id': 'M-RA307',
        'updated': '1 day ago',
        'gateways': 1,
        'points': 6,
        'online': false
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Machines",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          isMobile
              ? Column(
                  children: machines.map((m) => _buildMachineCard(m)).toList(),
                )
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: machines.map((m) => _buildMachineCard(m)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildMachineCard(Map<String, dynamic> m) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: m['online'] ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: m['online'] ? Colors.blue : Colors.red),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.circle,
                size: 12, color: m['online'] ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            Text(m['name'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 6),
          Text("ID: ${m['id']}"),
          Text("Last updated: ${m['updated']}"),
          Text("Gateways: ${m['gateways']}"),
          Text("Data Points: ${m['points']}"),
        ],
      ),
    );
  }

  Widget _buildGatewaysSection(bool isMobile) {
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Connected Gateways",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          isMobile
              ? Column(
                  children: gateways.map((g) => _buildGatewayCard(g)).toList(),
                )
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: gateways.map((g) => _buildGatewayCard(g)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildGatewayCard(Map<String, dynamic> g) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: g['name'] == 'Gateway-102'
                ? Colors.purple
                : Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(g['name'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(Icons.circle,
                size: 12, color: g['online'] ? Colors.green : Colors.red),
            const SizedBox(width: 4),
            Text(g['online'] ? "Online" : "Offline",
                style: const TextStyle(color: Colors.grey)),
          ]),
          const SizedBox(height: 6),
          Text("IP: ${g['ip']}"),
          Text("Last seen: ${g['lastSeen']}"),
          Text("Data points: ${g['dataPoints']}"),
          Text("Connected to: ${g['connectedTo']}"),
        ],
      ),
    );
  }

  Widget _buildDataPointLinking(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Point Linking",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPointList("Machine Data Points", _machinePoints, true),
                    const SizedBox(height: 16),
                    _buildPointList("Gateway Data Points", _gatewayPoints, false),
                    const SizedBox(height: 16),
                    _buildConnectionBox(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildPointList("Machine Data Points", _machinePoints, true),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPointList("Gateway Data Points", _gatewayPoints, false),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildConnectionBox(),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_selectedMachinePoint != null || _selectedGatewayPoint != null)
                  ElevatedButton.icon(
                    onPressed: _clearSelections,
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _createLink,
                  icon: const Icon(Icons.link),
                  label: const Text("Create Link"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: 
                      (_selectedMachinePoint != null && _selectedGatewayPoint != null) 
                        ? Colors.blueAccent 
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPointList(String title, List<Map<String, dynamic>> list, bool isMachine) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...list.map((e) => _buildPointCard(e, isMachine)),
        ],
      ),
    );
  }

  Widget _buildPointCard(Map<String, dynamic> e, bool isMachine) {
    bool isSelected;
    if (isMachine) {
      isSelected = _selectedMachinePoint != null && _selectedMachinePoint!['id'] == e['id'];
    } else {
      isSelected = _selectedGatewayPoint != null && _selectedGatewayPoint!['id'] == e['id'];
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isMachine) {
            if (_selectedMachinePoint != null && _selectedMachinePoint!['id'] == e['id']) {
              _selectedMachinePoint = null;
            } else {
              _selectedMachinePoint = e;
            }
          } else {
            if (_selectedGatewayPoint != null && _selectedGatewayPoint!['id'] == e['id']) {
              _selectedGatewayPoint = null;
            } else {
              _selectedGatewayPoint = e;
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(e['value'].toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text(e['unit']),
                const Spacer(),
                const Icon(Icons.electrical_services, color: Colors.grey),
              ],
            ),
            Text(e['source'], style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionBox() {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, style: BorderStyle.solid)),
      child: SingleChildScrollView(
        child: _connections.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link, color: Colors.grey, size: 36),
                  SizedBox(height: 8),
                  Text(
                    "No connections yet. Select a machine data point and a gateway data point, then click \"Create Link\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Point Connections",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ..._connections.map((connection) => _buildConnectionCard(connection)),
              ],
            ),
      ),
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    final machinePoint = connection['machinePoint'];
    final gatewayPoint = connection['gatewayPoint'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      machinePoint['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${machinePoint['value']} ${machinePoint['unit']}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      machinePoint['source'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      gatewayPoint['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      "${gatewayPoint['value']} ${gatewayPoint['unit']}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      gatewayPoint['source'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataVisualization() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Visualization",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          if (_connections.isEmpty)
            const Center(
              child: Column(
                children: [
                  Icon(Icons.show_chart, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "No data connections yet. Create links between machine and gateway data points to see visualizations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildVisualizationChart(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisualizationChart() {
    // For this example, we'll show visualization for the first connection
    final firstConnection = _connections.first;
    final machinePoint = firstConnection['machinePoint'];
    final dataKey = machinePoint['id'];
    final data = _timeSeriesData[dataKey] ?? List.filled(10, 0.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${machinePoint['name']} (${machinePoint['unit']})",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: 600,  // Make it wider for horizontal scrolling on mobile
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("10"),
                  Text("8"),
                  Text("6"),
                  Text("4"),
                  Text("2"),
                  Text("0"),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(10, (index) {
                    final value = data[index];
                    final height = (value / 10) * 180; // Scale to fit container
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 20,
                                height: height.clamp(0, 180).toDouble(),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("${index + 1}s"),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("1s"),
            Text("2s"),
            Text("3s"),
            Text("4s"),
            Text("5s"),
            Text("6s"),
            Text("7s"),
            Text("8s"),
            Text("9s"),
            Text("10s"),
          ],
        ),
      ],
    );
  }
}