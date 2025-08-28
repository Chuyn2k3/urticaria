import 'package:flutter/material.dart';
import '../../../constant/color.dart';
import '../models/health_record_model.dart';

class HealthRecordDetailScreen extends StatelessWidget {
  final HealthRecord record;

  const HealthRecordDetailScreen({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Bệnh án ${record.recordType}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Patient Info
            _buildInfoCard(
              'Thông tin bệnh nhân',
              Icons.person,
              themeColor,
              [
                _buildInfoRow('Mã bệnh án', record.id),
                _buildInfoRow('Ngày tạo', _formatDate(record.createdDate)),
                _buildInfoRow('Loại bệnh án', record.recordType),
              ],
            ),
            const SizedBox(height: 16),

            // Symptoms
            if (record.symptoms.isNotEmpty)
              _buildInfoCard(
                'Triệu chứng',
                Icons.medical_services,
                Colors.orange,
                [
                  _buildInfoText(record.symptoms),
                ],
              ),
            const SizedBox(height: 16),

            // Diagnosis
            if (record.diagnosis.isNotEmpty)
              _buildInfoCard(
                'Chẩn đoán',
                Icons.medical_information,
                Colors.green,
                [
                  _buildInfoText(record.diagnosis),
                ],
              ),
            const SizedBox(height: 16),

            // Treatment
            if (record.treatment.isNotEmpty)
              _buildInfoCard(
                'Điều trị',
                Icons.healing,
                Colors.purple,
                [
                  _buildInfoText(record.treatment),
                ],
              ),
            const SizedBox(height: 16),

            // Doctor Info
            if (record.doctorName.isNotEmpty)
              _buildInfoCard(
                'Bác sĩ điều trị',
                Icons.local_hospital,
                Colors.blue,
                [
                  _buildInfoRow('Bác sĩ', record.doctorName),
                ],
              ),
            const SizedBox(height: 16),

            // Images
            if (record.imageUrls.isNotEmpty) _buildImagesCard(),
            const SizedBox(height: 16),

            // Notes
            if (record.notes.isNotEmpty)
              _buildInfoCard(
                'Ghi chú',
                Icons.note,
                Colors.grey,
                [
                  _buildInfoText(record.notes),
                ],
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (record.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusText = 'Chờ khám';
        break;
      case 'inProgress':
        statusColor = Colors.blue;
        statusIcon = Icons.medical_services;
        statusText = 'Đang khám';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Hoàn thành';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Không xác định';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(statusIcon, color: AppColors.whiteColor, size: 48),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cập nhật lần cuối: ${_formatDate(record.createdDate)}',
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1F2937),
        height: 1.5,
      ),
    );
  }

  Widget _buildImagesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_library,
                    color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hình ảnh',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: record.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Show full image
                  _showImageDialog(context, record.imageUrls[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 64,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
