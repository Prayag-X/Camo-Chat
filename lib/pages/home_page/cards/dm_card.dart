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

class DMCard extends StatefulWidget {
  const DMCard({Key? key, required this.dmId}) : super(key: key);
  final String dmId;

  @override
  State<DMCard> createState() => _DMCardState();
}

class _DMCardState extends State<DMCard> {
  final controller = Get.find<Controller>();
  final database = Database();
  String? otherUserId;

  final textStyleName = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.w500, color: Themes.themeChatSender);

  final textStyleMessage =
      TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Dm>(
        stream: database.streamDm(widget.dmId),
        builder: (_, dmSnap) {
          if (dmSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: LoaderCircular());
          } else {
            Dm dm = dmSnap.data!;
            dm.id = widget.dmId;
            if (dm.members[0] == controller.userId) {
              otherUserId = dm.members[1];
            } else {
              otherUserId = dm.members[0];
            }
            return TextButton(
              onPressed: () {
                controller.selectedDm.value = dm;
                controller.showDmOrChat.value = 1;
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: Container(
                height: 80,
                color: Themes.themeDm.withOpacity(0.2),
                child: Center(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<User>(
                              future: database.getUser(otherUserId!),
                              builder: (_, user) {
                                if (user.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    '------',
                                    style: textStyleName,
                                  );
                                }
                                return Text(
                                  user.data!.userName,
                                  style: textStyleName,
                                );
                              }),
                          const SizedBox(height: 1,),
                          FutureBuilder<Message>(
                              future: database.readMessage(dm.messages.last),
                              builder: (_, message) {
                                if (message.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    '------',
                                    style: textStyleMessage,
                                  );
                                }
                                return Row(
                                  children: [
                                    FutureBuilder<User>(
                                        future: database
                                            .getUser(message.data!.senderId),
                                        builder: (_, user) {
                                          if (user.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              '------',
                                              style: textStyleMessage,
                                            );
                                          }
                                          return Text(
                                            message.data!.senderId ==
                                                    controller.userId
                                                ? "You: "
                                                : "${user.data!.userName}: ",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: textStyleMessage,
                                          );
                                        }),
                                    Container(
                                      width: 120,
                                      child: Text(
                                        message.data!.content,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: textStyleMessage,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
