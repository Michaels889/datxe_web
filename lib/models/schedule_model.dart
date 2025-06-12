// models/schedule_model.dart
class ScheduleModel {
  final int id;
  final int routeId;
  final String departureTime;
  final int availableSeats;

  ScheduleModel({
    required this.id,
    required this.routeId,
    required this.departureTime,
    required this.availableSeats,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      routeId: json['route_id'],
      departureTime: json['departure_time'],
      availableSeats: json['available_seats'],
    );
  }
}