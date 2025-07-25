import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/colors.dart';
import '../../model/business_detail_model.dart';
import '../../model/user_business_model.dart';
import '../../health_records/models/health_record_model.dart';
import '../../widget/app_bar.dart';

class BusinessDetailScreen extends StatefulWidget {
  final String idBusiness;

  const BusinessDetailScreen({super.key, required this.idBusiness});

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  late UserBusinessModel userBusiness;
  late BusinessDetailModel detail;
  late HealthRecord healthRecord;

  @override
  void initState() {
    super.initState();
    userBusiness = UserBusinessModel.fake();
    detail = BusinessDetailModel.fake();

    // Find corresponding health record
    final records = HealthRecord.getMockData();
    healthRecord = records.firstWhere(
      (record) => record.id == widget.idBusiness,
      orElse: () => records.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: "Chi tiết bệnh án",
        isBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
              _showShareDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              // Print functionality
              _showPrintDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Patient Information Section
            _buildSection('I. THÔNG TIN BỆNH NHÂN'),
            _buildPatientInfoCard(),
            const SizedBox(height: 16),

            // Medical Information Section
            _buildSection('II. THÔNG TIN KHÁM BỆNH'),
            _buildMedicalInfoCard(),
            const SizedBox(height: 16),

            // Images Section
            if (healthRecord.imageUrls.isNotEmpty) ...[
              _buildSection('III. HÌNH ẢNH TRIỆU CHỨNG'),
              _buildImagesCard(),
              const SizedBox(height: 16),
            ],

            // Test Results Section
            _buildSection('IV. KẾT QUẢ XÉT NGHIỆM'),
            _buildTestResultsCard(),
            const SizedBox(height: 16),

            // Treatment Section
            _buildSection('V. ĐIỀU TRỊ VÀ TOA THUỐC'),
            _buildTreatmentCard(),
            const SizedBox(height: 16),

            // Notes Section
            if (healthRecord.notes.isNotEmpty) ...[
              _buildSection('VI. GHI CHÚ VÀ THEO DÕI'),
              _buildNotesCard(),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            _buildActionButtons(),
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

    switch (healthRecord.status) {
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
          Icon(statusIcon, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mã bệnh án: ${healthRecord.id}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cập nhật: ${_formatDateTime(healthRecord.updatedDate ?? healthRecord.createdDate)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          _buildInfoGrid([
            _buildInfoItem('Họ tên', userBusiness.hoTen ?? 'N/A'),
            _buildInfoItem(
                'Giới tính', userBusiness.gioiTinh == 1 ? "Nam" : "Nữ"),
            _buildInfoItem('Ngày sinh', userBusiness.ngaySinhText ?? 'N/A'),
            _buildInfoItem('Tuổi', userBusiness.tuoi ?? 'N/A'),
            _buildInfoItem('Số thẻ BHYT', userBusiness.maTheBHYT ?? 'N/A'),
            _buildInfoItem('Số CCCD', userBusiness.soCmt ?? 'N/A'),
            _buildInfoItem('SĐT liên hệ', userBusiness.dienThoai ?? 'N/A'),
            _buildInfoItem('Email', userBusiness.thuDienTu ?? 'N/A'),
          ]),
          const SizedBox(height: 12),
          _buildInfoItem('Địa chỉ', userBusiness.diaChiLienHe ?? 'N/A',
              fullWidth: true),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          _buildInfoItem('Loại bệnh án', healthRecord.recordType,
              fullWidth: true),
          const SizedBox(height: 12),
          _buildInfoItem('Ngày tạo', _formatDateTime(healthRecord.createdDate),
              fullWidth: true),
          const SizedBox(height: 12),
          _buildInfoItem(
              'Bác sĩ điều trị',
              healthRecord.doctorName.isNotEmpty
                  ? healthRecord.doctorName
                  : 'Chưa phân công',
              fullWidth: true),
          const SizedBox(height: 12),
          _buildInfoItem(
              'Triệu chứng',
              healthRecord.symptoms.isNotEmpty
                  ? healthRecord.symptoms
                  : 'Chưa có thông tin',
              fullWidth: true),
          if (healthRecord.diagnosis.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoItem('Chẩn đoán', healthRecord.diagnosis,
                fullWidth: true),
          ],
          if (detail.sinhHieu != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Sinh hiệu:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoGrid([
              _buildInfoItem(
                  'Mạch', '${detail.sinhHieu?.mach ?? 'N/A'} lần/phút'),
              _buildInfoItem(
                  'Nhiệt độ', '${detail.sinhHieu?.nhietDo ?? 'N/A'}°C'),
              _buildInfoItem('Huyết áp',
                  '${detail.sinhHieu?.huyetApMin ?? 'N/A'}/${detail.sinhHieu?.huyetApMax ?? 'N/A'} mmHg'),
              _buildInfoItem(
                  'Nhịp thở', '${detail.sinhHieu?.nhipTho ?? 'N/A'} lần/phút'),
              _buildInfoItem('SpO2', '${detail.sinhHieu?.spo2 ?? 'N/A'}%'),
              _buildInfoItem('BMI', '${detail.sinhHieu?.bmi ?? 'N/A'} kg/m²'),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Icon(Icons.photo_library, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Hình ảnh triệu chứng (${healthRecord.imageUrls.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
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
            itemCount: healthRecord.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImageDialog(healthRecord.imageUrls[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 12,
                          ),
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

  Widget _buildTestResultsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Row(
            children: [
              Icon(Icons.science, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Kết quả xét nghiệm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (detail.xetNghiemInfos?.isNotEmpty == true) ...[
            ...detail.xetNghiemInfos!.map((test) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.tenLoaiXetNghiem ?? 'Xét nghiệm',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${test.tenChiSo ?? 'N/A'}: ${test.giaTri ?? 'N/A'} ${test.donViTinh ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (test.normalRange != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Giá trị bình thường: ${test.normalRange}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                )),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  const Text('Chưa có kết quả xét nghiệm'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTreatmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Row(
            children: [
              Icon(Icons.medication, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Điều trị và toa thuốc',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (healthRecord.treatment.isNotEmpty) ...[
            _buildInfoItem('Phương pháp điều trị', healthRecord.treatment,
                fullWidth: true),
            const SizedBox(height: 16),
          ],
          if (detail.toaThuocInfos?.isNotEmpty == true) ...[
            const Text(
              'Toa thuốc:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ...detail.toaThuocInfos!.map((medicine) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.tenHang ?? 'Thuốc',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (medicine.hoatChat != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Hoạt chất: ${medicine.hoatChat}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Liều dùng: ${medicine.soLuong ?? 'N/A'} ${medicine.donViTinh ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (medicine.cachDung != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Cách dùng: ${medicine.cachDung}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                )),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  const Text('Chưa có toa thuốc'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Row(
            children: [
              Icon(Icons.note_alt, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Ghi chú và theo dõi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              healthRecord.notes,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Schedule follow-up appointment
              _showFollowUpDialog();
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Đặt lịch tái khám'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Contact doctor
              _showContactDialog();
            },
            icon: const Icon(Icons.phone),
            label: const Text('Liên hệ bác sĩ'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool fullWidth = false}) {
    if (fullWidth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1F2937),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(List<Widget> children) {
    List<Row> rows = [];
    for (int i = 0; i < children.length; i += 2) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: children[i]),
          const SizedBox(width: 12),
          Expanded(
            child: i + 1 < children.length ? children[i + 1] : const SizedBox(),
          ),
        ],
      ));
    }
    return Column(
      children: rows
          .map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: r,
              ))
          .toList(),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 64,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hình ảnh triệu chứng',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
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
                    color: Colors.white,
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

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chia sẻ bệnh án'),
        content: const Text('Chọn cách thức chia sẻ bệnh án này'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Share as PDF
            },
            child: const Text('Chia sẻ PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Share as link
            },
            child: const Text('Chia sẻ link'),
          ),
        ],
      ),
    );
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('In bệnh án'),
        content: const Text('Bạn có muốn in bệnh án này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Print functionality
            },
            child: const Text('In'),
          ),
        ],
      ),
    );
  }

  void _showFollowUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt lịch tái khám'),
        content: const Text('Bạn có muốn đặt lịch tái khám với bác sĩ không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to booking screen
            },
            child: const Text('Đặt lịch'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ bác sĩ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Gọi điện'),
              onTap: () {
                Navigator.pop(context);
                // Make phone call
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Nhắn tin'),
              onTap: () {
                Navigator.pop(context);
                // Send message
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
