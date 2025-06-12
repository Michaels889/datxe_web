import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class DriverScheduleScreen extends StatefulWidget {
  final String username;
  const DriverScheduleScreen({super.key, required this.username});

  @override
  State<DriverScheduleScreen> createState() => _DriverScheduleScreenState();
}

class _DriverScheduleScreenState extends State<DriverScheduleScreen> {
  late Future<List<ScheduleModel>> _futureSchedules;

  @override
  void initState() {
    super.initState();
    _futureSchedules = ApiService.fetchDriverSchedules(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chuyến của tôi")),
      body: FutureBuilder<List<ScheduleModel>>(
        future: _futureSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("Không có chuyến nào"));

          final schedules = snapshot.data!;
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final s = schedules[index];
              return ListTile(
                title: Text("🕑 ${s.departureTime}"),
                subtitle: Text("Ghế trống: ${s.availableSeats}"),
              );
            },
          );
        },
      ),
    );
  }
}