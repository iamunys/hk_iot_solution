import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';

class EnergyConsume extends StatelessWidget {
  final String energy;
  const EnergyConsume({super.key, required this.energy});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                text: 'Energy Consumption',
                size: 14.sp,
                color: Constant.textSecondary),
            SizedBox(
              height: .5.h,
            ),
            Constant.textWithStyle(
                text: '$energy kwh', size: 16.sp, color: Constant.bgSecondary),
          ],
        ));
  }
}
