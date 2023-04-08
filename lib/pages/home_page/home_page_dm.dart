import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/effects.dart';
import '../../constants/images.dart';
import '../../controller/controller.dart';
import '../../widgets/background.dart';
import '../../widgets/helper.dart';

class HomePageDM extends StatefulWidget {
  const HomePageDM({Key? key}) : super(key: key);

  @override
  State<HomePageDM> createState() => _HomePageDMState();
}

class _HomePageDMState extends State<HomePageDM> {
  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(
          backgroundImage: ImageConst.homePageDm,
          sensitivity: Effects.loginPageSensitivity,
          blurValue: Effects.blurVeryLight,
          blackValue: Effects.blackMedium,
        ),



        // TODO: Add the available DM chats here



      ],
    );
  }
}
