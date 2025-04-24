// ignore_for_file: file_names

import 'package:smart_controller/main.dart';
import 'package:smart_controller/widgets/utilis.dart';

class UserException implements Exception {
  String cause;
  UserException(this.cause);
}

class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

class ApiExceptionHandler {
  static statusCode(
    int? statusCode,
  ) {
    final currentContext = NavigationService.navigatorKey.currentContext;

    switch (statusCode) {
      case 401:
        Utilis.snackBar(
            context: currentContext!,
            title: 'Exception',
            message: 'Something went wrong, Please try again');
      //logout
      case 400:
        Utilis.snackBar(
            context: currentContext!,
            title: 'Exception',
            message: 'Somthing went wrong, Please try again');
      case 500:
        Utilis.snackBar(
            context: currentContext!,
            title: 'Exception',
            message: 'Somthing went wrong, Please try again');
    }
  }
}
