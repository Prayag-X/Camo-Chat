import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'controller/controller.dart';
import 'pages/login_page/login_page.dart';
import 'pages/home_page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const Routes());
  });
}

class Routes extends StatefulWidget {
  const Routes({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  var controller = Get.put(Controller());
  late StreamSubscription<AccelerometerEvent> _eventListener;

  @override
  void initState() {
    _eventListener = accelerometerEvents.listen((AccelerometerEvent event) {
      controller.accelerometerEvent.value = event;
    });
    super.initState();
  }

  @override
  void dispose() {
    _eventListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Camo Chat',
        builder: EasyLoading.init(),
        routes: {
          '/': (context) => const LoginPage(),
          '/HomePage': (context) => const HomePage(),
          // '/ChatPage': (context) => const ChatPage(),
        });
  }
}
