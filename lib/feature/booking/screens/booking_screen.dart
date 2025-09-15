// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:urticaria/feature/booking/cubit/booking_cubit.dart';
// //import 'package:urticaria/utils/colors.dart';
//
// import '../../../constant/color.dart';
// import '../model/doctor_model.dart';
//
// class BookingScreen extends StatefulWidget {
//   const BookingScreen({super.key});
//
//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }
//
// class _BookingScreenState extends State<BookingScreen> {
//   DateTime _selectedDay = DateTime.now();
//   DateTime _focusedDay = DateTime.now();
//   Doctor? _selectedDoctor;
//   TimeSlot? _selectedTimeSlot;
//   String _appointmentType = 'Khám mới';
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<BookingCubit>().loadDoctors();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text(
//           'Đặt lịch khám',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.primaryColor,
//         foregroundColor: AppColors.whiteColor,
//         elevation: 0,
//       ),
//       body: BlocConsumer<BookingCubit, BookingState>(
//         listener: (context, state) {
//           if (state is AppointmentBooked) {
//             _showSuccessDialog(state.appointment);
//           } else if (state is BookingError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is BookingLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildStepIndicator(),
//                 const SizedBox(height: 24),
//                 _buildDoctorSelection(state),
//                 if (_selectedDoctor != null) ...[
//                   const SizedBox(height: 24),
//                   _buildAppointmentTypeSelection(),
//                   const SizedBox(height: 24),
//                   _buildCalendarSelection(),
//                   const SizedBox(height: 24),
//                   _buildTimeSlotSelection(state),
//                 ],
//                 if (_selectedTimeSlot != null) ...[
//                   const SizedBox(height: 24),
//                   _buildBookingConfirmation(),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildStepIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _buildStep(1, 'Chọn bác sĩ', _selectedDoctor != null),
//           _buildStepConnector(_selectedDoctor != null),
//           _buildStep(2, 'Chọn ngày', _selectedDay != DateTime.now()),
//           _buildStepConnector(_selectedTimeSlot != null),
//           _buildStep(3, 'Chọn giờ', _selectedTimeSlot != null),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStep(int step, String title, bool isCompleted) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color:
//                   isCompleted ? AppColors.primaryColor : Colors.grey.shade300,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: isCompleted
//                   ? const Icon(Icons.check,
//                       color: AppColors.whiteColor, size: 18)
//                   : Text(
//                       step.toString(),
//                       style: TextStyle(
//                         color: isCompleted
//                             ? AppColors.whiteColor
//                             : Colors.grey.shade600,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color:
//                   isCompleted ? AppColors.primaryColor : Colors.grey.shade600,
//               fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStepConnector(bool isActive) {
//     return Container(
//       width: 40,
//       height: 2,
//       color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
//       margin: const EdgeInsets.only(bottom: 24),
//     );
//   }
//
//   Widget _buildDoctorSelection(BookingState state) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Chọn bác sĩ',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 16),
//           if (state is DoctorsLoaded)
//             ...state.doctors.map((doctor) => _buildDoctorCard(doctor)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDoctorCard(Doctor doctor) {
//     final isSelected = _selectedDoctor?.id == doctor.id;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedDoctor = doctor;
//           _selectedTimeSlot = null;
//         });
//         context.read<BookingCubit>().selectDoctor(doctor);
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.primaryColor.withOpacity(0.1)
//               : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryColor : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(doctor.avatar),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     doctor.specialty,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber.shade600, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         doctor.rating.toString(),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Icon(Icons.work_outline,
//                           color: Colors.grey.shade600, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${doctor.experience} năm KN',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               const Icon(
//                 Icons.check_circle,
//                 color: AppColors.primaryColor,
//                 size: 24,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppointmentTypeSelection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Loại khám',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Wrap(
//             spacing: 12,
//             children: ['Khám mới', 'Tái khám', 'Khám cấp'].map((type) {
//               final isSelected = _appointmentType == type;
//               return GestureDetector(
//                 onTap: () => setState(() => _appointmentType = type),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? AppColors.primaryColor
//                         : Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     type,
//                     style: TextStyle(
//                       color: isSelected
//                           ? AppColors.whiteColor
//                           : Colors.grey.shade700,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendarSelection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Chọn ngày khám',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 16),
//           TableCalendar<dynamic>(
//             firstDay: DateTime.now(),
//             lastDay: DateTime.now().add(const Duration(days: 30)),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//                 _selectedTimeSlot = null;
//               });
//               context
//                   .read<BookingCubit>()
//                   .loadTimeSlots(_selectedDoctor!.id, selectedDay);
//             },
//             calendarStyle: CalendarStyle(
//               outsideDaysVisible: false,
//               selectedDecoration: const BoxDecoration(
//                 color: AppColors.primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               todayDecoration: BoxDecoration(
//                 color: AppColors.primaryColor.withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             headerStyle: const HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeSlotSelection(BookingState state) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Chọn giờ khám',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 16),
//           if (state is TimeSlotsLoaded) ...[
//             const Text(
//               'Buổi sáng (8:00 - 11:30)',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF374151),
//               ),
//             ),
//             const SizedBox(height: 12),
//             _buildTimeSlotGrid(state.timeSlots
//                 .where((slot) => slot.startTime.hour < 12)
//                 .toList()),
//             const SizedBox(height: 20),
//             const Text(
//               'Buổi chiều (14:00 - 17:30)',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF374151),
//               ),
//             ),
//             const SizedBox(height: 12),
//             _buildTimeSlotGrid(state.timeSlots
//                 .where((slot) => slot.startTime.hour >= 14)
//                 .toList()),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeSlotGrid(List<TimeSlot> slots) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 2.5,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: slots.length,
//       itemBuilder: (context, index) {
//         final slot = slots[index];
//         final isSelected = _selectedTimeSlot?.id == slot.id;
//         final isBooked = slot.isBooked;
//
//         return GestureDetector(
//           onTap:
//               isBooked ? null : () => setState(() => _selectedTimeSlot = slot),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: isBooked
//                   ? Colors.grey.shade200
//                   : isSelected
//                       ? AppColors.primaryColor
//                       : Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: isSelected ? AppColors.primaryColor : Colors.transparent,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 '${slot.startTime.hour.toString().padLeft(2, '0')}:${slot.startTime.minute.toString().padLeft(2, '0')}',
//                 style: TextStyle(
//                   color: isBooked
//                       ? Colors.grey.shade500
//                       : isSelected
//                           ? AppColors.whiteColor
//                           : Colors.grey.shade700,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBookingConfirmation() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Xác nhận đặt lịch',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildConfirmationRow('Bác sĩ', _selectedDoctor!.name),
//           _buildConfirmationRow('Loại khám', _appointmentType),
//           _buildConfirmationRow(
//             'Ngày khám',
//             '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
//           ),
//           _buildConfirmationRow(
//             'Giờ khám',
//             '${_selectedTimeSlot!.startTime.hour.toString().padLeft(2, '0')}:${_selectedTimeSlot!.startTime.minute.toString().padLeft(2, '0')}',
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 context.read<BookingCubit>().bookAppointment(
//                       _selectedDoctor!.id,
//                       _selectedTimeSlot!,
//                       _appointmentType,
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryColor,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Xác nhận đặt lịch',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildConfirmationRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           const Text(': '),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF374151),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessDialog(Appointment appointment) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Colors.green,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check,
//                 color: AppColors.whiteColor,
//                 size: 32,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Đặt lịch thành công!',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Lịch khám của bạn đã được xác nhận. Vui lòng đến đúng giờ hẹn.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Đóng',
//                   style: TextStyle(color: AppColors.whiteColor),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
