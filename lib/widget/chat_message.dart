import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String txt;
  final Animation<double> animation;
  const ChatMessage(
      this.txt, {
        Key? key, required this.animation})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 9),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.amberAccent ,
                child: Text('N'),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(txt),
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
