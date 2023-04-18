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

import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool blank = false;
  bool loading = true;

  bool liked = false;
  bool reported = false;
  int likesCount = 0;
  int reportsCount = 0;

  getMessage() async {
    if(widget.messageId!='blank') {
      message = await database.readMessage(widget.messageId);
      message?.sender = await database.getUser(message!.senderId);
      message?.id = widget.messageId;

      if(message!.likes > 0){
        setState(() {
          liked = true;
          likesCount  = 1;
        });

      }

      if(message!.reports > 0){
        setState(() {
          reported = true;
          reportsCount  = 1;
        });

      }
    }
    else {
      setState(() {
        blank = true;
      });
    }
    if(mounted) {
      setState(() {
        loading = false;
        if (message?.senderId == controller.userId) {
          myMessage = true;
        }
      });
    }

  }

  @override
  void initState() {
    super.initState();
    getMessage();
    // controller.scrollDown();
  }

  void _toggleLike(String? messageId) async {
    print('toggleLike called');
    setState(() {
      liked = !liked;
      likesCount += liked ? 1 : -1;
    });
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(messageId)
        .update({'likes': likesCount})
        .then((value) => print('updateLikes successful'))
        .catchError((error) => print('updateLikes error: $error'));
  }

  void _toggleReport(String? messageId) async {
    print('toggleReport called');
    setState(() {
      reported = !reported;
      reportsCount += reported ? 1 : -1;
    });
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(messageId)
        .update({'reports': reportsCount})
        .then((value) => print('updateReport successful'))
        .catchError((error) => print('updateReport error: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? !blank
        ? Center(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 25, top: 5, bottom: 5),
            padding: EdgeInsets.only(
                left: myMessage ? 60 : 0, right: myMessage ? 0 : 60),
            alignment:
            myMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    myMessage ? "You" : message!.sender!.userName,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Themes.themeChatSender,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(15.0),
                        topLeft: const Radius.circular(15.0),
                        bottomLeft: myMessage
                            ? const Radius.circular(20.0)
                            : const Radius.circular(0),
                        bottomRight: myMessage
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                      ),
                      color: myMessage
                          ? Themes.themeGroup.withOpacity(0.8)
                          : Themes.themeDm.withOpacity(0.8),
                    ),
                    // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message!.content,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 60+25,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  liked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_outlined,
                                  color: liked ? Colors.blue : Colors.white,
                                ),
                                onPressed: () {
                                  _toggleLike(message?.id); // pass the message ID here
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  reported ? Icons.report : Icons.report_outlined,
                                  color: reported ? Colors.red : Colors.white,
                                ),
                                onPressed: () {
                                  _toggleReport(message?.id); // pass the message ID here
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${message!.timestamp.hour}:${message!.timestamp.minute}",
                    style: TextStyle(
                        fontSize: 9,
                        color: Themes.themeChatTimer.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
      ),
    ),
        )
        : const SizedBox(height: 70,)
        : Container();
  }




// @override
  // Widget build(BuildContext context) {
  //   return !loading
  //       ? !blank ? Center(
  //         child: Container(
  //           margin: const EdgeInsets.only(left: 10, right: 25, top: 5, bottom: 5),
  //           padding: EdgeInsets.only(
  //               left: myMessage ? 60 : 0, right: myMessage ? 0 : 60),
  //           alignment:
  //               myMessage ? Alignment.centerRight : Alignment.centerLeft,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.only(
  //                 topRight: const Radius.circular(20.0),
  //                 topLeft: const Radius.circular(20.0),
  //                 bottomLeft: myMessage
  //                     ? const Radius.circular(20.0)
  //                     : const Radius.circular(0),
  //                 bottomRight: myMessage
  //                     ? const Radius.circular(0)
  //                     : const Radius.circular(20),
  //               ),
  //               color: myMessage
  //                   ? Themes.themeGroup.withOpacity(0.8)
  //                   : Themes.themeDm.withOpacity(0.8),
  //             ),
  //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: myMessage ? CrossAxisAlignment.start : CrossAxisAlignment.start,
  //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       myMessage ? "You" : message!.sender!.userName,
  //                       style: const TextStyle(
  //                           fontSize: 16,
  //                           color: Themes.themeChatSender,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     Text(
  //                       "${message!.timestamp.hour}:${message!.timestamp.minute}",
  //                       style: TextStyle(
  //                           fontSize: 9,
  //                           color: Themes.themeChatTimer.withOpacity(0.7)),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 5,),
  //                 Text(
  //                   message!.content,
  //                   // maxLines: 3,
  //                   // overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ) : const SizedBox(height: 70,)
  //       : Container();
  // }
}
