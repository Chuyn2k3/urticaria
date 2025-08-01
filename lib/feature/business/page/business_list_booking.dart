import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urticaria/feature/health_records/models/health_record_model.dart';
import 'package:urticaria/models/business_model.dart';
import '../../../../utils/colors.dart';
import '../widget/booking_history_item.dart';
import 'patient_infomation.dart';

class BusinessListBooking extends StatefulWidget {
  const BusinessListBooking({super.key});

  @override
  State<BusinessListBooking> createState() => _BusinessListBookingState();
}

class _BusinessListBookingState extends State<BusinessListBooking>
    with TickerProviderStateMixin {
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedFilter = 'all';
  late TabController _tabController;

  // Convert HealthRecord to BusinessModel for compatibility
  List<BusinessModel> get _businessList {
    return HealthRecord.getMockData().map((record) {
      return BusinessModel(
        id: record.id,
        xuTriType: 0,
        loai: 1,
        thoiGianRa: record.createdDate.toIso8601String(),
        moTaIcd:
            record.diagnosis.isNotEmpty ? record.diagnosis : record.symptoms,
        key: record.recordType,
        dangKyId: record.id,
        benhNhanId: record.patientId,
        xuTriContent: record.treatment,
        thoiGianVao: record.createdDate.toIso8601String(),
        vao: record.doctorName,
        ra: record.status,
        icdId: record.id,
        chanDoanPhanBiet: record.diagnosis,
        benhKemTheo: record.notes,
        sinhHieuChamSocDto: {
          'status': record.status,
          'symptoms': record.symptoms,
          'images': record.imageUrls,
        },
      );
    }).toList();
  }

  List<BusinessModel> get _filteredBusinessList {
    List<BusinessModel> filtered = _businessList;

    // Filter by status
    if (_selectedFilter != 'all') {
      filtered = filtered.where((business) {
        final status =
            (business.sinhHieuChamSocDto as Map<String, dynamic>?)?['status'] ??
                '';
        return status == _selectedFilter;
      }).toList();
    }

    // Filter by date range
    if (_fromDate != null && _toDate != null) {
      filtered = filtered.where((business) {
        if (business.thoiGianRa == null) return false;
        final businessDate = DateTime.parse(business.thoiGianRa!);
        return businessDate
                .isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
            businessDate.isBefore(_toDate!.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Patient Information
          Container(
            color: Colors.white,
            child: PatientInformation(),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey.shade600,
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

          // Date Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_month,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'LỊCH SỬ KHÁM, CHỮA BỆNH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // From date
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDateRange:
                                _fromDate != null && _toDate != null
                                    ? DateTimeRange(
                                        start: _fromDate!, end: _toDate!)
                                    : null,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              _fromDate = picked.start;
                              _toDate = picked.end;
                            });
                          }
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _fromDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_fromDate!)
                                      : 'Từ ngày',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _fromDate != null
                                        ? Colors.black87
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // To date display
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _toDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_toDate!)
                                    : 'Đến ngày',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _toDate != null
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Clear filter button
                    if (_fromDate != null || _toDate != null)
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fromDate = null;
                              _toDate = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.grey.shade100,
                            elevation: 0,
                          ),
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Summary Statistics
          Container(
            margin: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Tổng số',
                    _businessList.length.toString(),
                    Icons.folder_outlined,
                    AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Đang điều trị',
                    _businessList
                        .where((b) =>
                            (b.sinhHieuChamSocDto
                                as Map<String, dynamic>?)?['status'] ==
                            'inProgress')
                        .length
                        .toString(),
                    Icons.medical_services,
                    Colors.orange,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Hoàn thành',
                    _businessList
                        .where((b) =>
                            (b.sinhHieuChamSocDto
                                as Map<String, dynamic>?)?['status'] ==
                            'completed')
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Records List
          Expanded(
            child: _filteredBusinessList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredBusinessList.length,
                    itemBuilder: (context, index) {
                      final business = _filteredBusinessList[index];
                      return BookingHistoryItem(business: business);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
            'Không có bệnh án nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'all'
                ? 'Chưa có bệnh án nào được tạo'
                : 'Không có bệnh án nào với trạng thái này',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
