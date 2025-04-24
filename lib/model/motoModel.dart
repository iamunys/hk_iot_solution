// class DeviceModel {
//   final String deviceId;
//   final String lastUpdate;
//   final String deviceName;
//   final bool motorControl;
//   final double motorStatus;
//   final double energyConsume;
//   final String waterLevel;
//   final double current;
//   final double power;
//   final double voltage;
//   final double pumpingTime;
//   final double enableTimer1;
//   final double enableTimer2;
//   final double enableTimer3;
//   final double onTime1;
//   final double onTime2;
//   final double onTime3;
//   final double onDuration1;
//   final double onDuration2;
//   final double onDuration3;
//   final double timer1Done;
//   final double timer2Done;
//   final double timer3Done;
//   final double last60Daysusage;
//   final double autoOffTimer;

//   DeviceModel(
//       {required this.deviceId,
//       required this.lastUpdate,
//       required this.deviceName,
//       required this.motorControl,
//       required this.motorStatus,
//       required this.waterLevel,
//       required this.energyConsume,
//       required this.current,
//       required this.power,
//       required this.voltage,
//       required this.pumpingTime,
//       required this.enableTimer1,
//       required this.enableTimer2,
//       required this.enableTimer3,
//       required this.onTime1,
//       required this.onTime2,
//       required this.onTime3,
//       required this.onDuration1,
//       required this.onDuration2,
//       required this.onDuration3,
//       required this.timer1Done,
//       required this.timer2Done,
//       required this.timer3Done,
//       required this.last60Daysusage,
//       required this.autoOffTimer});

//   factory DeviceModel.fromMap(String deviceId, Map<dynamic, dynamic> map) {
//     return DeviceModel(
//       deviceId: deviceId,
//       lastUpdate: map['lU'] ?? '',
//       deviceName: map['dN'] ?? '',
//       motorControl: (map['mC'] ?? 0).toDouble(),
//       motorStatus: (map['mS'] ?? 0).toDouble(),
//       waterLevel: (map['W'] as String?) ?? 'low',
//       energyConsume: (map['E'] ?? 0).toDouble(),
//       current: (map['C'] ?? 0).toDouble(),
//       power: (map['P'] ?? 0).toDouble(),
//       voltage: (map['V'] ?? 0).toDouble(),
//       pumpingTime: (map['pT'] ?? 0).toDouble(),
//       enableTimer1: (map['e1'] ?? 0).toDouble(),
//       enableTimer2: (map['e2'] ?? 0).toDouble(),
//       enableTimer3: (map['e3'] ?? 0).toDouble(),
//       onTime1: (map['T1'] ?? 0).toDouble(),
//       onTime2: (map['T2'] ?? 0).toDouble(),
//       onTime3: (map['T3'] ?? 0).toDouble(),
//       onDuration1: (map['D1'] ?? 0).toDouble(),
//       onDuration2: (map['D2'] ?? 0).toDouble(),
//       onDuration3: (map['D3'] ?? 0).toDouble(),
//       timer1Done: (map['x'] ?? 0).toDouble(),
//       timer2Done: (map['y'] ?? 0).toDouble(),
//       timer3Done: (map['z'] ?? 0).toDouble(),
//       last60Daysusage: (map['l6'] ?? 0).toDouble(),
//       autoOffTimer: (map['aF'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'deviceId': deviceId,
//       'lU': lastUpdate,
//       'dN': deviceName,
//       'e1': enableTimer1,
//       'e2': enableTimer2,
//       'e3': enableTimer3,
//       'mC': motorControl,
//       'mS': motorStatus,
//       'D1': onDuration1,
//       'D2': onDuration2,
//       'D3': onDuration3,
//       'T1': onTime1,
//       'T2': onTime2,
//       'T3': onTime3,
//       'P': power,
//       'pT': pumpingTime,
//       'x': timer1Done,
//       'y': timer2Done,
//       'z': timer3Done,
//       'V': voltage,
//       'W': waterLevel,
//       'l6': last60Daysusage,
//       'aF': autoOffTimer
//     };
//   }
// }
class DeviceModel {
  String deviceId;
  double aOffTimer;
  String createAt;
  double current;
  String deviceName;
  double energy;
  bool enableTimer1;
  bool enableTimer2;
  double last60Days;
  String lastUpdate;
  bool motorControll;
  bool motorStatus;
  double timer1Duration;
  double timer2Duration;
  double timer1StartTime;
  double timer2StartTime;
  double todayPumpingTime;
  double todayPower;
  bool timer1Done;
  bool timer2Done;
  double voltage;
  String systemCurrentStatus;
  bool deviceStatus;
  bool cyclicTimerEnable;
  double cyclicTimeStart;
  double cyclicTimeStartEnd;
  double cyclicTimeOnDuration;
  double cyclicTimeOffDuration;
  double cyclicTimeCount;
  Map<String, bool> userIds;
  String userId;

