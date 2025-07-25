import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/doctor_model.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  List<Doctor> _doctors = [
    Doctor(
      id: '1',
      name: 'BS. Lê Thị Mai',
      specialty: 'Da liễu',
      avatar: '/placeholder.svg?height=100&width=100',
      rating: 4.8,
      experience: 10,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      timeSlots: [],
    ),
    Doctor(
      id: '2',
      name: 'BS. Nguyễn Văn Hùng',
      specialty: 'Da liễu',
      avatar: '/placeholder.svg?height=100&width=100',
      rating: 4.9,
      experience: 15,
      availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Saturday'],
      timeSlots: [],
    ),
    Doctor(
      id: '3',
      name: 'BS. Trần Thị Hương',
      specialty: 'Da liễu',
      avatar: '/placeholder.svg?height=100&width=100',
      rating: 4.7,
      experience: 8,
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      timeSlots: [],
    ),
  ];

  void loadDoctors() {
    emit(BookingLoading());
    try {
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        emit(DoctorsLoaded(_doctors));
      });
    } catch (e) {
      emit(BookingError('Không thể tải danh sách bác sĩ'));
    }
  }

  void selectDoctor(Doctor doctor) {
    emit(DoctorSelected(doctor));
  }

  void loadTimeSlots(String doctorId, DateTime date) {
    emit(BookingLoading());
    try {
      // Generate time slots for the selected date
      List<TimeSlot> slots = _generateTimeSlots(date);
      emit(TimeSlotsLoaded(slots));
    } catch (e) {
      emit(BookingError('Không thể tải lịch trống'));
    }
  }

  List<TimeSlot> _generateTimeSlots(DateTime date) {
    List<TimeSlot> slots = [];

    // Morning slots (8:00 - 11:30)
    for (int hour = 8; hour < 12; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == 11 && minute == 30) break;

        DateTime startTime =
            DateTime(date.year, date.month, date.day, hour, minute);
        DateTime endTime = startTime.add(const Duration(minutes: 30));

        slots.add(TimeSlot(
          id: '${hour}_$minute',
          startTime: startTime,
          endTime: endTime,
          isBooked: _isSlotBooked(startTime),
        ));
      }
    }

    // Afternoon slots (14:00 - 17:30)
    for (int hour = 14; hour < 18; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == 17 && minute == 30) break;

        DateTime startTime =
            DateTime(date.year, date.month, date.day, hour, minute);
        DateTime endTime = startTime.add(const Duration(minutes: 30));

        slots.add(TimeSlot(
          id: '${hour}_$minute',
          startTime: startTime,
          endTime: endTime,
          isBooked: _isSlotBooked(startTime),
        ));
      }
    }

    return slots;
  }

  bool _isSlotBooked(DateTime time) {
    // Simulate some booked slots
    return time.hour == 9 || time.hour == 15;
  }

  void bookAppointment(
      String doctorId, TimeSlot timeSlot, String appointmentType) {
    emit(BookingLoading());
    try {
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        final appointment = Appointment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          doctorId: doctorId,
          patientId: 'current_user_id',
          appointmentTime: timeSlot.startTime,
          type: appointmentType,
          status: 'confirmed',
          createdAt: DateTime.now(),
        );
        emit(AppointmentBooked(appointment));
      });
    } catch (e) {
      emit(BookingError('Không thể đặt lịch khám'));
    }
  }
}

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class DoctorsLoaded extends BookingState {
  final List<Doctor> doctors;
  DoctorsLoaded(this.doctors);
}

class DoctorSelected extends BookingState {
  final Doctor doctor;
  DoctorSelected(this.doctor);
}

class TimeSlotsLoaded extends BookingState {
  final List<TimeSlot> timeSlots;
  TimeSlotsLoaded(this.timeSlots);
}

class AppointmentBooked extends BookingState {
  final Appointment appointment;
  AppointmentBooked(this.appointment);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
