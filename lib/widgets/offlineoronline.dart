// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';

class CounterStatusWidget extends StatefulWidget {
  final String motorId;

  const CounterStatusWidget({super.key, required this.motorId});

  @override
  _CounterStatusWidgetState createState() => _CounterStatusWidgetState();
}

class _CounterStatusWidgetState extends State<CounterStatusWidget> {
  int? _currentCounter;
  DateTime? _lastUpdateTime;
  bool _isCounterActive = false;
  StreamSubscription<DatabaseEvent>? _counterSubscription;
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _setupCounterStream();
  }

  void _setupCounterStream() {
    DatabaseReference counterRef =
        FirebaseDatabase.instance.ref('dS/${widget.motorId}/cNT');

    // Listen to counter updates from Firebase
    _counterSubscription = counterRef.onValue.listen((event) {
      if (!mounted) return;

      final data = event.snapshot.value;
      int? parsedCounter;

      if (data is String) {
        parsedCounter = int.tryParse(data);
      } else if (data is int) {
        parsedCounter = data;
      }

      if (parsedCounter != null) {
        setState(() {
          _currentCounter = parsedCounter;
          _lastUpdateTime = DateTime.now();
          _isCounterActive = true; // Set to online as soon as new data arrives
        });
      }
    });

    // Check counter status every 1 second
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        _checkCounterStatus();
      }
    });
  }

  void _checkCounterStatus() {
    if (_lastUpdateTime != null) {
      final timeSinceLastUpdate = DateTime.now().difference(_lastUpdateTime!);
      print(timeSinceLastUpdate.inSeconds);
      if (mounted) {
        setState(() {
          _isCounterActive = timeSinceLastUpdate.inSeconds < 10;
        });
        // print(_isCounterActive);
      }
    }
  }

  @override
  void dispose() {
    _counterSubscription?.cancel();
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: _isCounterActive ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3),
        Constant.textWithStyle(
          fontWeight: FontWeight.w700,
          text: _isCounterActive ? 'Online' : 'Offline',
          size: 15.sp,
          color: _isCounterActive ? Constant.bgGreen : Constant.bgRed,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
