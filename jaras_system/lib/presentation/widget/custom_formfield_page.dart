import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labelText,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: const Color(0xff353535),
              ),
            ),
            const SizedBox(width: 5),
            Icon(icon, color: const Color(0xFFE0E0E0)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.cairo(
              color: const Color(0xFFCCCCCC),
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF92D400),
              ),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
          style: GoogleFonts.cairo(
            color: const Color(0xFF858B95),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
