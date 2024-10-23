import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Handle back button press
        //   },
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  // color:
                  //     Colors.white.withOpacity(0.8), // Adjust the color opacity
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Last Updated: [Nov-22-2023]',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: Colors
                  //     .grey.shade300, // Grey color for the "Last Updated" text
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Everest Soft Tech built the Everest VPN app as a Freemium app. This SERVICE is provided by Everest Soft Tech at no cost and is intended for use as is.\n\n'
                'This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\n'
                'If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\n'
                'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Everest VPN unless otherwise defined in this Privacy Policy.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5, // Adjust line spacing for readability
                  // color: Colors.grey.shade400, // Lighter grey for the body text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
