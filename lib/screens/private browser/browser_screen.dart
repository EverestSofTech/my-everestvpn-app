// ignore_for_file: prefer_const_constructors

import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:web_browser/web_browser.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  var controller = BrowserController();
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Private Browser',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Browser(
          controller: controller,
          topBar: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width - 20,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(68, 181, 179, 179),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        controller: textController,
                        onSubmitted: (value) {
                          String input = value;
                          String url;

                          // Check if input is a valid URL
                          if (input.isURL) {
                            if (!input.startsWith('http')) {
                              url = 'http://$input';
                            } else {
                              url = input;
                            }
                          } else {
                            // If not a URL, perform a Google search
                            url = 'https://www.google.com/search?q=' +
                                Uri.encodeComponent(input);
                          }

                          controller.goTo(url);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.link),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                textController.clear();
                                controller.refresh();
                              },
                              child: CircleAvatar(
                                  radius: 15,
                                  child: Icon(
                                    Icons.clear_rounded,
                                    size: 14,
                                  )),
                            ),
                          ),
                          hintText: 'Search apps',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color:
                                  Theme.of(context).scaffoldBackgroundColor ==
                                          kContentColorLightTheme
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.isLoading
                  ? LinearProgressIndicator(
                      color: Colors.blue,
                    )
                  : Container(),
            ],
          ),
          initialUriString: 'https://google.com',
        ),
      ),
    );
  }
}
