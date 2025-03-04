import 'package:flutter/material.dart';

class EmailSchedulesPage extends StatefulWidget {
  const EmailSchedulesPage({super.key});

  @override
  State<EmailSchedulesPage> createState() => _EmailSchedulesPageState();
}

class _EmailSchedulesPageState extends State<EmailSchedulesPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Email Schedules",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
