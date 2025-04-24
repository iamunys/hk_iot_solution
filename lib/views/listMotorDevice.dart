// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/model/motoModel.dart';

class ListDeviceScreen extends StatefulWidget {
  const ListDeviceScreen({super.key});

  @override
  _ListDeviceScreenState createState() => _ListDeviceScreenState();
}

class _ListDeviceScreenState extends State<ListDeviceScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFirstOpen = true;
  List<bool> isRefereshing = [];

  List<String> formattedTime = [];

  DatabaseReference get _devicesRef =>
      FirebaseDatabase.instance.ref().child('dS');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgPrimary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgSecondary,
        centerTitle: false,
        elevation: 5,
        title: Constant.textWithStyle(
            fontWeight: FontWeight.w900,
            text: 'Choose your device',
            size: 18.sp,
            color: Constant.bgWhite),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/addDevice');
            },
            icon: Icon(
              Icons.add,
              size: 22.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 2.w)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<DatabaseEvent>(
          stream: _devicesRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return noDeviceWid();
            }

            final devicesMap =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            final devices = devicesMap.entries.where((entry) {
              final deviceData = entry.value as Map<dynamic, dynamic>;

              if (deviceData.containsKey('uIds')) {
                final userIdsMap = deviceData['uIds'] as Map<dynamic, dynamic>;
                return userIdsMap.containsKey(user!.email!.split(".")[0]);
              }
              return false;
            }).map((entry) {
              return DeviceModel.fromJson(
                  entry.key as String, entry.value as Map<dynamic, dynamic>);
            }).toList();
            if (devices.isEmpty) {
              return noDeviceWid();
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: List.generate(
                    devices.length,
                    (index) {
                      if (isRefereshing.length < devices.length) {
                        isRefereshing.add(false);
                      }
                      final device = devices[index];
                      return deviceGridItem(device: device, index: index);
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget deviceGridItem({required DeviceModel device, required int index}) {
    return Card(
      color: Constant.bgWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          context.push('/landing', extra: device.deviceId);
        },
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                ListTile(
                  minVerticalPadding: 0,
                  minTileHeight: 0,
                  contentPadding: EdgeInsets.zero,
                  title: Constant.textWithStyle(
                    fontWeight: FontWeight.w700,
                    text: device.deviceName,
                    size: 16.sp,
                    color: Constant.textPrimary,
                  ),
                  subtitle:
                      tankStatusWidget(motorId: device.systemCurrentStatus),
                  leading: Image.asset('lib/constant/icons/battery.png',
                      color: Constant.bgSecondary, scale: 3),
                  trailing: Switch(
                    value: device.motorControll == true,
                    onChanged: (value) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('dS')
                          .child(device.deviceId)
                          .update({'mC': value});
                    },
                    activeColor: Constant.bgSecondary,
                    inactiveTrackColor: Constant.bgPrimary,
                    inactiveThumbColor: Constant.textPrimary,
                    activeTrackColor: Constant.bgSecondary.withOpacity(.4),
                  ),
                ),
                SizedBox(height: 2.h),
                Constant.textWithStyle(
                  text: 'Last Updated : ${device.lastUpdate}',
                  color: Constant.textPrimary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                refereshButton(device: device, index: index),
              ],
            )),
      ),
    );
  }

  tankStatusWidget({required String motorId}) {
    if (motorId != '') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Constant.textWithStyle(
            text: 'Status : ',
            color: Constant.textPrimary,
            size: 15.sp,
            fontWeight: FontWeight.w700,
          ),
          Constant.textWithStyle(
            text: motorId,
            color: Constant.bgOrange,
            size: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ],
      );
    }
  }

  refereshButton({required DeviceModel device, required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isRefereshing[index] = true;
            });
            if (device.deviceStatus == true) {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(device.deviceId)
                  .update({'U': false});
            } else {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(device.deviceId)
                  .update({'U': true});
            }
            //   _showMessage('Refreshing', isOn: true);
            Timer(const Duration(seconds: 2), () {
              setState(() {
                isRefereshing[index] = false;
              });
            });
          },
          child: Row(
            children: [
              if (isRefereshing[index])
                const CupertinoActivityIndicator(
                  color: Constant.bgSecondary,
                )
              else
                Icon(
                  Icons.refresh_rounded,
                  color: Constant.bgSecondary,
                  size: 20.sp,
                ),
              SizedBox(width: 2.w),
              Constant.textWithStyle(
                text: 'Refresh',
                color: Constant.textPrimary,
                size: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget noDeviceWid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/constant/icons/motor.png',
            color: Constant.textPrimary, scale: 6),
        SizedBox(height: 1.h),
        Constant.textWithStyle(
            text: 'No Device found',
            size: 17.sp,
            color: Constant.textPrimary,
            fontWeight: FontWeight.w600),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => context.go('/addDevice'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Constant.bgSecondary),
                ),
                child: Center(
                  child: Constant.textWithStyle(
                      text: 'Add Devices',
                      size: 16.sp,
                      color: Constant.bgSecondary,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        InkWell(
          onTap: () => context.push('/profile'),
          child: Center(
            child: Constant.textWithStyle(
                text: 'Settings -->',
                size: 15.sp,
                color: Constant.textSecondary,
                fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}
