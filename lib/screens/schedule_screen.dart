// screens/schedule_screen.dart
import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class ScheduleScreen extends StatefulWidget {
  final int routeId;
  const ScheduleScreen({super.key, required this.routeId});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<List<ScheduleModel>> _futureSchedules;

  @override
  void initState() {
    super.initState();
    _futureSchedules = ApiService.fetchSchedules(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn lịch chạy")),
      body: FutureBuilder<List<ScheduleModel>>(
        future: _futureSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("Không có lịch chạy"));

          final schedules = snapshot.data!;

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text("Giờ khởi hành: ${schedule.departureTime}"),
                subtitle: Text("Ghế trống: ${schedule.availableSeats}"),
                trailing: ElevatedButton(
                  child: const Text("Đặt vé"),
				  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Nhập thông tin"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(labelText: "Họ tên"),
                                  ),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(labelText: "Số điện thoại"),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Huỷ"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final name = nameController.text.trim();
                                    final phone = phoneController.text.trim();

                                    if (name.isEmpty || phone.isEmpty) return;

                                    bool success = true;

                                    for (var seat in selectedSeats) {
                                      final result = await ApiService.bookSeat(
                                        scheduleId: widget.scheduleId,
                                        seatNumber: seat,
                                        name: name,
                                        phone: phone,
                                      );
                                      if (!result) success = false;
                                    }

                                    Navigator.pop(context); // đóng dialog

                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("🎉 Đặt vé thành công")),
                                      );
                                      setState(() {
                                        selectedSeats.clear();
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("⚠️ Đặt vé thất bại")),
                                      );
                                    }
								  },	
                                  child: const Text("Xác nhận"),
                                )
                              ],
                            ),
                          );
                      },
                ),
              );
            },
          );
        },
      ),
    );
  }
}