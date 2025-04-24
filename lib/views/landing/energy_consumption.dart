// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/model/motoModel.dart';

class EnergyConsumption extends StatefulWidget {
  final String motorId;
  const EnergyConsumption({super.key, required this.motorId});

  @override
  State<EnergyConsumption> createState() => _EnergyConsumptionState();
}

class _EnergyConsumptionState extends State<EnergyConsumption>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final userState = Get.put(UserStateController());
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  Stream<DeviceModel> get motorStream {
    if (widget.motorId == null) return const Stream.empty();

    return _database.child('dS/${widget.motorId}').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return DeviceModel.fromJson(widget.motorId, data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        backgroundColor: Constant.bgPrimary,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Constant.bgPrimary,
          centerTitle: true,
          title: Constant.textWithStyle(
            text: 'Energy Consumption',
            size: 18.sp,
            fontWeight: FontWeight.w900,
            color: Constant.textPrimary,
          ),
        ),
        body: widget.motorId == null
            ? const Center(child: Text('No motor selected'))
            : Container(
                height: 100.h,
                width: 100.w,
                color: Constant.bgPrimary,
                child: StreamBuilder<DeviceModel>(
                  stream: motorStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final energyData = snapshot.data!;
                    return _buildMainContent(energyData);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildMainContent(DeviceModel energyData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Constant.bgPrimary,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 3.h),
            Constant.textWithStyle(
              text: energyData.deviceName,
              color: Constant.bgSecondary,
              size: 18.sp,
              fontWeight: FontWeight.w700,
            ),
            Constant.textWithStyle(
              text: 'Today\'s Consumption:',
              size: 16.sp,
              fontWeight: FontWeight.w600,
              color: Constant.textPrimary,
            ),
            SizedBox(height: 5.h),
            _buildEnergyCard(
                'Today\'s Energy Consumption', '${energyData.energy} kwh'),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Current(A)', energyData.current.toString()),
                _buildMetricCard('Power(W)', energyData.todayPower.toString()),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Voltage(V)', energyData.voltage.toString()),
                _buildMetricCard(
                    '60 Days(kwh)', energyData.last60Days.toString()),
              ],
            ),
            SizedBox(height: 3.h),
            _buildEnergyCard('Today\'s Pumping Time',
                energyData.todayPumpingTime.toString()),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyCard(String title, String value) {
    return Container(
      width: 80.w,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Constant.bgPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(-3, -3),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(3, 3),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Constant.textWithStyle(
            text: title,
            size: 16.sp,
            fontWeight: FontWeight.w600,
            color: Constant.textSecondary,
          ),
          SizedBox(height: 0.5.h),
          Constant.textWithStyle(
            text: value,
            size: 18.sp,
            fontWeight: FontWeight.bold,
            color: Constant.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Constant.bgPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(-3, -3),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(3, 3),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Constant.textWithStyle(
            text: title,
            size: 16.sp,
            fontWeight: FontWeight.w600,
            color: Constant.textSecondary,
          ),
          SizedBox(height: 0.5.h),
          Constant.textWithStyle(
            text: value,
            size: 18.sp,
            fontWeight: FontWeight.bold,
            color: Constant.textPrimary,
          ),
        ],
      ),
    );
  }
}

// class EnergyModel {
//   final String motorControl;
//   final String energyConsume;
//   final String current;
//   final String power;
//   final String voltage;
//   final String pumpingTime;
//   final String totalEnergyConsumed;

//   EnergyModel({
//     required this.motorControl,
//     required this.energyConsume,
//     required this.current,
//     required this.power,
//     required this.voltage,
//     required this.pumpingTime,
//     required this.totalEnergyConsumed,
//   });

//   factory EnergyModel.fromMap(
//       Map<dynamic, dynamic> deviceData, String totalEnergy) {
//     return EnergyModel(
//       motorControl: deviceData['motorControl']?.toString() ?? '0',
//       energyConsume: deviceData['energy']?.toString() ?? '0',
//       current: deviceData['currentValue']?.toString() ?? '0',
//       power: deviceData['power']?.toString() ?? '0',
//       voltage: deviceData['voltage']?.toString() ?? '0',
//       pumpingTime: deviceData['pumpingTime']?.toString() ?? '0',
//       totalEnergyConsumed: totalEnergy,
//     );
//   }
// }
