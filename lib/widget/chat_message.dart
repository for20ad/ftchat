import 'package:flutter/material.dart';


class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final Animation<double> animation;
  final bool isMe;

  ChatMessage(this.data, {Key? key, required this.animation, required this.isMe})
      : super(key: key);

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
                    Text(
                      data['userId'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(data['message'],
                        style: TextStyle(
                          fontSize: 16,
                        )),
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
