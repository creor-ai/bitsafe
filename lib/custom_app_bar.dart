import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        padding: EdgeInsets.all(8), // Reduced padding
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain, // Ensures the logo is scaled properly within the space
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'BitSafe',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            TextSpan(
              text: '   Check if your bitcoin address is safe',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
    );
  }
}
