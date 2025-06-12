// models/route_model.dart
class RouteModel {
  final int id;
  final String name;
  final String origin;
  final String destination;

  RouteModel({required this.id, required this.name, required this.origin, required this.destination});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      name: json['name'],
      origin: json['origin'],
      destination: json['destination'],
    );
  }
}

class BookingModel {
  final int id;
  final int scheduleId;
  final int seatNumber;
  final String customerName;
  final String customerPhone;

  BookingModel({
    required this.id,
    required this.scheduleId,
    required this.seatNumber,
    required this.customerName,
    required this.customerPhone,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      scheduleId: json['schedule_id'],
      seatNumber: json['seat_number'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
    );
  }
}