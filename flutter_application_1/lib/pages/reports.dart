import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<Map<String, dynamic>> summaryStats = [
    {
      'icon': Icons.insert_drive_file,
      'value': '142',
      'label': 'Reports Generated\nThis Month'
    },
    {
      'icon': Icons.pie_chart,
      'value': '3.2MB',
      'label': 'Avg. Report Size\nPDF format'
    },
    {
      'icon': Icons.schedule,
      'value': '8',
      'label': 'Scheduled Reports\nActive'
    },
    {
      'icon': Icons.warning_amber,
      'value': '24',
      'label': 'Alert Reports\nThis Week'
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
    {
      'icon': Icons.add,
      'label': 'Create New Report'
    },
    {
      'icon': Icons.access_time,
      'label': 'Schedule Report'
    },
    {
      'icon': Icons.star_border,
      'label': 'Save as Template'
    },
    {
      'icon': Icons.share,
      'label': 'Share Reports'
    },
    {
      'icon': Icons.settings,
      'label': 'Report Settings'
    },
    {
      'icon': Icons.help_outline,
      'label': 'Help Guide'
    },
  ];

  final List<Map<String, dynamic>> reports = [
    {
      'title': 'Operations Log',
      'desc': 'Detailed chronological log of all crane operations including hoisting, lowering, and travel movements.',
      'lastRun': '2 hours ago',
      'size': '1.4MB'
    },
    {
      'title': 'Load Analysis',
      'desc': 'Comprehensive report on load weights, distribution, and overload incidents with visual charts.',
      'lastRun': '1 day ago',
      'size': '2.1MB'
    },
    {
      'title': 'Error Summary',
      'desc': 'Aggregated error events with frequency analysis and resolution tracking.',
      'lastRun': '3 hours ago',
      'size': '0.8MB'
    },
    {
      'title': 'Performance Trends',
      'desc': 'Visualization of crane performance metrics over time with comparative analysis.',
      'lastRun': '1 week ago',
      'size': '3.5MB'
    },
    {
      'title': 'Voltage Analysis',
      'desc': 'Detailed report on voltage fluctuations and electrical system performance.',
      'lastRun': '2 days ago',
      'size': '1.7MB'
    },
    {
      'title': 'Temperature Report',
      'desc': 'Motor temperature trends and overheating incidents with recommendations.',
      'lastRun': '4 hours ago',
      'size': '1.2MB'
    },
  ];

  final List<Map<String, dynamic>> recentReports = [
    {
      'id': 'RPT-20230615-001',
      'type': 'Operations Log',
      'tag': 'Standard',
      'dateRange': 'Jun 1–15, 2023',
      'cranes': 'All Cranes',
      'generatedOn': 'Jun 15, 2023 09:45',
      'status': 'READY'
    },
    {
      'id': 'RPT-20230614-002',
      'type': 'Load Analysis',
      'tag': 'Custom',
      'dateRange': 'Jun 1–14, 2023',
      'cranes': 'CRN-001, CRN-002',
      'generatedOn': 'Jun 14, 2023 14:30',
      'status': 'READY'
    },
    {
      'id': 'RPT-20230615-003',
      'type': 'Error Summary',
      'tag': 'Scheduled',
      'dateRange': 'Jun 10–15, 2023',
      'cranes': 'CRN-003',
      'generatedOn': 'Jun 15, 2023 11:20',
      'status': 'PROCESSING'
    },
    {
      'id': 'RPT-20230613-004',
      'type': 'Voltage Analysis',
      'tag': 'Standard',
      'dateRange': 'Jun 1–13, 2023',
      'cranes': 'All Cranes',
      'generatedOn': 'Jun 13, 2023 16:45',
      'status': 'FAILED'
    },
    {
      'id': 'RPT-20230612-005',
      'type': 'Performance Trends',
      'tag': 'Custom',
      'dateRange': 'May 1–Jun 12, 2023',
      'cranes': 'CRN-002, CRN-004',
      'generatedOn': 'Jun 12, 2023 10:15',
      'status': 'READY'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFD),
      drawer: Sidebar(onItemSelected: (title) {
        // Navigation handled in Sidebar
      }),
      appBar: AppBar(
        title: const Text(
          'Reports & Analytics',
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
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/dashboard', 
                (route) => false
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),

            // Summary Stats
            _buildSummaryStats(),
            const SizedBox(height: 20),

            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 20),

            // Report Templates
            _buildReportTemplates(),
            const SizedBox(height: 20),

            // Filter Section
            _buildFilterSection(),
            const SizedBox(height: 20),

            // Recent Reports
            _buildRecentReports(),
            const SizedBox(height: 20),
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
              child: const Icon(Icons.analytics, color: Color(0xFF1E3A5F), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Reports & Data Export",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Generate, analyze, and export crane operation data",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSummaryStats() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3, // Reduced aspect ratio significantly
      ),
      itemCount: summaryStats.length,
      itemBuilder: (context, index) {
        final stat = summaryStats[index];
        final icon = stat['icon'] as IconData;
        final value = stat['value'] as String;
        final label = stat['label'] as String;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10), // Reduced padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4), // Smaller padding
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF1E3A5F), size: 16), // Smaller icon
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9, // Much smaller font
                    color: Colors.black54,
                    height: 1.1, // Tighter line height
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
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
            "Quick Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85, // Adjusted aspect ratio
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              final icon = action['icon'] as IconData;
              final label = action['label'] as String;

              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: const Color(0xFF1E3A5F), size: 20), // Smaller icon
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 9, // Smaller font
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Report Templates",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            final title = report['title'] as String;
            final desc = report['desc'] as String;
            final lastRun = report['lastRun'] as String;
            final size = report['size'] as String;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Last run: $lastRun",
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      const Spacer(),
                      Text(
                        "Size: $size",
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text(
                            'Generate',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E3A5F),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text(
                            'Preview',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    String reportType = 'Operations Log';
    String timeRange = 'Today';
    String craneSelection = 'All Cranes';
    String reportFormat = 'PDF (Portable Document)';

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
            "Generate Custom Report",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildReportFilterRow('Report Type', reportType, ['Operations Log', 'Load Analysis', 'Error Summary']),
              const SizedBox(height: 12),
              _buildReportFilterRow('Time Range', timeRange, ['Today', 'This Week', 'This Month']),
              const SizedBox(height: 12),
              _buildReportFilterRow('Crane Selection', craneSelection, ['All Cranes', 'CRN-001', 'CRN-002']),
              const SizedBox(height: 12),
              _buildReportFilterRow('Report Format', reportFormat, ['PDF (Portable Document)', 'Excel (Spreadsheet)']),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text(
                    "Generate Report",
                    style: TextStyle(fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text(
                    "Preview",
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportFilterRow(String label, String value, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option, 
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              // Handle filter change
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReports() {
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
            "Recent Reports",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              dataRowMinHeight: 35,
              headingRowHeight: 35,
              columns: const [
                DataColumn(
                  label: Text(
                    'Report ID', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
                DataColumn(
                  label: Text(
                    'Type', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
                DataColumn(
                  label: Text(
                    'Date Range', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
                DataColumn(
                  label: Text(
                    'Cranes', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
                DataColumn(
                  label: Text(
                    'Generated On', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
                DataColumn(
                  label: Text(
                    'Status', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  )
                ),
              ],
              rows: recentReports.map((report) {
                final id = report['id'] as String;
                final type = report['type'] as String;
                final dateRange = report['dateRange'] as String;
                final cranes = report['cranes'] as String;
                final generatedOn = report['generatedOn'] as String;
                final status = report['status'] as String;

                return DataRow(cells: [
                  DataCell(Text(id, style: const TextStyle(fontSize: 11))),
                  DataCell(Text(type, style: const TextStyle(fontSize: 11))),
                  DataCell(Text(dateRange, style: const TextStyle(fontSize: 11))),
                  DataCell(Text(cranes, style: const TextStyle(fontSize: 11))),
                  DataCell(Text(generatedOn, style: const TextStyle(fontSize: 11))),
                  DataCell(_buildStatusTag(status)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color color;
    switch (status) {
      case 'READY':
        color = Colors.green;
        break;
      case 'PROCESSING':
        color = Colors.orange;
        break;
      case 'FAILED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}