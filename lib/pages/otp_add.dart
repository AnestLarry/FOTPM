import 'package:dart_dash_otp/dart_dash_otp.dart';
import 'package:flutter/material.dart';
import 'package:fotpm/entities/otp_item.dart';
import 'package:fotpm/utils/storage_util.dart';

class OTPAddWidget extends StatefulWidget {
  const OTPAddWidget({super.key});

  @override
  State<StatefulWidget> createState() => _OTPAddWidgetState();
}

class _OTPAddWidgetState extends State<OTPAddWidget> {
  OTPAlgorithm algorithm = OTPAlgorithm.SHA256;
  List<TextEditingController> formControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    formControllers[2].text = "6";
    formControllers[3].text = "30";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otp Add Panel"),
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 30, bottom: 35),
          child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: formControllers[0],
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: "name",
                            icon: Icon(Icons.person)),
                        validator: (v) {
                          return v!.trim().isNotEmpty
                              ? null
                              : "name is invalid";
                        },
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: formControllers[1],
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: "secret",
                            icon: Icon(Icons.lock)),
                        validator: (v) {
                          return v!.trim().isNotEmpty
                              ? null
                              : "secret is invalid";
                        },
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: formControllers[2],
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: "digits",
                            icon: Icon(Icons.numbers_rounded)),
                        validator: (v) {
                          return RegExp(r'^\d+$').hasMatch(v!) &&
                                  int.parse(v) > 0
                              ? null
                              : "digits is invalid";
                        },
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: formControllers[3],
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: "interval",
                            icon: Icon(Icons.timer)),
                        validator: (v) {
                          return RegExp(r'^\d+$').hasMatch(v!) &&
                                  int.parse(v) > 0
                              ? null
                              : "interval is invalid";
                        },
                      ),
                      Row(
                        children: [
                          const Icon(Icons.shield),
                          Container(
                            width: 16,
                          ),
                          Expanded(
                              child: DropdownButton(
                            hint: const Text("Algorithm"),
                            value: algorithm,
                            icon: const Icon(null),
                            items: OTPAlgorithm.values
                                .map((OTPAlgorithm e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ))
                                .toList(),
                            onChanged: (ctx) {
                              setState(() {
                                algorithm = ctx!;
                              });
                            },
                          ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Flex(direction: Axis.horizontal, children: [
                          const Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                  onPressed: () {
                                    StorageUtil.requestPermission()
                                        .then((value) => null);
                                    OTPItem item = OTPItem(
                                        formControllers[0].text,
                                        formControllers[1].text);

                                    item.digits =
                                        int.parse(formControllers[2].text);
                                    item.interval =
                                        int.parse(formControllers[3].text);
                                    item.algorithm = algorithm;
                                    final res =
                                        StorageUtil.readT<List<dynamic>>(
                                            StorageOption.otpList);
                                    List<OTPItem> list = [];
                                    if (res != null) {
                                      list = OTPItem.fromJSONIterableDynamic(
                                              res as Iterable)
                                          .toList();
                                    }
                                    list.add(item);
                                    StorageUtil.saveT<List<OTPItem>>(
                                        StorageOption.otpList, list);

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Insert"))),
                          const Expanded(flex: 2, child: SizedBox())
                        ]),
                      )
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: e,
                            ))
                        .toList(),
                  )))),
    );
  }
}
