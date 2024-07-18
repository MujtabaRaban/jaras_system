import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 81,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffD0D5DD),
          ),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              left: value ? 35 : 0,
              top: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: value
                        ? const Color(0xFF92D400)
                        : const Color(0xFF9CA3AF),
                  ),
                  child: Center(
                    child: Text(
                      value ? 'ON' : 'OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: value ? 45 : 5,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  value ? 'مفعل' : 'معطل',
                  style: TextStyle(
                    color: value
                        ? const Color(0xFF92D400)
                        : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}