import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class GatewayManagementPage extends StatefulWidget {
  const GatewayManagementPage({super.key});

  @override
  State<GatewayManagementPage> createState() => _GatewayManagementPageState();
}

class _GatewayManagementPageState extends State<GatewayManagementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Gateway> _gateways = [
    Gateway(
      name: 'Main Gateway',
      deviceToken: 'tok_abc123def456',
      protocol: 'MQTT',
      status: GatewayStatus.online,
    ),
    Gateway(
      name: 'Field Gateway A',
      deviceToken: 'tok_mno345pqr678',
      protocol: 'MQTT',
      status: GatewayStatus.online,
    ),
    Gateway(
      name: 'Backup Gateway',
      deviceToken: 'tok_ghi789jk012',
      protocol: 'HTTP',
      status: GatewayStatus.offline,
    ),
  ];

  void _showCreateGatewayGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateGatewayGroupModal(),
    );
  }

  void _showCreateGatewayType() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateGatewayTypeModal(),
    );
  }

  void _showAddGateway() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddGatewayModal(),
    );
  }

  void _showAddField() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFieldModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('CraneIQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Reduced font size
        centerTitle: false,
        elevation: 0,
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Section
                _buildHeaderSection(),
                const SizedBox(height: 20), // Reduced spacing
                
                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 20), // Reduced spacing
                
                // Gateways List
                _buildGatewaysList(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gateway Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22, // Reduced font size
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage all IoT Gateways and their configurations',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13, // Reduced font size
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10, // Reduced spacing
      runSpacing: 10, // Reduced spacing
      children: [
        _buildActionButton(
          icon: Icons.add,
          label: 'Add Gateway Type',
          color: Colors.blue,
          onTap: _showCreateGatewayType,
        ),
        _buildActionButton(
          icon: Icons.add,
          label: 'Add Gateway',
          color: Colors.blue,
          onTap: _showAddGateway,
        ),
        _buildActionButton(
          icon: Icons.group,
          label: 'Group Gateways',
          color: Colors.purple,
          onTap: _showCreateGatewayGroup,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // Reduced padding
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10), // Reduced border radius
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16), // Reduced icon size
            const SizedBox(width: 6), // Reduced spacing
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, // Reduced font size
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatewaysList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gateways',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16, // Reduced font size
          ),
        ),
        const SizedBox(height: 10), // Reduced spacing
        ..._gateways.asMap().entries.map((entry) {
          final index = entry.key;
          final gateway = entry.value;
          return _buildGatewayCard(gateway, index + 1);
        }),
      ],
    );
  }

  Widget _buildGatewayCard(Gateway gateway, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10), // Reduced margin
      child: Padding(
        padding: const EdgeInsets.all(14), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with index and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5), // Reduced border radius
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      fontSize: 11, // Reduced font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusIndicator(gateway.status),
              ],
            ),
            const SizedBox(height: 10), // Reduced spacing
            
            // Gateway details
            _buildDetailRow('Gateway Name', gateway.name),
            _buildDetailRow('Device Token', gateway.deviceToken),
            _buildDetailRow('Protocol', gateway.protocol),
            const SizedBox(height: 14), // Reduced spacing
            
            // Action buttons
            _buildActionButtonsRow(gateway),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(GatewayStatus status) {
    final isOnline = status == GatewayStatus.online;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Reduced padding
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(10), // Reduced border radius
        border: Border.all(
          color: isOnline ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: isOnline ? Colors.green : Colors.red,
            size: 7, // Reduced icon size
          ),
          const SizedBox(width: 5), // Reduced spacing
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
              fontSize: 11, // Reduced font size
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90, // Reduced width
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13, // Reduced font size
              ),
            ),
          ),
          const SizedBox(width: 6), // Reduced spacing
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13, // Reduced font size
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow(Gateway gateway) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallButton(
            label: 'Edit',
            color: Colors.orange,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 6), // Reduced spacing
        Expanded(
          child: _buildSmallButton(
            label: 'Command',
            color: Colors.purple,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 6), // Reduced spacing
        Expanded(
          child: _buildSmallButton(
            label: 'Delete',
            color: Colors.red,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 6), // Reduced padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Reduced border radius
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11), // Reduced font size
      ),
    );
  }
}

