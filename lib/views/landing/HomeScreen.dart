// ignore_for_file: file_names, depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/model/motoModel.dart';
import 'package:smart_controller/widgets/utilis.dart';

class HomeScreen extends StatefulWidget {
  final String motorId;
  const HomeScreen({super.key, required this.motorId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  bool isFirstOpen = true;
  bool isFirstCyclic = true;
  bool isRefereshing = false;
  List<TextEditingController> minuteController = List.generate(
    4,
    (index) => TextEditingController(text: '0'),
  );

  // List<TimeOfDay>? selectedTime = List.generate(
  //   3,
  //   (index) => const TimeOfDay(hour: 00, minute: 0),
  // );
  List<String> formattedTime = List.generate(
    4,
    (index) => '6:00 AM',
  );

  List<String> formattedTime24 = List.generate(
    4,
    (index) => '6:00 AM',
  );

  String selectedUnitFrame = 'Hour(s)';

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
        // appBar: _buildAppBar(),
        body: widget.motorId == null
            ? const Center(child: Text('No motor selected'))
            : SafeArea(child: _buildMainContent()),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
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

          final motor = snapshot.data!;
          return Column(
            children: [
              _buildTitleBar(motor),
              Expanded(child: _buildControlInterface(motor)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlInterface(DeviceModel motor) {
    return SingleChildScrollView(
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStatusText(motor),
            SizedBox(height: 1.h),
            powerButton(motor),
            SizedBox(height: 1.h),
            Constant.textWithStyle(
              fontWeight: FontWeight.w700,
              text: motor.motorStatus == false ? 'Pump OFF' : 'Pump ON',
              size: 16.sp,
              color: motor.motorStatus == false
                  ? Constant.bgRed
                  : Constant.bgGreen,
            ),
            SizedBox(height: 1.h),
            Constant.textWithStyle(
                text: 'Last Updated : ${motor.lastUpdate}',
                color: Constant.textSecondary,
                size: 14.sp,
                fontWeight: FontWeight.w600),
            SizedBox(height: 1.h),
            dropBoxAutoOff(motor),
            SizedBox(height: 1.h),
            buildTimerShedule(motor),
            SizedBox(height: 1.h),
            buildCyclicShedule(motor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(DeviceModel motor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isRefereshing = true;
            });
            if (motor.deviceStatus == true) {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(motor.deviceId)
                  .update({'U': false});
            } else {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(motor.deviceId)
                  .update({'U': true});
            }
            _showMessage('Refreshing', isOn: true);
            Timer(const Duration(seconds: 2), () {
              setState(() {
                isRefereshing = false;
              });
            });
          },
          child: Row(
            children: [
              if (isRefereshing)
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
                size: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        // Constant.textWithStyle(
        //   fontWeight: FontWeight.w700,
        //   text: motor.motorStatus == 0 ? '        Pump OFF' : '        Pump ON',
        //   size: 15.sp,
        //   color: motor.motorStatus == 0 ? Constant.bgRed : Constant.bgGreen,
        // ),
        if (motor.systemCurrentStatus != '')
          tankStatusWidget(motorId: motor.systemCurrentStatus),
      ],
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Constant.textWithStyle(
          text: message,
          color: Constant.bgWhite,
          size: 16.sp,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showMessage(String message, {required bool isOn}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        backgroundColor: isOn ? Constant.bgGreen : Constant.bgRed,
        content: Constant.textWithStyle(
          text: message,
          color: Constant.bgWhite,
          size: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  buildTimeWid(bool enableTimer, int index, String title) {
    return enableTimer == false
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: title,
                  color: Constant.textSecondary,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: .5.h),
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Constant.textPrimary,
                              onPrimary: Constant.bgPrimary,
                              onSurface: Constant.textPrimary,
                            ),
                            timePickerTheme: TimePickerThemeData(
                              dayPeriodColor:
                                  WidgetStateColor.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Constant
                                      .textPrimary; // Color when AM/PM is selected
                                }
                                return Constant
                                    .textSecondary; // Color when AM/PM is not selected
                              }),
                              dayPeriodTextColor:
                                  WidgetStateColor.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Constant
                                      .textSecondary; // Text color when selected
                                }
                                return Colors
                                    .black; // Text color when not selected
                              }),

                              dialBackgroundColor:
                                  Constant.bgPrimary, // Clock face background
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      setState(() {
                        // selectedTime![index] = pickedTime;
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day,
                            pickedTime.hour, pickedTime.minute);
                        formattedTime[index] = DateFormat('hh:mm a').format(dt);
                        formattedTime24[index] = DateFormat('HHmm').format(dt);
                        print(
                            '${formattedTime[index]} ${formattedTime24[index]}');
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Constant.textPrimary)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 6.w,
                          width: 6.w,
                          child: const Center(child: Icon(Icons.timer)),
                        ),
                        SizedBox(width: 1.w),
                        Constant.textWithStyle(
                          text: '${formattedTime[index]} ',
                          color: Constant.textPrimary,
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: Constant.textSecondary,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: title,
                  color: Constant.textSecondary,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: .5.h),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textSecondary)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 6.w,
                        width: 6.w,
                        child: const Center(
                            child: Icon(
                          Icons.timer,
                          color: Constant.textSecondary,
                        )),
                      ),
                      SizedBox(width: 1.w),
                      Constant.textWithStyle(
                        text: '${formattedTime[index]} ',
                        color: Constant.textSecondary,
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                        color: Constant.textSecondary,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  buildPeriodWid(bool enableTimer, int index, String title) {
    return enableTimer == false
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: title,
                  color: Constant.textSecondary,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: .5.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textPrimary)),
                  child: TextFormField(
                    controller: minuteController[index],
                    cursorColor: Constant.textPrimary,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Minutes',
                      hintStyle: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textPrimary,
                        fontSize: 16.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textPrimary,
                      fontSize: 16.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: title,
                  color: Constant.textSecondary,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: .5.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textSecondary)),
                  child: TextFormField(
                    enabled: false,
                    controller: minuteController[index],
                    cursorColor: Constant.textPrimary,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Minutes',
                      hintStyle: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textSecondary,
                        fontSize: 16.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textSecondary,
                      fontSize: 16.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  _buildTitleBar(DeviceModel motor) {
    return SizedBox(
      height: 7.h,
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Constant.textPrimary,
          ),
          Constant.textWithStyle(
            text: motor.deviceName,
            color: Constant.textPrimary,
            size: 18.sp,
            fontWeight: FontWeight.w900,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Constant.bgPrimary,
          ),
        ],
      ),
    );
  }

  tankStatusWidget({required String motorId}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Constant.textWithStyle(
          text: 'Status: ',
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

  powerButton(DeviceModel motor) {
    return Container(
      decoration: BoxDecoration(
        color: Constant.bgPrimary,
        shape: BoxShape.circle,
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
      child: IconButton(
        padding: const EdgeInsets.all(0),
        hoverColor: Constant.bgPrimary,
        focusColor: Constant.bgPrimary,
        splashColor: Constant.bgPrimary,
        highlightColor: Constant.bgPrimary,
        icon: const Icon(Icons.power_settings_new),
        onPressed: () async {
          HapticFeedback.mediumImpact();
          try {
            if (motor.motorControll == true) {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(motor.deviceId)
                  .update({'mC': false});
              _showMessage('Motor is off', isOn: false);
            } else {
              FirebaseDatabase.instance
                  .ref()
                  .child('dS')
                  .child(motor.deviceId)
                  .update({'mC': true});
              _showMessage('Motor is on', isOn: true);
            }
          } catch (e) {
            _showError('Update failed: $e');
          }
        },
        color: motor.motorControll == false ? Constant.bgRed : Constant.bgGreen,
        iconSize: 48.sp,
      ),
    );
  }

  dropBoxAutoOff(DeviceModel motor) {
    return Container(
      height: 5.h,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Constant.bgWhite, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Constant.textWithStyle(
            text: 'Auto Off Time :',
            color: Constant.bgGreen,
            size: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(width: 3.w),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: Constant.bgPrimary,
              value: motor.aOffTimer.toInt(),
              onChanged: (int? newValue) {
                FirebaseDatabase.instance
                    .ref()
                    .child('dS')
                    .child(motor.deviceId)
                    .update({'aF': newValue});
              },
              items: List.generate(240, (index) => index) // 1 to 250
                  .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Constant.textWithStyle(
                        text: value.toString(),
                        color: Constant.bgRed,
                        size: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                  .toList(),
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTimerShedule(DeviceModel motor) {
    return Column(
      children: List.generate(2, (index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isFirstOpen) {
            setState(() {
              if (index == 0) {
                formattedTime[index] =
                    Utilis.formatTime(motor.timer1StartTime.toInt().toString());
                formattedTime24[index] =
                    motor.timer1StartTime.toInt().toString();
                minuteController[index].text =
                    motor.timer1Duration.toInt().toString();
              } else {
                formattedTime[index] =
                    Utilis.formatTime(motor.timer2StartTime.toInt().toString());
                formattedTime24[index] =
                    motor.timer2StartTime.toInt().toString();
                minuteController[index].text =
                    motor.timer2Duration.toInt().toString();
                isFirstOpen = false;
              }
              // else {
              //   formattedTime[index] = Utilis.formatTime(
              //       motor.cyclicTimeStart.toInt().toString());
              //   formattedTime24[index] =
              //       motor.cyclicTimeStart.toInt().toString();
              //   minuteController[index].text =
              //       motor.cyclicTimeOnDuration.toString();
              //   minuteController[index + 1].text =
              //       motor.cyclicTimeOffDuration.toString();
              // }
            });
          }
        });
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          decoration: BoxDecoration(
              color: Constant.bgWhite, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              if (index == 0
                  ? motor.enableTimer1 == true
                  : motor.enableTimer2 == true)
                if (index == 0
                    ? motor.timer1Done == true
                    : motor.timer2Done == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Constant.textWithStyle(
                        text: 'Done',
                        color: Constant.textPrimary,
                        size: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Constant.textWithStyle(
                        text: 'Not Done',
                        color: Constant.textPrimary,
                        size: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
              SizedBox(height: 1.h),
              Constant.textWithStyle(
                text: 'Schedule - ${index + 1}',
                color: Constant.textPrimary,
                size: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  buildTimeWid(
                      index == 0 ? motor.enableTimer1 : motor.enableTimer2,
                      index,
                      'Start time'),
                  SizedBox(width: 2.w),
                  buildPeriodWid(
                      index == 0 ? motor.enableTimer1 : motor.enableTimer2,
                      index,
                      'Duration (Minutes)'),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (index == 0
                      ? motor.enableTimer1 == true
                      : motor.enableTimer2 == true)
                    Constant.textWithStyle(
                      text: 'Timer scheduled',
                      color: Constant.bgSecondary,
                      size: 16.sp,
                      fontWeight: FontWeight.w600,
                    )
                  else
                    Constant.textWithStyle(
                      text: 'Timer not scheduled',
                      color: Constant.bgRed,
                      size: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  Switch(
                    value: index == 0
                        ? motor.enableTimer1 == true
                        : motor.enableTimer2 == true,
                    onChanged: (value) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('dS')
                          .child(motor.deviceId)
                          .update({'e${index + 1}': value});
                      print('dfsfsadsf:${formattedTime24[index]}');

                      FirebaseDatabase.instance
                          .ref()
                          .child('dS')
                          .child(motor.deviceId)
                          .update({
                        'T${index + 1}': double.parse(formattedTime24[index])
                      });
                      FirebaseDatabase.instance
                          .ref()
                          .child('dS')
                          .child(motor.deviceId)
                          .update({
                        'D${index + 1}':
                            double.parse(minuteController[index].text)
                      });
                    },
                    activeColor: Constant.bgSecondary,
                    inactiveTrackColor: Constant.bgPrimary,
                    inactiveThumbColor: Constant.textPrimary,
                    activeTrackColor: Constant.bgSecondary.withOpacity(.4),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  buildCyclicShedule(DeviceModel motor) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFirstCyclic) {
        setState(() {
          formattedTime[2] =
              Utilis.formatTime(motor.cyclicTimeStart.toInt().toString());
          formattedTime24[2] = motor.cyclicTimeStart.toInt().toString();
          formattedTime[3] =
              Utilis.formatTime(motor.cyclicTimeStartEnd.toInt().toString());
          formattedTime24[3] = motor.cyclicTimeStartEnd.toInt().toString();
          minuteController[2].text =
              motor.cyclicTimeOnDuration.toInt().toString();
          minuteController[3].text =
              motor.cyclicTimeOffDuration.toInt().toString();
          isFirstCyclic = false;
        });
      }
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
          color: Constant.bgWhite, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   width: 8,
              //   height: 8,
              //   decoration: const BoxDecoration(
              //     color: Constant.bgSecondary,
              //     shape: BoxShape.circle,
              //   ),
              // ),
              SizedBox(width: 1.w),
              Constant.textWithStyle(
                text: 'Motor On Count : ${motor.cyclicTimeCount.toInt()}',
                color: Constant.textPrimary,
                size: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Constant.textWithStyle(
            text: 'Cyclic Timer',
            color: Constant.textPrimary,
            size: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              buildTimeWid(motor.cyclicTimerEnable, 2, 'Start time'),
              SizedBox(width: 2.w),
              buildTimeWid(motor.cyclicTimerEnable, 3, 'End time'),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              buildPeriodWid(motor.cyclicTimerEnable, 2, 'On Duration (Min)'),
              SizedBox(width: 2.w),
              buildPeriodWid(motor.cyclicTimerEnable, 3, 'Off Duration (Min)'),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (motor.cyclicTimerEnable == true)
                Constant.textWithStyle(
                  text: 'Cyclic timer scheduled',
                  color: Constant.bgSecondary,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                )
              else
                Constant.textWithStyle(
                  text: 'Cyclic timer not scheduled',
                  color: Constant.bgRed,
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              Switch(
                value: motor.cyclicTimerEnable == true,
                onChanged: (value) {
                  FirebaseDatabase.instance
                      .ref()
                      .child('dS')
                      .child(motor.deviceId)
                      .update({'cT': value});

                  FirebaseDatabase.instance
                      .ref()
                      .child('dS')
                      .child(motor.deviceId)
                      .update({'cS': double.parse(formattedTime24[2])});
                  print(double.parse(formattedTime24[2]));

                  FirebaseDatabase.instance
                      .ref()
                      .child('dS')
                      .child(motor.deviceId)
                      .update({'cE': double.parse(formattedTime24[3])});
                  FirebaseDatabase.instance
                      .ref()
                      .child('dS')
                      .child(motor.deviceId)
                      .update({'cO': double.parse(minuteController[2].text)});
                  FirebaseDatabase.instance
                      .ref()
                      .child('dS')
                      .child(motor.deviceId)
                      .update({'cF': double.parse(minuteController[3].text)});
                },
                activeColor: Constant.bgSecondary,
                inactiveTrackColor: Constant.bgPrimary,
                inactiveThumbColor: Constant.textPrimary,
                activeTrackColor: Constant.bgSecondary.withOpacity(.4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
