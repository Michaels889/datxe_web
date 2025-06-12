import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/route_model.dart';
import '../../models/schedule_model.dart';
import '../../services/api_service.dart';

class BookingAdminScreen extends StatefulWidget {
  const BookingAdminScreen({super.key});

  @override
  State<BookingAdminScreen> createState() => _BookingAdminScreenState();
}

class _BookingAdminScreenState extends State<BookingAdminScreen> {
  List<RouteModel> routes = [];
  List<ScheduleModel> schedules = [];
  List<BookingModel> bookings = [];

  RouteModel? selectedRoute;
  ScheduleModel? selectedSchedule;
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _loadRoutes() async {
    routes = await ApiService.fetchRoutes();
    setState(() {});
  }

  void _loadSchedules() async {
    if (selectedRoute != null) {
      schedules = await ApiService.fetchSchedules(selectedRoute!.id);
      setState(() {});
    }
  }

  void _loadBookings() async {
    bookings = await ApiService.fetchBookings(phoneController.text.trim());
    if (selectedSchedule != null) {
      bookings = bookings
          .where((b) => b.scheduleId == selectedSchedule!.id)
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý vé đã đặt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<RouteModel>(
              value: selectedRoute,
              hint: const Text("Chọn tuyến"),
              isExpanded: true,
              items: routes.map((r) {
                return DropdownMenuItem(
                  value: r,
                  child: Text("${r.origin} → ${r.destination}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoute = value;
                  selectedSchedule = null;
                  bookings = [];
                });
                _loadSchedules();
              },
            ),
            if (selectedRoute != null)
              DropdownButton<ScheduleModel>(
                value: selectedSchedule,
                hint: const Text("Chọn lịch chạy"),
                isExpanded: true,
                items: schedules.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text("⏰ ${s.departureTime} | Ghế: ${s.availableSeats}"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSchedule = value;
                  });
                },
              ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Lọc theo SĐT"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(onPressed: _loadBookings, child: const Text("🔍 Tra cứu")),
            const SizedBox(height: 12),
            const Text("📄 Danh sách vé", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: bookings.isEmpty
                  ? const Text("Không có vé")
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final b = bookings[index];
                        return ListTile(
                          title: Text("👤 ${b.customerName} - SĐT: ${b.customerPhone}"),
                          subtitle: Text("Lịch chạy ID: ${b.scheduleId} | Ghế: ${b.seatNumber}"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}