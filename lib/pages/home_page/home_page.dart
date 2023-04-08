import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:get/get.dart';

import '../../constants/effects.dart';
import '../../constants/themes.dart';
import '../../controller/controller.dart';
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

  setChatPageDM() {
    controller.homePageDmOrGroup.value = 0;
  }

  setChatPageGroup() {
    controller.homePageDmOrGroup.value = 1;
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



        // TODO: Add the reactive search button .. it will change colors like the app bar and show the search results of either dm or group depending on the current page



      ),
    );
  }

  AppBar appBarShared(context) {
    return AppBar(
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
                      ? Themes.appBarColorDm
                          .withOpacity(Effects.appBarOpacityPrimary)
                      : Themes.appBarColorGroup
                          .withOpacity(Effects.appBarOpacityPrimary),
                  child: Column(
                    children: [
                      Container(height: statusBarSize(context)),


                      // TODO: Add text widget to show the current page details ("DM" when in DM page, "Group" when in group page, "Search bla bla" whn in serach page, "Person or group name" when clicked on any)


                    ],
                  )),
            ),
          ),
        ));
  }
}
