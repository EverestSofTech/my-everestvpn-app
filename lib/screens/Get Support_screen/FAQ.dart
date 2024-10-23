import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqScreen extends StatelessWidget {
  var controller = Get.put(VpnController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Frequently Asked Questions (FAQs) - Everest VPN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FaqItem(
            question: 'What is Everest VPN?',
            answer:
                'Everest VPN is a virtual private network service designed to provide a secure and private online experience. It encrypts your internet connection, ensuring confidentiality and protecting your data from potential threats.',
          ),
          FaqItem(
            question: 'How does Everest VPN work?',
            answer:
                'Everest VPN works by creating a secure tunnel between your device and our servers. This tunnel encrypts your data, preventing third parties from monitoring your online activities. It also allows you to access the internet anonymously.',
          ),
          FaqItem(
            question: 'Is my online activity logged when using Everest VPN?',
            answer:
                'No, Everest VPN does not log your online activity. We are committed to protecting your privacy.',
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor !=
                    kContentColorDarkTheme
                ? kContainerColor
                : kContainerLightColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor !=
                          kContentColorDarkTheme
                      ? kContainerColor
                      : kContainerLightColor, // Question background color remains white
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                    bottomLeft:
                        _isExpanded ? Radius.zero : Radius.circular(8.0),
                    bottomRight:
                        _isExpanded ? Radius.zero : Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.55,
                        child: Text(
                          widget.question,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      Icon(
                        (_isExpanded)
                            ? Icons.remove_outlined
                            : Icons.add_outlined,
                        // color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Answer background color
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                    border: Border.all(
                      color: Colors.black, // Border color of answer container
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