  DeviceModel({
    required this.deviceId,
    required this.aOffTimer,
    required this.createAt,
    required this.current,
    required this.deviceName,
    required this.energy,
    required this.enableTimer1,
    required this.enableTimer2,
    required this.last60Days,
    required this.lastUpdate,
    required this.motorControll,
    required this.motorStatus,
    required this.timer1Duration,
    required this.timer2Duration,
    required this.timer1StartTime,
    required this.timer2StartTime,
    required this.todayPumpingTime,
    required this.todayPower,
    required this.timer1Done,
    required this.timer2Done,
    required this.voltage,
    required this.systemCurrentStatus,
    required this.deviceStatus,
    required this.cyclicTimerEnable,
    required this.cyclicTimeStart,
    required this.cyclicTimeStartEnd,
    required this.cyclicTimeOnDuration,
    required this.cyclicTimeOffDuration,
    required this.cyclicTimeCount,
    required this.userIds,
    required this.userId,
  });

  factory DeviceModel.fromJson(String deviceId, Map<dynamic, dynamic> json) {
    return DeviceModel(
      deviceId: deviceId,
      aOffTimer: (json['aF'] ?? 0).toDouble(),
      createAt: json['cA'] ?? '',
      current: (json['C'] ?? 0).toDouble(),
      deviceName: json['dN'] ?? '',
      energy: (json['E'] ?? 0).toDouble(),
      enableTimer1: json['e1'] ?? false,
      enableTimer2: json['e2'] ?? false,
      last60Days: (json['l6'] ?? 0).toDouble(),
      lastUpdate: json['lU'] ?? '',
      motorControll: json['mC'] ?? false,
      motorStatus: json['mS'] ?? false,
      timer1Duration: (json['D1'] ?? 0).toDouble(),
      timer2Duration: (json['D2'] ?? 0).toDouble(),
      timer1StartTime: (json['T1'] ?? 0).toDouble(),
      timer2StartTime: (json['T2'] ?? 0).toDouble(),
      todayPumpingTime: (json['pT'] ?? 0).toDouble(),
      todayPower: (json['p'] ?? 0).toDouble(),
      timer1Done: json['X'] ?? false,
      timer2Done: json['Y'] ?? false,
      voltage: (json['V'] ?? 0).toDouble(),
      systemCurrentStatus: json['W'] ?? '',
      deviceStatus: json['U'] ?? false,
      cyclicTimerEnable: json['cT'] ?? false,
      cyclicTimeStart: (json['cS'] ?? 0).toDouble(),
      cyclicTimeStartEnd: (json['cE'] ?? 0).toDouble(),
      cyclicTimeOnDuration: (json['cO'] ?? 0).toDouble(),
      cyclicTimeOffDuration: (json['cF'] ?? 0).toDouble(),
      cyclicTimeCount: (json['Z'] ?? 0).toDouble(),
      userIds: Map<String, bool>.from(json['uIds'] ?? {}),
      userId: json['uI'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'aF': aOffTimer,
      'cA': createAt,
      'C': current,
      'dN': deviceName,
      'E': energy,
      'e1': enableTimer1,
      'e2': enableTimer2,
      'l6': last60Days,
      'lU': lastUpdate,
      'mC': motorControll,
      'mS': motorStatus,
      'D1': timer1Duration,
      'D2': timer2Duration,
      'T1': timer1StartTime,
      'T2': timer2StartTime,
      'pT': todayPumpingTime,
      'p': todayPower,
      'X': timer1Done,
      'Y': timer2Done,
      'V': voltage,
      'W': systemCurrentStatus,
      'U': deviceStatus,
      'cT': cyclicTimerEnable,
      'cS': cyclicTimeStart,
      'cE': cyclicTimeStartEnd,
      'cO': cyclicTimeOnDuration,
      'cF': cyclicTimeOffDuration,
      'Z': cyclicTimeCount,
      'uIds': userIds,
      'uI': userId,
    };
  }
}
