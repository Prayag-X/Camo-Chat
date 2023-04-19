import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:get/get.dart';

import '../../constants/effects.dart';
import '../../constants/themes.dart';
import '../../controller/controller.dart';
import '../../firebase/database.dart';
import '../../models/dm.dart';
import '../../widgets/helper.dart';
import 'home_page_dm.dart';
import 'home_page_group.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final controller = Get.find<Controller>();
  bool dmPage = true;
  bool showDmSearch = false;
  bool showGroupSearch = false;

  setChatPageDM() {
    controller.homePageDmOrGroup.value = 0;
    setState(() {
      dmPage = true;
    });
  }

  setChatPageGroup() {
    controller.homePageDmOrGroup.value = 1;
    setState(() {
      dmPage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Database().tryFunction();
    Database().initUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: appBarShared(context),
        // body: HomePageDM(),
        body: LiquidSwipe(
          fullTransitionValue: 1000,
          initialPage: 0,
          slideIconWidget: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPageChangeCallback: (currentPageNumber) {
            if (currentPageNumber == 0) {
              setChatPageDM();
            } else {
              setChatPageGroup();
            }
          },
          positionSlideIcon: 0.5,
          ignoreUserGestureWhileAnimating: true,
          enableSideReveal: true,
          preferDragFromRevealedArea: true,
          waveType: WaveType.liquidReveal,
          pages: const [
            HomePageDM(),
            HomePageGroup(),
          ],
        ),
        floatingActionButton: Obx(() =>
            (dmPage && controller.showDmOrChat.value == 0) ||
                    (!dmPage && controller.showGroupOrChat.value == 0)
                ? GestureDetector(
                    onTap: () {
                      if (dmPage) {
                        controller.showDmOrChat.value = 2;
                      } else {
                        controller.showGroupOrChat.value = 2;
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.all(20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: dmPage
                              ? Themes.themeDm.withOpacity(0.4)
                              : Themes.themeGroup.withOpacity(0.4),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  )
                : SizedBox.shrink()),
      ),
    );
  }

  AppBar appBarShared(context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.homePageDmOrGroup.value == 0 ? 'Messages' : 'Groups',
              style: TextStyle(
                fontFamily: 'Roboto', // Replace with your desired font family
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        titleSpacing: 0,
        leadingWidth: 0,
        backgroundColor: const Color(0x00000000),
        toolbarHeight: 70,
        flexibleSpace: Obx(
          () => ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: Effects.blurMedium, sigmaY: Effects.blurMedium),
              child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: Effects.appBarAnimationDuration),
                  color: controller.homePageDmOrGroup.value == 0
                      ? Themes.themeDm.withOpacity(Effects.appBarOpacityPrimary)
                      : Themes.themeGroup
                          .withOpacity(Effects.appBarOpacityPrimary),
                  child: Column(
                    children: [
                      Container(height: statusBarSize(context)),
                      Row(
                        children: [
                          (controller.showDmOrChat.value > 0) ||
                                  (controller.showGroupOrChat.value > 0)
                              ? GestureDetector(
                                  onTap: () {
                                    if (dmPage) {
                                      if (controller.showDmOrChat.value == 1) {
                                        controller.selectedDm.value =
                                            Dm(members: [], messages: []);
                                      } else {}
                                      controller.showDmOrChat.value = 0;
                                    } else {
                                      if (controller.showGroupOrChat.value ==
                                          1) {
                                      } else {}
                                    }
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 30,
                                  ),
                                )
                              : const SizedBox(
                                  width: 30,
                                ),
                          // (dmPage && controller.showDmOrChat.value == 0) ||
                          //         (!dmPage &&
                          //             controller.showGroupOrChat.value == 0)
                          //     ? GestureDetector(
                          //         onTap: () => setState(() {
                          //           controller.showDmOrChat.value = 2;
                          //         }),
                          //         child: Icon(
                          //           Icons.search,
                          //           size: 30,
                          //         ),
                          //       )
                          //     : const SizedBox(
                          //         width: 30,
                          //       ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}
