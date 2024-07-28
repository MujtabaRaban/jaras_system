import 'package:flutter/material.dart';
import 'package:jaras_system/presentation/modul/massage.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isSent ? const Color(0xFF92D400) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: message.isSent
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                  color: message.isSent ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              message.time,
              style: TextStyle(
                color: message.isSent ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
