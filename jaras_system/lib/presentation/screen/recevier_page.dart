import 'package:flutter/material.dart';
import 'package:jaras_system/presentation/modul/receiver.dart';
import 'package:jaras_system/presentation/widget/custom_switch.dart';

class ReceiverListWidget extends StatefulWidget {
  final List<Receiver> receivers;

  ReceiverListWidget({required this.receivers});

  @override
  _ReceiverListWidgetState createState() => _ReceiverListWidgetState();
}

class _ReceiverListWidgetState extends State<ReceiverListWidget> {
  List<Receiver> _receivers = [];

  @override
  void initState() {
    super.initState();
    _receivers = widget.receivers;
  }

  void _toggleReceiverState(int index) {
    setState(() {
      _receivers[index].isActive = !_receivers[index].isActive;
    });
  }

  void _deleteReceiver(int index) {
    setState(() {
      _receivers.removeAt(index);
    });
  }

  Widget _buildReceiverItem(BuildContext context, int index) {
    final receiver = _receivers[index];
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _deleteReceiver(index);
            },
            child: const Icon(
              Icons.delete,
              color: Color(0xffD0D5DD),
            ),
          ),
          CustomSwitch(
            value: receiver.isActive,
            onChanged: (value) {
              _toggleReceiverState(index);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  receiver.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  receiver.relationship,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: receiver.isActive
                      ? Colors.transparent
                      : const Color(0xffF5F5F5),
                  border: Border.all(
                    color: receiver.isActive
                        ? const Color(0xFF92D400)
                        : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                receiver.isActive ? Icons.person : Icons.person_outline,
                color:
                    receiver.isActive ? const Color(0xFF92D400) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _receivers.length,
                itemBuilder: _buildReceiverItem,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
