import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/effects.dart';
import '../../constants/images.dart';
import '../../controller/controller.dart';
import '../../widgets/background.dart';
import '../../widgets/helper.dart';

class HomePageGroup extends StatefulWidget {
  const HomePageGroup({Key? key}) : super(key: key);

  @override
  State<HomePageGroup> createState() => _HomePageGroupState();
}

class _HomePageGroupState extends State<HomePageGroup> {
  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(
          backgroundImage: ImageConst.homePageGroup,
          sensitivity: Effects.loginPageSensitivity,
          blurValue: Effects.blurVeryLight,
          blackValue: Effects.blackMedium,
        ),



        // TODO: Add the joined Group chats here



      ],
    );
  }
}
