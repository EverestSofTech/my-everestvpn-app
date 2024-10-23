import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textcontroller,
    required this.iconData,
    required this.title,
  });

  final TextEditingController textcontroller;
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 23),
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.white,
              width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          controller: textcontroller,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.only(left: 10),
            prefixIcon: Icon(
              iconData,
              // color: Colors.black,
              size: 30,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.white,
            ),
            hintText: title,
            hintStyle: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldP extends StatefulWidget {
  const CustomTextFieldP({
    super.key,
    required this.textcontroller,
  });

  final TextEditingController textcontroller;

  @override
  State<CustomTextFieldP> createState() => _CustomTextFieldPState();
}

class _CustomTextFieldPState extends State<CustomTextFieldP> {
  bool isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 23),
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.white,
              width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          controller: widget.textcontroller,
          obscureText: isObsecure,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.only(left: 10),
            prefixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObsecure = !isObsecure;
                });
              },
              child: Icon(
                Icons.remove_red_eye,
                // color: Colors.black,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            hintText: ' Enter Your Password',
            hintStyle: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
