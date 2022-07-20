import 'package:flutter/material.dart';
import 'package:multiplatform_application/pages/html_page.dart';
import 'package:multiplatform_application/pages/web_view_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        /// Отображает webView на мобильных ОС и Web
        home: const WebViewPage()
      /// Отображает html-код сайта на web, windows и mobile ОС
      // home: const HtmlPage()
    );
  }
}