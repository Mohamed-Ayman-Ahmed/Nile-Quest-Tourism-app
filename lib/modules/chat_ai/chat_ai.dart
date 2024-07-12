/*import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class ChatAi extends StatefulWidget {
  const ChatAi({super.key});

  @override
  State<ChatAi> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatAi> {
  ChatUser user = ChatUser(id: '1', firstName: 'You');
  ChatUser bot = ChatUser(id: '2', firstName: 'AI Guide');
  List<ChatMessage> allMessage = [];
  List<ChatUser> typing = [];

  final ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAYPi2MhA6-dAc57k2zFMBqSWxe20et1sI";
  final header = {'Content-Type': 'application/json'};
  bool isvisible = true;
  getData(ChatMessage m) async {
    typing.add(bot);
    allMessage.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        allMessage.insert(0, m1);
      } else {
        print("Error occurred");
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: isvisible,
            child: Column(
              children: [
                Lottie.asset(
                  'assets/lottie/b.json',
                  animate: true,
                ),
                Text(
                  'This guides you to your questions about Egypt',
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(150, 0, 0, 0)),
                ),
              ],
            ),
          ),
          Expanded(
            child: DashChat(
              inputOptions: InputOptions(
                alwaysShowSend: true,
                sendButtonBuilder: (Function sendMessage) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => sendMessage(),
                      color: mainColor,
                    ),
                  );
                },
              ),
              messageOptions: MessageOptions(
                maxWidth: 250.0,
                showTime: true,
                containerColor: mainColor,
                currentUserContainerColor: mainColor,
                textColor: Colors.white,
                showCurrentUserAvatar: true,
              ),
              typingUsers: typing,
              currentUser: user,
              onSend: (ChatMessage m) {
                isvisible = false;
                getData(m);
              },
              messages: allMessage,
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class ChatAi extends StatefulWidget {
  const ChatAi({super.key});

  @override
  State<ChatAi> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatAi> {
  ChatUser user = ChatUser(id: '1', firstName: 'You');
  ChatUser bot = ChatUser(id: '2', firstName: 'AI Guide');
  List<ChatMessage> allMessage = [];
  List<ChatUser> typing = [];

  final ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAYPi2MhA6-dAc57k2zFMBqSWxe20et1sI";
  final header = {'Content-Type': 'application/json'};
  bool isvisible = true;
  getData(ChatMessage m) async {
    typing.add(bot);
    allMessage.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        allMessage.insert(0, m1);
      } else {
        print("Error occurred");
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: isvisible,
            child: Column(
              children: [
                Lottie.asset('assets/lottie/b.json',
                    animate: true, height: 250),
                Text(
                  'This guides you to your questions about Egypt',
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(150, 0, 0, 0)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  setState(() {
                    isvisible = false;
                  });
                }
              },
              child: DashChat(
                inputOptions: InputOptions(
                  alwaysShowSend: true,
                  sendButtonBuilder: (Function sendMessage) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => sendMessage(),
                        color: mainColor,
                      ),
                    );
                  },
                ),
                messageOptions: MessageOptions(
                  maxWidth: //250,
                      MediaQuery.of(context).size.width * 0.6,
                  showTime: true,
                  containerColor: mainColor,
                  currentUserContainerColor: mainColor,
                  textColor: Colors.white,
                  showCurrentUserAvatar: true,
                ),
                typingUsers: typing,
                currentUser: user,
                onSend: (ChatMessage m) {
                  isvisible = false;
                  getData(m);
                },
                messages: allMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
