import 'package:flutter/material.dart';
import '../../models/schedule_model.dart';
import '../../models/route_model.dart';
import '../../services/api_service.dart';

class ScheduleAdminScreen extends StatefulWidget {
  const ScheduleAdminScreen({super.key});

  @override
  State<ScheduleAdminScreen> createState() => _ScheduleAdminScreenState();
}

class _ScheduleAdminScreenState extends State<ScheduleAdminScreen> {
  List<RouteModel> routes = [];
  List<ScheduleModel> schedules = [];

  RouteModel? selectedRoute;
  DateTime? selectedDate;
  final _availableSeatsCtrl = TextEditingController();

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

  void _addSchedule() async {
    if (selectedRoute != null && selectedDate != null) {
      await ApiService.createSchedule(
        routeId: selectedRoute!.id,
        departureTime: selectedDate!.toIso8601String(),
        availableSeats: int.tryParse(_availableSeatsCtrl.text.trim()) ?? 0,
      );
      _availableSeatsCtrl.clear();
      _loadSchedules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý lịch chạy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<RouteModel>(
              value: selectedRoute,
              hint: const Text("Chọn tuyến"),
              isExpanded: true,
              items: routes.map((route) {
                return DropdownMenuItem(
                  value: route,
                  child: Text("${route.origin} → ${route.destination} (${route.name})"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoute = value;
                  schedules = [];
                });
                _loadSchedules();
              },
            ),
            if (selectedRoute != null) ...[
              ElevatedButton(
                onPressed: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  setState(() {});
                },
                child: Text(selectedDate == null
                    ? "Chọn ngày chạy"
                    : "Ngày: ${selectedDate!.toLocal().toString().split(' ')[0]}"),
              ),
              TextField(
                controller: _availableSeatsCtrl,
                decoration: const InputDecoration(labelText: "Số ghế"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(onPressed: _addSchedule, child: const Text("➕ Thêm lịch chạy")),
              const Divider(),
              const Text("📅 Danh sách lịch chạy", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final s = schedules[index];
                    return ListTile(
                      title: Text("🕑 ${s.departureTime}"),
                      subtitle: Text("Ghế trống: ${s.availableSeats}"),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}