import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final TextEditingController _textEditingController = TextEditingController();
  late WebViewController _controllerWebView;

  String enterText = '';
  String headerText = '';
  String corsText = '';
  String descriptionText = '';
  String platform = '';

  @override
  void initState() {
    super.initState();
    kIsWeb
        ? platform = 'web'
        : Platform.isWindows
        ? platform = 'windows'
        : Platform.isIOS
        ? platform = 'ios'
        : platform = 'android';
  }

  void _loadHtmlPage(String uri) async {
    final result = await http.get(Uri.parse(uri));
    var cors = 'none';
    result.headers.forEach((key, value) {
      if (key == 'access-control-allow-origin') {
        cors = value;
      }
      if (kDebugMode) {
        print('key $key = value $value');
      }
    });

    var document = parse(result.body);
    var title = document.getElementsByTagName('title')[0].text;

    if (kDebugMode) {
      print("title = $title");
    }
    setState(() {
      headerText = title;
      corsText = 'CORS Header: $cors';
      descriptionText = result.body;
      _controllerWebView.loadUrl(enterText);
    });
  }

  /// Отображает webView на мобильных ОС и Web
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            headerText == ''
                ? const SizedBox(
              height: 0,
            )
                : Text(
              headerText,
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            corsText == ''
                ? const SizedBox(
              height: 0,
            )
                : Align(
              alignment: Alignment.centerLeft,
              child: Text(
                corsText,
                style: const TextStyle(fontSize: 25, color: Colors.red),
              ),
            ),
            Flexible(
                child: WebView(
                  initialUrl: enterText,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controllerWebView = webViewController;
                  },
                )),
            headerText == ''
                ? const SizedBox(
              height: 0,
            )
                : const Divider(
              color: Colors.black,
              height: 20,
              thickness: 3,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (text) {
                          enterText = text;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'URL',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => _loadHtmlPage(enterText),
                      child: const Text(
                        'LOAD',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text('APPLICATION RUNNING ON $platform'.toUpperCase()),
          ],
        ),
      ),
    );
  }
}