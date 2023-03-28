import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItem extends StatelessWidget {
  final IconData icona;
  final String text;
  final VoidCallback onPressed;
  const DrawerItem(
      {Key? key,
      required this.icona,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Icon(
              icona,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 1,
              height: 15,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style:GoogleFonts.poppins(fontWeight:FontWeight.w500,fontSize:16,color:Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
