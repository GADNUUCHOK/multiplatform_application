import 'package:flutter/material.dart';
import 'web_view_settings/register_web_webview_stub.dart'
if (dart.library.html) 'web_view_settings/register_web_webview.dart';
import 'app.dart';

void main() {
  registerWebViewWebImplementation();
  runApp(const MyApp());
}
