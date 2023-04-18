import 'dart:async';
import 'dart:ui';

import 'package:camo_chat/firebase/database.dart';
import 'package:camo_chat/pages/home_page/cards/dm_search_card.dart';
import 'package:camo_chat/pages/home_page/cards/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:camo_chat/models/message.dart';

import '../../constants/effects.dart';
import '../../constants/images.dart';
import '../../constants/themes.dart';
import '../../controller/controller.dart';
import '../../models/dm.dart';
import '../../widgets/background.dart';
import '../../widgets/helper.dart';
import '../../widgets/loaders.dart';
import 'cards/dm_card.dart';
import 'cards/group_search_card.dart';

class HomePageGroup extends StatefulWidget {
  const HomePageGroup({Key? key}) : super(key: key);

  @override
  State<HomePageGroup> createState() => _HomePageGroupState();
}

class _HomePageGroupState extends State<HomePageGroup> {
  final controller = Get.find<Controller>();
  final database = Database();
  TextEditingController textController = TextEditingController(text: '');
  late StreamSubscription<bool> keyboardSubscription;
  bool keyboardOn = false;
  double keyboardSize = 300;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();

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
    return Stack(
      children: [
        Background(
          backgroundImage: ImageConst.homePageGroup,
          sensitivity: Effects.loginPageSensitivity,
          blurValue: Effects.blurVeryLight,
          blackValue: Effects.blackMedium,
        ),
        // Obx(() {
        //   if (controller.showDmOrChat.value == 0) {
        //     return DMView();
        //   } else if (controller.showDmOrChat.value == 1) {
        //     return ChatScreen(context);
        //   } else {
        //     return SearchPage();
        //   }
        // }),
      ],
    );
  }

//   Widget SearchPage() {
//     return Stack(
//       children: [
//         FutureBuilder(
//             future: database.searchDM(),
//             builder: (_,users) {
//               if(users.connectionState == ConnectionState.waiting) {
//                 return const LoaderCircular();
//               }
//               return ListView(
//                   physics: const BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   children: users.data!
//                       .map((user) => GroupSearchCard(user: user))
//                       .toList());
//             }
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(height: 120 + statusBarSize(context),),
//             ClipRect(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                     sigmaX: Effects.blurLight, sigmaY: Effects.blurLight),
//                 child: SizedBox(
//                   height: 40,
//                   width: screenSize(context).width - 20,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       SizedBox(
//                         width: screenSize(context).width - 100,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 15, horizontal: 25),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.white, width: 3),
//                                   borderRadius: BorderRadius.circular(35.0)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(35.0)),
//                               hintText: 'Search',
//                               hintStyle: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.white.withOpacity(0.5))),
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 18),
//                           controller: textController,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {},
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(100),
//                             color: Themes.themeGroup.withOpacity(0.4),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.search_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   ListView DMView() {
//     return ListView(
//         physics: const BouncingScrollPhysics(
//             parent: AlwaysScrollableScrollPhysics()),
//         children: controller.userData.value.dm
//             .map((dm) => DMCard(dmId: dm))
//             .toList());
//   }
//
//   Stack ChatScreen(BuildContext context) {
//     return Stack(
//       children: [
//         StreamBuilder<Dm>(
//             stream: database.streamDm(controller.selectedDm.value.id!),
//             builder: (_, dmSnap) {
//               if (dmSnap.connectionState == ConnectionState.waiting) {
//                 // Dm dm = dmSnap.data!;
//                 // dm.messages.add('blank');
//                 // return ListView(
//                 //     // controller: scrollController,
//                 //     physics: const BouncingScrollPhysics(
//                 //         parent: AlwaysScrollableScrollPhysics()),
//                 //     children: dm.messages
//                 //         .map((message) =>
//                 //         MessageCard(messageId: message))
//                 //         .toList());
//                 return const Center(child: LoaderCircular());
//               }
//               // return Container();
//               else {
//                 Dm dm = dmSnap.data!;
//                 if(dm.messages == null) {
//                   return Container();
//                 } else {
//                   dm.messages!.add('blank');
//                 }
//
//                 return ListView(
//                   // controller: scrollController,
//                     physics: const BouncingScrollPhysics(
//                         parent: AlwaysScrollableScrollPhysics()),
//                     children: dm.messages!
//                         .map((message) => MessageCard(messageId: message))
//                         .toList());
//               }
//             }),
//         // Obx(() {
//         //   Message blank = Message(content: '', likes: 0, reports: 0, timestamp: DateTime.now(), senderId: '');
//         //   blank.id = 'blank';
//         //   var messages = controller.selectedDmMessagesObj;
//         //   messages.removeWhere((item) => item.id == 'blank');
//         //   messages.add('blank');
//         //   print("added blacnk");
//         //   print(messages);
//         //   print(messages.length);
//         //   if(messages.length == 1) {
//         //     Container();
//         //   }
//         //   // return ScrollablePositionedList.builder(
//         //   //   physics: const BouncingScrollPhysics(
//         //   //             parent: AlwaysScrollableScrollPhysics()),
//         //   //   itemCount: messages.length,
//         //   //   itemBuilder: (_, index) {
//         //   //     print(index);
//         //   //     return MessageCard(messageId: messages[index]);
//         //   //   },
//         //   //   itemScrollController: itemScrollController,
//         //   //   itemPositionsListener: itemPositionsListener,
//         //   // );
//         //   return ListView(
//         //       // controller: controller.scrollController,
//         //       // key: ObjectKey(messages.last),
//         //       physics: const BouncingScrollPhysics(
//         //           parent: AlwaysScrollableScrollPhysics()),
//         //       children: messages.map((message) {
//         //         return MessageCard(messageId: message);
//         //       }).toList());
//         // }),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRect(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                     sigmaX: Effects.blurLight, sigmaY: Effects.blurLight),
//                 child: SizedBox(
//                   height: 60,
//                   width: screenSize(context).width - 20,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       SizedBox(
//                         width: screenSize(context).width - 100,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 15, horizontal: 25),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.white, width: 3),
//                                   borderRadius: BorderRadius.circular(35.0)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(35.0)),
//                               hintText: 'Message',
//                               hintStyle: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.white.withOpacity(0.5))),
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 18),
//                           controller: textController,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           database.writeMessage(controller.selectedDm.value.id!,
//                               textController.text);
//                           setState(() {
//                             textController.text = '';
//                           });
//                         },
//                         child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(100),
//                             color: Themes.themeGroup.withOpacity(0.4),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.send,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: keyboardOn ? keyboardSize + 10 : 50,
//             )
//           ],
//         )
//       ],
//     );
//   }
}
