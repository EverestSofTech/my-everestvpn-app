import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String? _selectedIssue;

  final List<String> _issues = [
    'Select'
        'Connection issue',
    'Points & withdrawal',
    'Account Issue',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 23),
              child: Text(
                'please enter you contact details and support team will contact you soon',
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 23),
              height: 55,
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Name',
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : kwhite,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                    // borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 23),
              height: 55,
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Email Addrees',
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : kwhite,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                    // borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: Text(
                    'Subject',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 23),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: DropdownButtonFormField<String>(
                value: _selectedIssue,
                hint: Text(
                  'Select',
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : kwhite,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedIssue = value;
                  });
                },
                items: _issues.map((String issue) {
                  return DropdownMenuItem<String>(
                    value: issue,
                    child: Text(issue),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 23),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 23),
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Your Message',
                  labelStyle: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : kwhite,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                    // borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : kwhite,
                    ),
                    // borderRadius: BorderRadius.circular(8.0),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Get.to('');
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 110),
                height: 55,
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: Color.fromARGB(255, 84, 202, 92),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SUBMIT',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
