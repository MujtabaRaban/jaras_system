import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupervisorPage extends StatelessWidget {
  const SupervisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.report_problem_rounded,
              color: Color(0XFF92D400),
            ),
          )
        ],
        title: Text('هل تواجه مشكلة؟', style: GoogleFonts.cairo()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.highlight_off, color: Color(0xffD0D5DD)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Text(
                  'مشرف الخروج متوفر لمساعدتك',
                  style: GoogleFonts.cairo(
                      fontSize: 22,
                      color: const Color(0xff858B95),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(
                    'assets/image/service.jpg'), // Replace with your image asset
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عبدالمحسن محمد',
                          style: GoogleFonts.cairo(
                              fontSize: 20,
                              color: const Color(0xff808997),
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffF5F5F5),
                            ),
                            child: const Icon(
                              size: 30,
                              Icons.account_circle_rounded,
                              color: Color(0xff808997),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'مشرف الخروج',
                      style: GoogleFonts.cairo(
                          fontSize: 16, color: const Color(0xffC4C9D1)),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF92D400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    textStyle: GoogleFonts.cairo(fontSize: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'تحدّث مع المشرف',
                        style: GoogleFonts.cairo(
                            textStyle: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.forum),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF92D400),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    textStyle: GoogleFonts.cairo(fontSize: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اتصل على المشرف',
                        style: GoogleFonts.cairo(
                            textStyle: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.phone),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
