import 'package:chathub/controller/basic_provider.dart';
import 'package:chathub/controller/firebase_provider.dart';
import 'package:chathub/model/user_model.dart';
import 'package:chathub/services/auth_services.dart';
import 'package:chathub/services/chat_service.dart';
import 'package:chathub/view/widget/chat_bubble.dart';
import 'package:chathub/view/widget/image_selector_dialogue.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messagecontroller = TextEditingController();
  FirebaseAuthServices service = FirebaseAuthServices();

  @override
  void initState() {
    super.initState();

    final currentuserid = service.auth.currentUser!.uid;
    Provider.of<FirebaseProvider>(context, listen: false)
        .getMessages(currentuserid, widget.user.uid!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  Text(
                    widget.user.name ?? widget.user.email!,
                    style: GoogleFonts.comfortaa(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        Provider.of<FirebaseProvider>(context, listen: false)
                            .clearChat(service.auth.currentUser!.uid,
                                widget.user.uid!);
                      },
                      icon: const Icon(Icons.clear_all_outlined))
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    // messages container
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(239, 237, 247, 1),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(35))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ChatBubble(service: service, size: size),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 5,
                    right: 5,
                    child: Container(
                      // chating field
                      width: size.width * 0.9,
                      height: size.height * 0.08,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          // IconButton(
                          //     onPressed: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           final pro =
                          //               Provider.of<BasicProvider>(context);
                          //           return ImageSelectorDialog(
                          //             pro: pro,
                          //             size: size,
                          //             recieverId: widget.user.uid!,
                          //           );
                          //         },
                          //       );
                          //     },
                          //     icon: Icon(Icons.photo)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black, fontSize: 18),
                                controller: messagecontroller,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 174, 174, 174)),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                sendMessage();
                                messagecontroller.clear();
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await ChatService()
          .sendMessage(widget.user.uid!, messagecontroller.text, "text");
    }
  }
}
