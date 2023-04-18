import 'package:camo_chat/firebase/database.dart';
import 'package:camo_chat/models/message.dart';
import 'package:camo_chat/widgets/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/images.dart';
import '../../../constants/themes.dart';
import '../../../controller/controller.dart';
import '../../../models/dm.dart';
import '../../../models/user.dart';
import '../../../widgets/loaders.dart';

class DMSearchCard extends StatefulWidget {
  const DMSearchCard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DMSearchCard> createState() => _DMSearchCardState();
}

class _DMSearchCardState extends State<DMSearchCard> {
  final controller = Get.find<Controller>();
  final database = Database();

  final textStyleName = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.w500, color: Themes.themeChatSender);

  final textStyleMessage =
      TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7));

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if(widget.user.userId != 'blank') {
          controller.selectedDm.value = await database.openDM(widget.user.userId!);
          print(controller.selectedDm.value.members);
          Future.delayed(Duration(seconds: 2));
          controller.showDmOrChat.value = 1;
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Container(
        height: widget.user.userId != 'blank' ? 80 + statusBarSize(context) : 60,
        color: widget.user.userId != 'blank' ? Themes.themeDm.withOpacity(0.2) : Colors.transparent,
        child: widget.user.userId != 'blank' ? Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              const CircleAvatar(
                backgroundImage: AssetImage(ImageConst.dmLogo),
                radius: 25,
                backgroundColor: Themes.themeDm,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.user.userName,
                style: textStyleName,
              ),
            ],
          ),
        ) : null,
      ),
    );
  }
}
