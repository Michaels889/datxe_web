// screens/route_list_screen.dart
import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/api_service.dart';
import 'schedule_screen.dart';

class RouteListScreen extends StatefulWidget {
  @override
  _RouteListScreenState createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  late Future<List<RouteModel>> _futureRoutes;

  @override
  void initState() {
    super.initState();
    _futureRoutes = ApiService.fetchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn tuyến xe")),
      body: FutureBuilder<List<RouteModel>>(
        future: _futureRoutes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("Không có tuyến nào"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final route = snapshot.data![index];
              return ListTile(
                title: Text("${route.origin} → ${route.destination}"),
                subtitle: Text(route.name),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleScreen(routeId: route.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}