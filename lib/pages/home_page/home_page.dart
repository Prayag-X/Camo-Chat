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

  setChatPageDM() {
    controller.homePageDmOrGroup.value = 0;
  }

  setChatPageGroup() {
    controller.homePageDmOrGroup.value = 1;
  }

  @override
  void initState() {
    super.initState();
    Database().tryFunction();
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
    final controller = Get.find<Controller>();
    final double originalAppBarHeight = 70.0;
    double appBarHeight = controller.showSearchField.value
        ? 150.0
        : originalAppBarHeight;

    // Listen for changes to the `showSearchField` property
    ever(controller.showSearchField, (bool showSearchField) {
      appBarHeight = showSearchField ? 150.0 : originalAppBarHeight;
    });

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
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () =>
            Scaffold.of(context).openDrawer(), // TODO: Open navigation drawer from here
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            controller.showSearchField.value = !controller.showSearchField.value;
          },
        ),
      ],
      automaticallyImplyLeading: false,
      elevation: 0.0,
      titleSpacing: 0,
      leadingWidth: 0,
      backgroundColor: const Color(0x00000000),
      toolbarHeight: appBarHeight,
      flexibleSpace: Obx(() {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: Effects.blurMedium,
              sigmaY: Effects.blurMedium,
            ),
            child: Container(
              height: appBarHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: controller.showSearchField.value ? 1.0 : 0.0,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: controller.showSearchField.value ? 70.0 : 0.0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: controller.homePageDmOrGroup.value == 0
                          ? Themes.themeDm.withOpacity(
                          Effects.appBarOpacityPrimary)
                          : Themes.themeGroup.withOpacity(
                          Effects.appBarOpacityPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
