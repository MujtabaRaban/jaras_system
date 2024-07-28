import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaras_system/presentation/modul/student_statues.dart';

class StudentStatusList extends StatelessWidget {
  final List<StudentStatus> statuses = [
    StudentStatus('حاضر', 'حضر الطالب إلى المدرسة اليوم، ولم يخرج بعد',
        'assets/image/Checkmark.png', const Color(0xFF92D400)),
    StudentStatus('غائب', 'لم يحضر الطالب إلى المدرسة اليوم',
        'assets/image/Heartbreak.png', const Color(0xff9DA5B2)),
    StudentStatus('خرج', 'حضر الطالب اليوم وسجل خروجه',
        'assets/image/Outside.png', const Color(0xff00D9F4)),
    StudentStatus('متأخر', 'حضر الطالب اليوم ولم يخرج بعد ٣٠ دقيقة من دخوله',
        'assets/image/CheckmarkDotted.png', const Color(0xffFFA544)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statuses[index].title,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: statuses[index].color, fontSize: 15),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(statuses[index].statusImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              statuses[index].description,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.black, // Set description color to black
                  fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
