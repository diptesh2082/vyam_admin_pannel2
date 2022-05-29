import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextField(
    {TextEditingController? addcontroller, String? hinttext}) {
  return SizedBox(
    height: 50,
    child: Card(
      child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            prefix: addcontroller!.text != ""
                ? Text(
                    '$hinttext :  ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
        onChanged: (value) {
          final val = TextSelection.fromPosition(
              TextPosition(offset: addcontroller.text.length + 1));
          addcontroller.selection = val;
          if (value.length == 1) {
            addcontroller.text = value;
          }
          if (value.isEmpty) {
            addcontroller.text = value;
          }
        },
      ),
    ),
  );
}
