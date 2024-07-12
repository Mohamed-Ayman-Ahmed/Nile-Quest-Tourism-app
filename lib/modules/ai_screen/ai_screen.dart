import 'package:flutter/material.dart';
import 'package:nile_quest/modules/ai_photos/ai_photos.dart';
import 'package:nile_quest/modules/chat_ai/chat_ai.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class AiScreen extends StatefulWidget {
  @override
  State<AiScreen> createState() => _aiState();
}

class _aiState extends State<AiScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 45.0,
          automaticallyImplyLeading: false,
          title: Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bolt_outlined,
                  size: 50.0,
                  color: mainColor,
                ),
                Text(
                  'AI Guide',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_outlined),
                ),
              ],
            ),
          ]),
          bottom: TabBar(
              labelColor: mainColor,
              dividerColor: mainColor,
              indicatorColor: mainColor,
              labelStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: ('Chat AI')),
                Tab(text: ('Image AI')),
              ]),
        ),
        body: TabBarView(children: [ChatAi(), ImageChat()]),
      ),
    );
  }
}
