import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fotpm/components/otp_item_widget.dart';
import 'package:fotpm/entities/otp_item.dart';
import 'package:fotpm/utils/storage_util.dart';

class OTPList extends StatefulWidget {
  const OTPList({super.key});

  @override
  State<StatefulWidget> createState() => _OTPListState();
}

class _OTPListState extends State<OTPList> {
  List<OTPItem> items = [];
  late Timer timer;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        items = items;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deleteItem(OTPItem i) {
      items = items.where((e) => e.name != i.name).toList();
      StorageUtil.saveT(StorageOption.otpList, items);
    }

    try {
      Iterable? temp = StorageUtil.readT<Iterable>(StorageOption.otpList);
      if (temp != null) {
        items = OTPItem.fromJSONIterableDynamic(temp).toList();
      }
    } finally {}
    var now = DateTime.now();
    List<Widget> ws = [
      const Divider(),
    ];
    var i = 1;
    for (var item in items) {
      if (item.name.contains(textEditingController.text)) {
        try {
          ws.add(OTPItemWidget(
            item: item,
            fillColor: i & 1 == 0,
            deleteCallback: deleteItem,
          ));
          ws.add(const Divider());
        } catch (e) {
          continue;
        }
        i++;
      }
    }
    return Column(
      children: [
        ListTile(
          title: Text(
            "${now.year.toString()}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(0),
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
                hintText: "filter", prefixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
            child: ListView(
          children: ws,
        ))
      ],
    );
  }
}
