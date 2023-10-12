import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:ftchat/chat_message.dart';
import 'package:logger/logger.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  var logger = Logger();
  List<String> _chats = [];
  TextEditingController _textEditingController = TextEditingController();


  PreferredSizeWidget _buildAppBar() {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: Text('chatApp'),
      );
    } else {
      return AppBar(
        title: Text('chatApp'),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: _animListKey,
                reverse: true,
                itemBuilder: _buildItem,
                initialItemCount: 0,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Platform.isIOS?
                      Expanded(
                        child: CupertinoTextField(
                          controller: _textEditingController,
                          onSubmitted: _handleSubmited,
                          placeholder: '메시지 입력',
                        ),
                      )

                          :
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          onSubmitted: _handleSubmited,
                          decoration: InputDecoration(
                            hintText: "메시지 입력",
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0,),
                      IconButton(
                        onPressed: () async{
                          _handleSubmited(_textEditingController.text);
                        },
                        icon: Icon(
                          Icons.send,
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),

    );
  }
  Widget _buildItem( context, index, animation ){
    return ChatMessage(_chats[index], animation: animation,);
  }

  void _handleSubmited( String text ) {


    _chats.insert(0,text);

    _animListKey.currentState?.insertItem(0);
    _textEditingController.clear();
  }
}

