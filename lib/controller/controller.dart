import 'dart:async';

import 'package:camo_chat/models/group.dart';
import 'package:camo_chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/dm.dart';
import '../models/user.dart';

class Controller extends GetxController {
  var accelerometerEvent = AccelerometerEvent(0, 0, 0).obs;

  var showLoginPage = true.obs;
  var showSearchField = false.obs;
  var homePageDmOrGroup = 0.obs;

  var showDmOrChat = 0.obs;
  var showGroupOrChat = 0.obs;

  var selectedDm = Dm(members: [], messages: []).obs;
  var selectedDmStream;
  var selectedDmMessages = <String>[].obs;
  var selectedGroup = Group(admin: '', members: [], posts: []).obs;

  var scrollController = ScrollController();

  var userId = "";
  var userDataLoaded = false.obs;
  var userData =
      User(userName: '', dm: [], groups: [], isBanned: false, moddedReports: 0)
          .obs;

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}
