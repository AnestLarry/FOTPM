import 'package:flutter/material.dart';
import 'package:fotpm/pages/home.dart';
import 'package:fotpm/pages/otp_add.dart';
import 'package:fotpm/utils/storage_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!await StorageUtil.requestPermission()) {
    return;
  }
  await StorageUtil.initUtil();
  return runApp(MaterialApp(
    title: "FOTPM",
    theme: ThemeData(primaryColor: Colors.lightBlueAccent),
    routes: {
      "/": (ctx) => const HomeWidget(),
      "/otp/add": (ctx) => const OTPAddWidget()
    },
    initialRoute: "/",
  ));
}
