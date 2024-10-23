import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  late Future<WebViewController> _controller;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _controller = _getController();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.location,
    ].request();
  }

  Future<WebViewController> _getController() async {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) {
        request
            .grant(); // Grant permission for the WebView to access the camera
      },
    );

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
          final locationPermissionStatus =
              await Permission.locationWhenInUse.request();

          return GeolocationPermissionsResponse(
            allow: locationPermissionStatus == PermissionStatus.granted,
            retain: false,
          );
        },
      );
    }

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.loadRequest(Uri.parse("https://support.everestvpn.org"));

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Live Chat'),
      ),
      body: SafeArea(
        child: FutureBuilder<WebViewController>(
          future: _controller,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return WebViewWidget(
                controller: snapshot.data!,
              );
            } else {
              return const Center(
                  child: SpinKitPulse(
                color: kSecondaryColor,
                size: 50.0,
              ));
            }
          },
        ),
      ),
    );
  }
}
