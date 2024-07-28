import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaras_system/presentation/modul/massage.dart';
import 'package:jaras_system/presentation/widget/custom_chatbubble.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [
    Message(content: 'كيف اقدر اخدمك؟', isSent: false, time: '12:28 م'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;
    setState(() {
      messages.add(Message(
          content: content,
          isSent: true,
          time: DateFormat('hh:mm a').format(DateTime.now())));
    });
    _controller.clear();
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'محادثتك مع مشرف الخروج',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/image/ll.png',
            width: 20,
            height: 20,
          ),
          iconSize: 24,
        ),
        actions: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/mm.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'اتصل',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF92D400),
              fontSize: 18,
              fontFamily: 'Adelle Sans ARA',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/Phone.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 30),
          const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'عبدالمحسن محمد', //take the name from the database
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF7F8896),
                  fontSize: 20,
                  fontFamily: 'Adelle Sans ARA',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'مشرف الخروج',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFFC4C9D1),
                  fontSize: 16,
                  fontFamily: 'Adelle Sans ARA',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/accg.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];
            return ChatBubble(message: message);
          },
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك لمشرف الخروج',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF92D400)),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          _buildUserInfoSection(),
          _buildMessagesList(),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
