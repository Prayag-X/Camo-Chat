import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Controller extends GetxController {
  var accelerometerEvent = AccelerometerEvent(0,0,0).obs;

  var userId = "";
  var userEmail = "";
  var userName = "";

  var showLoginPage = true.obs;
}