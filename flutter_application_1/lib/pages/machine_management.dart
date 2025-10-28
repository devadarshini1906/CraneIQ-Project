import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class MachineManagementPage extends StatefulWidget {
  const MachineManagementPage({super.key});

  @override
  State<MachineManagementPage> createState() => _MachineManagementPageState();
}

class _MachineManagementPageState extends State<MachineManagementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('CraneIQ', 
          style: TextStyle(
            fontSize: 18, // Reduced font size
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          )
        ),
        centerTitle: false,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 20), // Reduced icon size
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black87, size: 20), // Reduced icon size
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
      body: SafeArea( // Added SafeArea
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Machine Management',
                    style: TextStyle(
                      fontSize: 20, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4), // Reduced spacing
                  Text(
                    'Manage all machine configurations and details',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12, // Reduced font size
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16), // Reduced spacing
              
              // Action Buttons
              Wrap(
                spacing: 8, // Reduced spacing
                runSpacing: 8, // Reduced spacing
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateMachineTypeDialog(context);
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 16), // Reduced icon size
                    label: const Text('Create Machine Type', 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500) // Reduced font size
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6), // Reduced border radius
                      ),
                      elevation: 1,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddMachineDialog(context);
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 16), // Reduced icon size
                    label: const Text('Add Machine', 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500) // Reduced font size
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6), // Reduced border radius
                      ),
                      elevation: 1,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16), // Reduced spacing
              
              // Machines Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8), // Reduced border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3, // Reduced blur
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16, // Reduced spacing
                    dataRowMinHeight: 40, // Reduced height
                    dataRowMaxHeight: 40, // Reduced height
                    headingRowHeight: 40, // Reduced height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 12, // Reduced font size
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 12, // Reduced font size
                      color: Colors.black87,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('#', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      DataColumn(
                        label: Text('Machine Type', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      DataColumn(
                        label: Text('Machine ID', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      DataColumn(
                        label: Text('Manufacturer', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      DataColumn(
                        label: Text('Model', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      DataColumn(
                        label: Text('Actions', 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                    rows: const [
                      DataRow(
                        cells: [
                          DataCell(Text('')),
                          DataCell(
                            Center(
                              child: Text(
                                'No machines found. Add a machine to get started.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 11, // Reduced font size
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateMachineTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12), // Reduced padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced border radius
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16), // Reduced padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.build_circle_outlined, color: Colors.blue, size: 20), // Reduced icon size
                    const SizedBox(width: 8), // Reduced spacing
                    const Text(
                      'Machine Type Identification',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Machine Type Name
                const Text(
                  'Machine Type Name *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'e.g., Crane, Excavator, Foxlift',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Add Section Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16), // Reduced icon size
                    label: const Text('Add Section', style: TextStyle(fontSize: 12)), // Reduced font size
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6), // Reduced border radius
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
                    ),
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Basic Details Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12), // Reduced padding
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6), // Reduced border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Reduced font size
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12), // Reduced spacing
                      // Machine ID and IoT Gateway fields
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Machine ID', style: TextStyle(fontSize: 11, color: Colors.grey)), // Reduced font size
                              const SizedBox(height: 4),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter machine ID',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                                  isDense: true, // Added to reduce height
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // Reduced spacing
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('IoT Gateway', style: TextStyle(fontSize: 11, color: Colors.grey)), // Reduced font size
                              const SizedBox(height: 4),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter IoT gateway',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                                  isDense: true, // Added to reduce height
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Reduced spacing
                      // Add Field Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showAddFieldDialog(context);
                          },
                          icon: const Icon(Icons.add, size: 14), // Reduced icon size
                          label: const Text('Add Field', style: TextStyle(fontSize: 11)), // Reduced font size
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                            minimumSize: Size.zero, // Added to reduce size
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Data Point Details Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12), // Reduced padding
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6), // Reduced border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Point Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Reduced font size
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8), // Reduced spacing
                      const Text('Configure data points for this machine type...', 
                        style: TextStyle(color: Colors.grey, fontSize: 12) // Reduced font size
                      ),
                      const SizedBox(height: 8), // Reduced spacing
                      // Add Field Button for Data Points
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showAddFieldDialog(context);
                          },
                          icon: const Icon(Icons.add, size: 14), // Reduced icon size
                          label: const Text('Add Field', style: TextStyle(fontSize: 11)), // Reduced font size
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                            minimumSize: Size.zero, // Added to reduce size
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Action Buttons
                Wrap(
                  spacing: 8, // Reduced spacing
                  runSpacing: 8, // Reduced spacing
                  alignment: WrapAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced border radius
                        ),
                      ),
                      child: const Text('Save Machine Type', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced border radius
                        ),
                      ),
                      child: const Text('View Existing Types', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddMachineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12), // Reduced padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced border radius
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16), // Reduced padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.green, size: 20), // Reduced icon size
                    const SizedBox(width: 8), // Reduced spacing
                    const Text(
                      'Machine Configuration',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Machine Type Dropdown
                const Text(
                  'Machine Type *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'select',
                      child: Text('- Select Machine Type -', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                  onChanged: (value) {},
                  initialValue: 'select',
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Divider
                const Divider(height: 1, color: Colors.grey),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Sections
                const Text(
                  'Sections',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Reduced font size
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Select All Sections
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const Text('Select All Sections', style: TextStyle(fontSize: 12)), // Reduced font size
                  ],
                ),
                
                // Fields Section
                Container(
                  margin: const EdgeInsets.only(left: 24), // Reduced margin
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text(
                            'Fields',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), // Reduced font size
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 24), // Reduced margin
                        child: Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Text('Select All Fields', style: TextStyle(fontSize: 11)), // Reduced font size
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24), // Reduced spacing
                
                // Action Buttons
                Wrap(
                  spacing: 8, // Reduced spacing
                  runSpacing: 8, // Reduced spacing
                  alignment: WrapAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced border radius
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced border radius
                        ),
                      ),
                      child: const Text('Save Configuration', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12), // Reduced padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced border radius
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16), // Reduced padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.add_box_outlined, color: Colors.blue, size: 20), // Reduced icon size
                    const SizedBox(width: 8), // Reduced spacing
                    const Text(
                      'Add New Field to Basic Details',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Section Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(5), // Reduced border radius
                  ),
                  child: const Text(
                    'A Basic Information',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: 13, // Reduced font size
                    ),
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Field Name
                const Text(
                  'Field Name *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter field name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter field description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Divider
                const Divider(height: 1, color: Colors.grey),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Data Configuration Section
                const Text(
                  'Data Configuration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Reduced font size
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Data Type
                const Text(
                  'Data Type *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'text',
                      child: Text('Text', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                  onChanged: (value) {},
                  initialValue: 'text',
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Length/Precision
                const Text(
                  'Length/Precision',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter length',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                ),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Divider
                const Divider(height: 1, color: Colors.grey),
                
                const SizedBox(height: 16), // Reduced spacing
                
                // Data Feed Configuration
                const Text(
                  'Data Feed Configuration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Reduced font size
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12), // Reduced spacing
                
                // Feed Type
                const Text(
                  'Feed Type *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13, // Reduced font size
                  ),
                ),
                const SizedBox(height: 6), // Reduced spacing
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                    isDense: true, // Added to reduce height
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'manual',
                      child: Text('Manual Input', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                  onChanged: (value) {},
                  initialValue: 'manual',
                ),
                
                const SizedBox(height: 24), // Reduced spacing
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                    const SizedBox(width: 8), // Reduced spacing
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced border radius
                        ),
                      ),
                      child: const Text('Add Field', style: TextStyle(fontSize: 12)), // Reduced font size
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}