// Modal for Create Gateway Group
class CreateGatewayGroupModal extends StatefulWidget {
  const CreateGatewayGroupModal({super.key});

  @override
  State<CreateGatewayGroupModal> createState() => _CreateGatewayGroupModalState();
}

class _CreateGatewayGroupModalState extends State<CreateGatewayGroupModal> {
  final _groupNameController = TextEditingController();
  final _selectedGateways = <String>{};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Reduced padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Reduced border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          Text(
            'Create Gateway Group',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Reduced font size
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Group Name
          _buildSectionTitle('Group Name'),
          TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: 'Enter group name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 16), // Reduced spacing
          
          // Gateways Selection
          _buildSectionTitle('Select Gateways to Include'),
          _buildGatewayCheckbox('Main Gateway'),
          _buildGatewayCheckbox('Field Gateway A'),
          _buildGatewayCheckbox('Backup Gateway'),
          const SizedBox(height: 16), // Reduced spacing
          
          // Device Tokens Preview
          _buildSectionTitle('Device Token'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10), // Reduced border radius
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('tok_abc123def45', style: TextStyle(fontSize: 12)), // Reduced font size
                Text('tok_mno345pqr6', style: TextStyle(fontSize: 12)), // Reduced font size
                Text('tok_ghi789jk1012', style: TextStyle(fontSize: 12)), // Reduced font size
              ],
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
              const SizedBox(width: 10), // Reduced spacing
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Save Group', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6), // Reduced padding
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14, // Reduced font size
        ),
      ),
    );
  }

  Widget _buildGatewayCheckbox(String gatewayName) {
    return CheckboxListTile(
      title: Text(gatewayName, style: TextStyle(fontSize: 13)), // Reduced font size
      value: _selectedGateways.contains(gatewayName),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedGateways.add(gatewayName);
          } else {
            _selectedGateways.remove(gatewayName);
          }
        });
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

// Modal for Create Gateway Type
class CreateGatewayTypeModal extends StatefulWidget {
  const CreateGatewayTypeModal({super.key});

  @override
  State<CreateGatewayTypeModal> createState() => _CreateGatewayTypeModalState();
}

class _CreateGatewayTypeModalState extends State<CreateGatewayTypeModal> {
  final _gatewayTypeNameController = TextEditingController();
  final _gatewayNameController = TextEditingController();
  final _deviceTokenController = TextEditingController();
  String? _selectedProtocol;

  void _showAddField() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Added to prevent overflow
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFieldModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Reduced padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Reduced border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          Text(
            'Create New Gateway Type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Reduced font size
            ),
          ),
          const SizedBox(height: 6), // Reduced spacing
          Text(
            'Define a new gateway type and its premises',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13), // Reduced font size
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Gateway Type Identification
          _buildSectionTitle('Gateway Type Identification'),
          TextField(
            controller: _gatewayTypeNameController,
            decoration: const InputDecoration(
              hintText: 'e.g., MC3T Gateway, HTTP Gateway',
              border: OutlineInputBorder(),
              labelText: 'Gateway Type Name *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 16), // Reduced spacing
          
          // Add Section Button
          _buildAddSectionButton('Add Section'),
          const SizedBox(height: 16), // Reduced spacing
          
          // Basic Details Section
          _buildSectionTitle('Basic Details'),
          TextField(
            controller: _gatewayNameController,
            decoration: const InputDecoration(
              hintText: 'Enter gateway name',
              border: OutlineInputBorder(),
              labelText: 'Gateway Name *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 10), // Reduced spacing
          TextField(
            controller: _deviceTokenController,
            decoration: const InputDecoration(
              hintText: 'admin@ccnweb.com',
              border: OutlineInputBorder(),
              labelText: 'Device Token *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 16), // Reduced spacing
          
          // Protocol Details
          _buildSectionTitle('Protocol Details'),
          DropdownButtonFormField<String>(
            initialValue: _selectedProtocol,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Protocol *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
            items: ['MQTT', 'HTTP', 'CoAP', 'WebSocket']
                .map((protocol) => DropdownMenuItem(
                      value: protocol,
                      child: Text(protocol, style: TextStyle(fontSize: 13)), // Reduced font size
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedProtocol = value;
              });
            },
          ),
          const SizedBox(height: 16), // Reduced spacing
          
          // Add Field Button
          _buildAddSectionButton('Add Field'),
          const SizedBox(height: 20), // Reduced spacing
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
              const SizedBox(width: 10), // Reduced spacing
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Save Gateway Type', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Reduced spacing
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View Existing Types', style: TextStyle(fontSize: 12)), // Reduced font size
            ),
          ),
          const SizedBox(height: 12), // Reduced spacing
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6), // Reduced padding
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14, // Reduced font size
        ),
      ),
    );
  }

  Widget _buildAddSectionButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showAddField,
        icon: const Icon(Icons.add, size: 16), // Reduced icon size
        label: Text(label, style: TextStyle(fontSize: 13)), // Reduced font size
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10), // Reduced padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced border radius
          ),
        ),
      ),
    );
  }
}

