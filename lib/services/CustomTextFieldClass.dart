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
          fontSize: 20,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
            prefix: addcontroller!.text != ""
                ? Text(
                    '$hinttext :  ',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            hintStyle: GoogleFonts.poppins(
              fontSize: 20,
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

Widget customTextField2(
    {TextEditingController? addcontroller, String? hinttext, String? dic}) {
  addcontroller!.text = dic!;

  return SizedBox(
    height: 50,
    child: Card(
      child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefix: addcontroller.text != ""
                ? Text(
                    '$hinttext :  ',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            hintStyle: GoogleFonts.poppins(
              fontSize: 20,
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

Widget customTextField3(
    {TextEditingController? addcontroller, String? hinttext}) {
  return SizedBox(
    height: 50,
    child: Card(
      child: TextFormField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefix: addcontroller!.text != ""
                ? Text(
                    '$hinttext :  ',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            hintStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This Field cannot be empty';
          }
          return null;
        },
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
