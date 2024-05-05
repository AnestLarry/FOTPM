import 'package:dart_dash_otp/dart_dash_otp.dart';
import 'package:flutter/material.dart';
import 'package:fotpm/entities/otp_item.dart';

class OTPItemWidget extends StatelessWidget {
  final OTPItem item;
  final Function(OTPItem) deleteCallback;

  final bool fillColor;

  const OTPItemWidget(
      {super.key,
      required this.item,
      this.fillColor = false,
      required this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: fillColor == true ? const Color(0xFFDFDFDF) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            child: Flex(direction: Axis.horizontal, children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_2,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(item.name)
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(TOTP(
                            secret: item.secret,
                            digits: item.digits,
                            interval: item.interval,
                            algorithm: item.algorithm)
                        .now())
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text((item.interval - DateTime.now().second % item.interval)
                        .toString())
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      deleteCallback(item);
                    },
                    child: Icon(
                      Icons.delete_outline_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ])));
  }
}
