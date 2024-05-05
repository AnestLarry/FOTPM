import 'dart:io' as io;
import 'dart:io' show Directory, Platform;

import 'package:flutter/material.dart';
import 'package:fotpm/pages/otp_list.dart';
import 'package:fotpm/utils/storage_util.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
            child: Text(
          "Flutter OTP Manager",
          textAlign: TextAlign.center,
        )),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                String p = "";
                if (Platform.isAndroid) {
                  Directory("/storage/emulated/0/Download/")
                      .exists()
                      .then((value) {
                    p = value
                        ? "/storage/emulated/0/Download/otpList.txt"
                        : "/storage/emulated/0/Downloads/otpList.txt";
                  });
                } else {
                  getDownloadsDirectory().then((value) {
                    p = path.join(value!.path, "otpList.txt");
                  });
                }
                var f = io.File(p);
                f.writeAsStringSync(
                    StorageUtil.read(StorageOption.otpList).toString());
              }),
        ],
      ),
      body: const OTPList(),
      floatingActionButton:
          FloatingActionButton(onPressed: _onAdd, child: const Icon(Icons.add)),
    );
  }

  void _onAdd() {
    Navigator.pushNamed(context, "/otp/add");
  }
}
