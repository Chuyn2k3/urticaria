import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import 'health_record_detail_screen.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  // Mock data
  final List<HealthRecord> _healthRecords = [
    HealthRecord(
      doctorId: "1",
      id: '1',
      patientId: 'patient1',
      recordType: 'Cấp tính',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'completed',
      symptoms: 'Ngứa, phát ban đỏ',
      diagnosis: 'Viêm da cơ địa',
      treatment: 'Thuốc bôi Corticosteroid',
      doctorName: 'BS. Nguyễn Văn A',
      notes: 'Tái khám sau 1 tuần',
    ),
    HealthRecord(
      doctorId: "1",
      id: '2',
      patientId: 'patient1',
      recordType: 'Mãn tính lần 1',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      status: 'inProgress',
      symptoms: 'Mề đay mãn tính, ngứa ban đêm',
      diagnosis: 'Đang chờ kết quả xét nghiệm',
      treatment: '',
      doctorName: 'BS. Trần Thị B',
      notes: 'Cần xét nghiệm máu',
    ),
    HealthRecord(
      doctorId: "1",
      id: '3',
      patientId: 'patient1',
      recordType: 'Cấp tính',
      createdDate: DateTime.now().subtract(const Duration(days: 14)),
      status: 'pending',
      symptoms: 'Sưng phù, đau rát',
      diagnosis: '',
      treatment: '',
      doctorName: '',
      notes: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<HealthRecord> get _filteredRecords {
    switch (_selectedFilter) {
      case 'pending':
        return _healthRecords.where((r) => r.status == 'pending').toList();
      case 'inProgress':
        return _healthRecords.where((r) => r.status == 'inProgress').toList();
      case 'completed':
        return _healthRecords.where((r) => r.status == 'completed').toList();
      default:
        return _healthRecords;
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Hồ sơ sức khỏe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _selectedFilter = 'all';
                  break;
                case 1:
                  _selectedFilter = 'pending';
                  break;
                case 2:
                  _selectedFilter = 'inProgress';
                  break;
                case 3:
                  _selectedFilter = 'completed';
                  break;
              }
            });
          },
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ khám'),
            Tab(text: 'Đang khám'),
            Tab(text: 'Hoàn thành'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Tổng số bệnh án',
                    _healthRecords.length.toString(),
                    Icons.folder_outlined,
                    themeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Đang điều trị',
                    _healthRecords
                        .where((r) => r.status == 'inProgress')
                        .length
                        .toString(),
                    Icons.medical_services,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Records List
          Expanded(
            child: _filteredRecords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = _filteredRecords[index];
                      return _buildRecordCard(record);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(HealthRecord record) {
    Color statusColor;
    IconData statusIcon;

    switch (record.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'inProgress':
        statusColor = Colors.blue;
        statusIcon = Icons.medical_services;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HealthRecordDetailScreen(record: record),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066CC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        record.recordType,
                        style: const TextStyle(
                          color: Color(0xFF0066CC),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(record.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  record.symptoms.isNotEmpty
                      ? record.symptoms
                      : 'Chưa có thông tin triệu chứng',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (record.diagnosis.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.medical_information,
                          color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          record.diagnosis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                if (record.doctorName.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        record.doctorName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.grey.shade600, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(record.createdDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bệnh án nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bệnh án đầu tiên của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ khám';
      case 'inProgress':
        return 'Đang khám';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else if (difference < 7) {
      return '$difference ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