// Modal for Add Field
class AddFieldModal extends StatefulWidget {
  const AddFieldModal({super.key});

  @override
  State<AddFieldModal> createState() => _AddFieldModalState();
}

class _AddFieldModalState extends State<AddFieldModal> {
  final _fieldNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Reduced padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Reduced border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          Text(
            'Add New Field to Basic Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Reduced font size
            ),
          ),
          const SizedBox(height: 6), // Reduced spacing
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(5), // Reduced border radius
            ),
            child: Text(
              'A Basic Information',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: 13, // Reduced font size
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Field Name
          TextField(
            controller: _fieldNameController,
            decoration: const InputDecoration(
              hintText: 'Enter field name',
              border: OutlineInputBorder(),
              labelText: 'Field Name *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 14), // Reduced spacing
          
          // Description
          TextField(
            controller: _descriptionController,
            maxLines: 2, // Reduced max lines
            decoration: const InputDecoration(
              hintText: 'Enter field description',
              border: OutlineInputBorder(),
              labelText: 'Description',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
              const SizedBox(width: 10), // Reduced spacing
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Add Field', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
        ],
      ),
    );
  }
}

// Modal for Add Gateway
class AddGatewayModal extends StatefulWidget {
  const AddGatewayModal({super.key});

  @override
  State<AddGatewayModal> createState() => _AddGatewayModalState();
}

class _AddGatewayModalState extends State<AddGatewayModal> {
  String? _selectedGatewayType;
  final _selectedSections = <String>{};
  final _selectedFields = <String>{};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Reduced padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Reduced border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          Text(
            'Gateway Configuration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Reduced font size
            ),
          ),
          const SizedBox(height: 6), // Reduced spacing
          Text(
            'Configure gateway settings and communication protocols',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13), // Reduced font size
          ),
          const SizedBox(height: 20), // Reduced spacing
          
          // Gateway Type
          DropdownButtonFormField<String>(
            initialValue: _selectedGatewayType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Gateway Type *',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
            ),
            items: ['MC3T Gateway', 'HTTP Gateway', 'MQTT Gateway', 'Custom Gateway']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type, style: TextStyle(fontSize: 13)), // Reduced font size
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedGatewayType = value;
              });
            },
          ),
          const SizedBox(height: 16), // Reduced spacing
          
          // Sections
          _buildSectionTitle('Sections'),
          _buildCheckboxItem('Select All Sections', _selectedSections.contains('all'), (value) {
            setState(() {
              if (value == true) {
                _selectedSections.add('all');
              } else {
                _selectedSections.remove('all');
              }
            });
          }),
          const SizedBox(height: 14), // Reduced spacing
          
          // Fields
          _buildSectionTitle('Fields'),
          _buildCheckboxItem('Select All Fields', _selectedFields.contains('all'), (value) {
            setState(() {
              if (value == true) {
                _selectedFields.add('all');
              } else {
                _selectedFields.remove('all');
              }
            });
          }),
          const SizedBox(height: 20), // Reduced spacing
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
              const SizedBox(width: 10), // Reduced spacing
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Reduced border radius
                    ),
                  ),
                  child: const Text('Save Gateway', style: TextStyle(fontSize: 13)), // Reduced font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6), // Reduced padding
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14, // Reduced font size
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label, style: TextStyle(fontSize: 13)), // Reduced font size
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

// Data Models
enum GatewayStatus { online, offline }

class Gateway {
  final String name;
  final String deviceToken;
  final String protocol;
  final GatewayStatus status;

  Gateway({
    required this.name,
    required this.deviceToken,
    required this.protocol,
    required this.status,
  });
}