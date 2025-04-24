// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/widgets/utilis.dart';

class AddADevice extends StatefulWidget {
  const AddADevice({super.key});

  @override
  State<AddADevice> createState() => _AddADeviceState();
}

class _AddADeviceState extends State<AddADevice> {
  final _formKey = GlobalKey<FormState>();
  final _userState = Get.find<UserStateController>();
  final _database = FirebaseDatabase.instance.ref();
  final _motorController = TextEditingController();
  final _motorNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _motorController.dispose();
    _motorNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Constant.bgSecondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Saron Smart',
        style: TextStyle(
          fontFamily: 'Anton',
          color: Colors.white,
          fontSize: 20.sp,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Constant.bgPrimary,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNameTextField(),
            const SizedBox(height: 16),
            _buildIdTextField(),
            const SizedBox(height: 24),
            _buildConnectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      controller: _motorNameController,
      decoration: _inputDecoration('Device Name'),
      style: _inputTextStyle(),
      validator: (value) => value?.isEmpty ?? true ? 'Enter device name' : null,
    );
  }

  Widget _buildIdTextField() {
    return TextFormField(
      controller: _motorController,
      decoration: _inputDecoration('ENTER PRODUCT ID'),
      style: _inputTextStyle(),
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true ? 'Enter product ID' : null,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Constant.bgSecondary),
      ),
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }

  TextStyle _inputTextStyle() {
    return const TextStyle(
      fontFamily: "Nunito",
      color: Constant.textPrimary,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildConnectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleDeviceConnection,
        style: ElevatedButton.styleFrom(
          backgroundColor: Constant.bgSecondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Connect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Future<void> _handleDeviceConnection() async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isLoading = true);

    try {
      await _processDeviceConnection();
    } catch (e) {
      debugPrint('Device Connection Error: $e');
      Utilis.snackBar(
        context: context,
        title: 'Error',
        message: 'Failed to process device connection',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processDeviceConnection() async {
    final ref = FirebaseDatabase.instance.ref('dS/${_motorController.text}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      // final data = Map<String, dynamic>.from(snapshot.value as Map);
      // print(data['userId']);
      // print(_userState.userId);
      await _handleExistingDevice(snapshot);
    } else {
      await _createNewDevice(ref);
    }
  }

  Future<void> _handleExistingDevice(DataSnapshot snapshot) async {
    final data = Map<String, dynamic>.from(snapshot.value as Map);

    if (data['uI'] == _userState.userId) {
      Utilis.snackBar(
          context: context,
          title: 'Device Connected',
          message: 'Your device is now connected',
          failure: false);
      context.pop();
    } else {
      Utilis.snackBar(
        context: context,
        title: 'Access Denied',
        message: 'This device is registered to another user',
      );
    }
  }

  Future<void> _createNewDevice(DatabaseReference deviceRef) async {
    await deviceRef.set({
      'aF': 0,
      'cA': DateTime.now().toString(),
      'C': 0,
      'dN': _motorNameController.text,
      'E': 0,
      'e1': false,
      'e2': false,
      'l6': 0,
      'lU': DateFormat('hh:mm a dd-MM-yyyy').format(DateTime.now()),
      'mC': false,
      'mS': false,
      'D1': 15,
      'D2': 15,
      'T1': 600,
      'T2': 600,
      'pT': 0,
      'P': 0,
      'X': false,
      'Y': false,
      'V': 0,
      'W': '',
      'U': false,
      'cT': false,
      'cS': 600,
      'cE': 600,
      'cO': 15,
      'cF': 15,
      'Z': 0,
      'uIds': {_userState.userEmailId!.split(".")[0]: true},
      'uI': _userState.userId,
    });

    Utilis.snackBar(
        context: context,
        title: 'New Device Created',
        message: 'Device registered successfully',
        failure: false);

    // Get.find<WidgetsController>().splashCompleteLogin = false;
    // Get.find<WidgetsController>().splashCompleteSelectDevice = false;
    // Get.find<WidgetsController>().splashCompleteListDevice = true;
    context.pop();
  }
}
