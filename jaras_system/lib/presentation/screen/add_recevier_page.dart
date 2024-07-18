import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaras_system/presentation/modul/receiver.dart';
import 'package:jaras_system/presentation/widget/custom_formfield_page.dart';

class AddReceiverForm extends StatefulWidget {
  @override
  _AddReceiverFormState createState() => _AddReceiverFormState();
}

class _AddReceiverFormState extends State<AddReceiverForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _relationship = '';

  List<Receiver> receivers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'إضافة مفوض جديد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.add_circle,
              color: Color(0xFF92D400),
            )
          ],
        ),
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
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'سيتم التأكد من خروج المشرف من تسليم الطالب للمفوض المحدد أدناه حصراً',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff858B95)),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                      'assets/image/receiver.jpg'), // Replace with your image asset
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'اسم المفوّض',
                    hintText: 'اكتب الاسم الكامل للمفوّض..',
                    icon: Icons.contact_emergency_sharp,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الاسم الكامل للمفوّض';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'صفة العلاقة',
                    hintText: 'حدد صفة المفوّض..',
                    icon: Icons.link,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال صفة العلاقة';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _relationship = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Add the new receiver to the list
                        receivers.add(Receiver(
                          name: _name,
                          relationship: _relationship,
                          isActive:
                              true, // Assuming the receiver is active upon addition
                        ));
                        // Clear form fields after adding
                        _name = '';
                        _relationship = '';
                        // Optionally, you can update UI here or handle state differently
                        setState(() {
                          
                        }); // Update UI to reflect new receiver
                      }
                      Navigator.pop(context);
                    },
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
                          'حفظ وتفعيل المفوّض',
                          style: GoogleFonts.cairo(
                              textStyle: const TextStyle(fontSize: 21)),
                        ),
                        const SizedBox(width: 1),
                        const Icon(Icons.add_circle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
