import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workplace_notes/features/notes/screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('notesBox');

  await NotificationService.init();

  runApp(const WorkplaceNotes());
}

class WorkplaceNotes extends StatelessWidget {
  const WorkplaceNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workplace Notes',
      home: SplashScreen(),
    );
  }
}
