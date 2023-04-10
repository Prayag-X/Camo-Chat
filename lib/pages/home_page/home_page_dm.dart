import 'package:camo_chat/firebase/database.dart';
import 'package:camo_chat/pages/home_page/cards/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/effects.dart';
import '../../constants/images.dart';
import '../../constants/themes.dart';
import '../../controller/controller.dart';
import '../../models/dm.dart';
import '../../widgets/background.dart';
import '../../widgets/helper.dart';
import '../../widgets/loaders.dart';
import 'cards/dm_card.dart';

class HomePageDM extends StatefulWidget {
  const HomePageDM({Key? key}) : super(key: key);

  @override
  State<HomePageDM> createState() => _HomePageDMState();
}

class _HomePageDMState extends State<HomePageDM> {
  final controller = Get.find<Controller>();
  final database = Database();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize(context).height,
      child: Stack(
        children: [
          Background(
            backgroundImage: ImageConst.homePageDm,
            sensitivity: Effects.loginPageSensitivity,
            blurValue: Effects.blurVeryLight,
            blackValue: Effects.blackMedium,
          ),
          Obx(() => controller.showDmOrChat.value == 0
              ? ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: controller.userData.value.dm
                      .map((dm) => DMCard(dmId: dm))
                      .toList())
              : StreamBuilder<Dm>(
                  stream: database.streamDm(controller.selectedDm.value.id!),
                  builder: (_, dmSnap) {
                    if (dmSnap.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoaderCircular());
                    } else {
                      Dm dm = dmSnap.data!;
                      return ListView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: dm.messages
                              .map((message) => MessageCard(messageId: message))
                              .toList());
                    }
                  })),
        ],
      ),
    );
  }
}
