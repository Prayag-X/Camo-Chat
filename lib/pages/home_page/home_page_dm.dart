import 'dart:async';

import 'package:camo_chat/firebase/database.dart';
import 'package:camo_chat/pages/home_page/cards/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
  TextEditingController textController = TextEditingController(text: '');
  late StreamSubscription<bool> keyboardSubscription;
  bool keyboardOn = false;
  double keyboardSize = 300;

  @override
  void initState() {
    super.initState();
    keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        if (bottomInsets(context) != 0) {
          keyboardSize = bottomInsets(context);
        }
        keyboardOn = visible;
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

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
              : Stack(
                  children: [
                    StreamBuilder<Dm>(
                        stream:
                            database.streamDm(controller.selectedDm.value.id!),
                        builder: (_, dmSnap) {
                          if (dmSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: LoaderCircular());
                          } else {
                            Dm dm = dmSnap.data!;
                            return ListView(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                children: dm.messages
                                    .map((message) =>
                                        MessageCard(messageId: message))
                                    .toList());
                          }
                        }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          width: screenSize(context).width - 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: screenSize(context).width - 100,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 25),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(35.0)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(35.0)),
                                      hintText: 'Message',
                                      hintStyle: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Colors.white.withOpacity(0.5))),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: textController,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  database.writeMessage(controller.selectedDm.value.id!, textController.text);
                                  setState(() {
                                    textController.text = '';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    color: Themes.themeGroup.withOpacity(0.4),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: keyboardOn ? keyboardSize + 10 : 50,
                        )
                      ],
                    )
                  ],
                )),
        ],
      ),
    );
  }
}
