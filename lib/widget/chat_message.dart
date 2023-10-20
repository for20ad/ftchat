import 'package:flutter/material.dart';


class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final Animation<double> animation;
  final bool isMe;

  ChatMessage(this.data, {Key? key, required this.animation, required this.isMe})
      : super(key: key);

  String formatMessageTime(String timeString) {
    final DateTime now = DateTime.now();
    final DateTime messageTime = DateTime.parse(timeString);

    // 현재 시간과의 차이 계산
    final Duration difference = now.difference(messageTime);

    if (difference.inDays < 1) {
      // 오늘
      final String formattedTime = '${messageTime.hour}:${messageTime.minute}';
      return formattedTime;
    } else if (difference.inDays < 2) {
      // 어제
      final String formattedTime = 'Yesterday ${messageTime.hour}:${messageTime.minute}';
      return formattedTime;
    } else if (now.year == messageTime.year) {
      // 올해
      final String formattedTime = '${messageTime.month}/${messageTime.day} ${messageTime.hour}:${messageTime.minute}';
      return formattedTime;
    } else {
      // 1년 이전
      final String formattedTime = '${messageTime.year}/${messageTime.month}/${messageTime.day} ${messageTime.hour}:${messageTime.minute}';
      return formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 9),
          child: Row(
            children: [
              isMe ?
              SizedBox()
                  :
              CircleAvatar(
                backgroundColor: Colors.amberAccent,
                child: Text(data['userId'][0]),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    isMe ?
                    SizedBox()
                        :
                    Text(
                      data['userId'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isMe? Colors.yellowAccent:Colors.black54,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                          bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        data['message'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isMe?Colors.black:Colors.white,
                        ),
                      ),
                    ),
                    Text(
                        formatMessageTime(data['time']),
                        style: TextStyle(
                          fontSize: 11,
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}