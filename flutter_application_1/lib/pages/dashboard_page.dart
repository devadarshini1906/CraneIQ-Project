import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../models/crane_model.dart';
import '../models/oee_model.dart';
// REMOVED: import 'professional_bot.dart'; - No longer needed here

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CraneStatus? filterStatus;

  final double totalPower = 19.8;
  final double currentDraw = 40.5;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final listedCranes = filterStatus == null ? mockCranes : mockCranes.where((c) => c.status == filterStatus).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(onItemSelected: (title) {
        // Navigation handled in sidebar
      }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A5F),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('CraneIQ', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          // Pro Plan icon container has been removed
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Dashboard Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Real-time view of all crane operations',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Quick Stats - Updated to 2x2 grid layout
              Container(
                width: double.infinity,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Quick Stats',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refreshing data...')));
                          },
                          icon: const Icon(Icons.refresh, color: Color(0xFF1E3A5F)),
                          iconSize: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 2x2 Grid Layout
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('Total Power', '${totalPower.toStringAsFixed(1)} kW', Icons.bolt, Colors.blue),
                        _buildStatCard('Current Draw', '${currentDraw.toStringAsFixed(1)} A', Icons.offline_bolt, Colors.orange),
                        _buildStatCard('Active Cranes', '${mockCranes.where((c) => c.status == CraneStatus.working).length}', Icons.build, Colors.green),
                        _buildStatCard('System Health', '92%', Icons.health_and_safety, Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // OEE Section - Updated to 2x2 grid layout
              Container(
                width: double.infinity,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Equipment Effectiveness',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                          ),
                        ),
                        Text('Updated today', style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 2x2 Grid Layout for OEE
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.1, // Reduced aspect ratio to prevent overflow
                      children: [
                        _buildOEECard('OEE', '${(mockOee.oee * 100).toInt()}%', mockOee.oee, Colors.indigo),
                        _buildOEECard('Availability', '${(mockOee.availability * 100).toInt()}%', mockOee.availability, Colors.blue),
                        _buildOEECard('Performance', '${(mockOee.performance * 100).toInt()}%', mockOee.performance, Colors.green),
                        _buildOEECard('Quality', '${(mockOee.quality * 100).toInt()}%', mockOee.quality, Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', null, const Color(0xFF1E3A5F)),
                    const SizedBox(width: 8),
                    _buildFilterChip('Working', CraneStatus.working, Colors.green),
                    const SizedBox(width: 8),
                    _buildFilterChip('Idle', CraneStatus.idle, Colors.orange),
                    const SizedBox(width: 8),
                    _buildFilterChip('Off', CraneStatus.off, Colors.grey),
                    const SizedBox(width: 8),
                    _buildFilterChip('Overload', CraneStatus.overload, Colors.red),
                    const SizedBox(width: 8),
                    _buildFilterChip('Errors', CraneStatus.error, Colors.purple),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Crane Cards
              Column(
                children: listedCranes.map((crane) => _buildCraneCard(crane)).toList(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOEECard(String title, String value, double percent, Color color) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding to prevent overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 55, // Slightly reduced size
                height: 55,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6), // Reduced spacing
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)), // Smaller font
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, CraneStatus? status, Color color) {
    final selected = filterStatus == status;
    return FilterChip(
      label: Text(label, style: TextStyle(color: selected ? Colors.white : color)),
      selected: selected,
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color,
      checkmarkColor: Colors.white,
      onSelected: (_) => setState(() => filterStatus = status),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildCraneCard(CraneModel crane) {
    final statusInfo = {
      CraneStatus.working: {'label': 'WORKING', 'color': Colors.green, 'icon': Icons.play_arrow},
      CraneStatus.idle: {'label': 'IDLE', 'color': Colors.orange, 'icon': Icons.pause},
      CraneStatus.off: {'label': 'OFF', 'color': Colors.grey, 'icon': Icons.power_off},
      CraneStatus.overload: {'label': 'OVERLOAD', 'color': Colors.red, 'icon': Icons.warning},
      CraneStatus.error: {'label': 'ERROR', 'color': Colors.purple, 'icon': Icons.error},
    };

    final info = statusInfo[crane.status]!;
    final color = info['color'] as Color;
    final icon = info['icon'] as IconData;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crane.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('ID: ${crane.id}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(info['label'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCraneMetric('Health', '${crane.health}%', Icons.health_and_safety),
              _buildCraneMetric('Load', '${crane.currentLoad}kg', Icons.fitness_center),
              _buildCraneMetric('Capacity', '${crane.capacity}kg', Icons.layers),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.devices, size: 14, color: Colors.black54),
              const SizedBox(width: 4),
              Text('Devices: ${crane.deviceIds.join(', ')}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const Spacer(),
              Text(_timeAgo(crane.updatedAt), style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCraneMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: Colors.black54),
              const SizedBox(width: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}