// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:smart_controller/constant/constant.dart';

class MutationLoader extends StatelessWidget {
  const MutationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: Constant.bgSecondary,
        radius: 10,
      ),
    );
  }
}
