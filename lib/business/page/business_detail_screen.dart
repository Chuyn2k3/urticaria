import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/colors.dart';
import '../../model/business_detail_model.dart';
import '../../model/user_business_model.dart';
import '../../widget/app_bar.dart';

class BusinessDetailScreen extends StatefulWidget {
  final String idBusiness;
  BusinessDetailScreen({Key? key, required this.idBusiness}) : super(key: key);

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  late UserBusinessModel userBusiness;
  late BusinessDetailModel detail;

  @override
  void initState() {
    super.initState();
    userBusiness = UserBusinessModel.fake();
    detail = BusinessDetailModel.fake();
  }

  @override
  Widget build(BuildContext context) {
    final groupedToaThuoc = <String, List<ToaThuocInfo>>{};
    for (final item in detail.toaThuocInfos ?? []) {
      final key = item.loai ?? 'Không xác định';
      groupedToaThuoc.putIfAbsent(key, () => []).add(item);
    }
    final groupedXetNghiem = <String, List<XetNghiemInfo>>{};
    for (final info in detail.xetNghiemInfos ?? []) {
      final loaiId = info.loaiXetNghiemId ?? 'unknown';
      if (!groupedXetNghiem.containsKey(loaiId)) {
        groupedXetNghiem[loaiId] = [];
      }
      groupedXetNghiem[loaiId]!.add(info);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Hồ sơ sức khoẻ chi tiết",
        isBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('I. THÔNG TIN HÀNH CHÍNH'),
            _buildGrid([
              _item('Họ tên', userBusiness.hoTen),
              _item('Giới tính', userBusiness.gioiTinh == 1 ? "Nam" : "Nữ"),
              _item('Ngày sinh', userBusiness.ngaySinhText),
              _item('Tuổi', userBusiness.tuoi),
              _item('Số thẻ BHYT', userBusiness.maTheBHYT),
              _item('Số CCCD', userBusiness.soCmt),
              _item('SĐT liên hệ', userBusiness.dienThoai),
              _item('Email', "-"),
              _item('Địa chỉ nơi ở', userBusiness.diaChiLienHe),
              _item('Đơn vị hành chính', userBusiness.diaChiHanhChinhId),
            ], 2),
            _buildSection('II. THÔNG TIN KHÁM'),
            _buildGrid([
              _item('Ngày vào viện', detail.ngayVaoVien),
              _item('Ngày ra viện', detail.ngayRaVien),
              _item('Mạch (lần/phút)', detail.sinhHieu?.mach),
              _item('Nhiệt độ (°C)', detail.sinhHieu?.nhietDo),
              _item('Huyết áp',
                  "\${detail.sinhHieu?.huyetApMin} - \${detail.sinhHieu?.huyetApMax}"),
              _item('Nhịp thở (lần/phút)', detail.sinhHieu?.nhipTho),
              _item('SpO2 (%)', detail.sinhHieu?.spo2),
              _item('Chiều cao (cm)', detail.sinhHieu?.chieuCao),
              _item('Cân nặng (kg)', detail.sinhHieu?.canNang),
              _item('BMI (kg/m2)', detail.sinhHieu?.bmi),
              _item('Lý do đến khám', detail.sinhHieu?.lyDoDenKham),
              _item('Chẩn đoán sơ bộ', detail.sinhHieu?.chanDoanPhanBiet),
              _item('Bệnh chính', detail.sinhHieu?.benhChinh),
              _item('Bệnh kèm theo', detail.sinhHieu?.benhKemTheo),
            ], 2),
            _buildSection('III. KẾT QUẢ KCB'),
            _subTitle('III.1. KẾT QUẢ XÉT NGHIỆM'),
            _buildTable(
              headers: const ['STT', 'Tên loại xét nghiệm', 'Tác vụ'],
              rows: groupedXetNghiem.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final danhSachChiSo = entry.value.value;
                final tenLoai =
                    danhSachChiSo.first.tenLoaiXetNghiem ?? 'Không rõ';

                return [
                  Text('\${index + 1}'),
                  Text(tenLoai),
                  const Text('Xem KQ', style: TextStyle(color: Colors.blue)),
                ];
              }).toList(),
            ),
            _subTitle('III.2. KẾT QUẢ CHẨN ĐOÁN HÌNH ẢNH - TDCN - CLS CHUNG'),
            _buildTable(
              headers: const [
                'STT',
                'Tên dịch vụ kỹ thuật',
                'Kết luận',
                'Tác vụ'
              ],
              rows: detail.urlDataInfos?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return [
                      Text('\${index + 1}'),
                      Text(data.maDichVu ?? ""),
                      Text(data.ketLuan ?? ""),
                      const Text('Xem KQ',
                          style: TextStyle(color: Colors.blue)),
                    ];
                  }).toList() ??
                  [],
            ),
            _subTitle('III.3. ĐƠN THUỐC'),
            _buildTable(
              headers: const ['STT', 'Loại đơn thuốc', 'Tác vụ'],
              rows:
                  groupedToaThuoc.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final loai = entry.value.key;
                return [
                  Text('\${index + 1}'),
                  Text(loai),
                  const Text('Xem KQ', style: TextStyle(color: Colors.blue)),
                ];
              }).toList(),
            ),
            _subTitle('III.4. CHI PHÍ KHÁM CHỮA BỆNH'),
            _buildTable(
              headers: const ['STT', 'Mã tra cứu', 'Ngày phát hành', 'Tác vụ'],
              rows: detail.vienPhiInfos?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final info = entry.value;
                    return [
                      Text('\${index + 1}'),
                      Text(info.maGiaoDich ?? ''),
                      Text(info.thoiGian != null && info.thoiGian!.isNotEmpty
                          ? DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(info.thoiGian!))
                          : ''),
                      const Text('Xem KQ',
                          style: TextStyle(color: Colors.blue)),
                    ];
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        color: AppColors.primary,
        width: double.infinity,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      );

  Widget _subTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
      );

  Widget _item(String label, String? value) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                )),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value ?? '-',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
          ],
        ),
      );

  Widget _buildGrid(List<Widget> children, int columnCount) {
    List<Row> rows = [];
    for (int i = 0; i < children.length; i += columnCount) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(columnCount, (index) {
          int childIndex = i + index;
          if (childIndex >= children.length) {
            return const Expanded(child: SizedBox());
          }
          return Expanded(child: children[childIndex]);
        }),
      ));
    }
    return Column(
      children: rows
          .map((r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: r,
              ))
          .toList(),
    );
  }

  Widget _buildTable({
    required List<String> headers,
    required List<List<Widget>> rows,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Table(
        columnWidths: const {},
        border: TableBorder.all(color: Colors.grey.shade400),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppColors.primary),
            children: headers
                .map((h) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(h,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ))
                .toList(),
          ),
          ...rows.map((row) => TableRow(
                children: row
                    .map((cell) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: cell,
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}
