import 'package:camo_chat/firebase/database.dart';
import 'package:camo_chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/effects.dart';
import '../../../constants/images.dart';
import '../../../constants/themes.dart';
import '../../../controller/controller.dart';
import '../../../models/dm.dart';
import '../../../models/user.dart';
import '../../../widgets/loaders.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.messageId}) : super(key: key);
  final String messageId;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final controller = Get.find<Controller>();
  final database = Database();
  Message? message;
  bool myMessage = false;
  bool loading = true;

  getMessage() async {
    message = await database.readMessage(widget.messageId);
    message?.sender = await database.getUser(message!.senderId);
    message?.id = widget.messageId;
    setState(() {
      loading = false;
      if (message?.senderId == controller.userId) {
        myMessage = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? SizedBox(
            height: 120,
            child: Center(
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(left: 10, right: 25),
                padding: EdgeInsets.only(
                    left: myMessage ? 60 : 0, right: myMessage ? 0 : 60),
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(20.0),
                      topLeft: const Radius.circular(20.0),
                      bottomLeft: myMessage
                          ? const Radius.circular(20.0)
                          : const Radius.circular(0),
                      bottomRight: myMessage
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                    ),
                    color: myMessage
                        ? Themes.themeGroup.withOpacity(0.6)
                        : Themes.themeDm.withOpacity(0.6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            myMessage ? "You" : message!.sender!.userName,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Themes.themeChatSender,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${message!.timestamp.hour}:${message!.timestamp.minute}",
                            style: TextStyle(
                                fontSize: 11,
                                color: Themes.themeChatTimer.withOpacity(0.7)),
                          ),
                        ],
                      ),
                      Text(
                        message!.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
