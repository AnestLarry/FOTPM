import 'package:dart_dash_otp/dart_dash_otp.dart';

class OTPItem {
  String name;
  String secret;
  OTPAlgorithm algorithm;
  int digits;
  int interval;

  OTPItem(this.name, this.secret,
      {this.algorithm = OTPAlgorithm.SHA256,
      this.digits = 6,
      this.interval = 30});

  @override
  String toString() {
    return 'OTPItem{name: $name, secret: $secret, algorithm: $algorithm, digits: $digits, interval: $interval}';
  }

  factory OTPItem.fromJson(Map<String, dynamic> map) {
    return OTPItem(map["name"], map["secret"],
        digits: map["digits"],
        interval: map["interval"],
        algorithm: OTPAlgorithm.values
            .where((element) => element.name == map["algorithm"])
            .first);
  }

  static Iterable<OTPItem> fromJSONIterableDynamic(Iterable<dynamic> list) {
    return list.map((e) => OTPItem.fromJson(e));
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "secret": secret,
      "algorithm": algorithm.name,
      "digits": digits,
      "interval": interval
    };
  }
}
