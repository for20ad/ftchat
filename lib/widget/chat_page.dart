import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ftchat/widget/chat_message.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late IO.Socket socket;

  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  var logger = Logger();
  List<String> _chats = [];
  TextEditingController _textEditingController = TextEditingController();

  void connectToServer(){
    socket = IO.io('https://node.dodoom.co.kr', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {},
    });
    socket.connect();
    socket.on('chat_message', (data) {
      print( "data:::$data" );
      setState(() {
        _chats.insert(0,data);
        //_handleSubmited(data);
      });
    });
  }
  @override
  void initState() {
    super.initState();
    connectToServer();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mss'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: _animListKey,
                reverse: true,
                itemBuilder: _buildItem,
                initialItemCount: _chats.length,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
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

    if( text.isNotEmpty ){
      _chats.insert(0,text);

      socket.emit("chat_message",{'message':text});
      _animListKey.currentState?.insertItem(0);
      _textEditingController.clear();
    }

  }
}
