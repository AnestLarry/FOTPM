import 'dart:convert';
import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum StorageOption { otpList }

var _aStorageOptionMap = <StorageOption, String>{};

class StorageUtil {
  static Future<void> initUtil() async {
    while (!await requestPermission()) {}
    _aStorageOptionMap = {
      StorageOption.otpList: path.join(
          (await getApplicationDocumentsDirectory()).path, "data/otpList.json")
    };
  }

  static void save(StorageOption option, String s) {
    requestPermission().then((value) => null);
    var p = _aStorageOptionMap[option]!;
    ensureFolder(p.substring(0, p.lastIndexOf("/")));
    ensureFile(p);
    var f = io.File(p);
    f.writeAsStringSync(s);
  }

  static void saveT<T>(StorageOption option, T t) {
    requestPermission().then((value) => null);
    var p = _aStorageOptionMap[option]!;
    ensureFolder(p.substring(0, p.lastIndexOf("/")));
    ensureFile(p);
    var f = io.File(p);
    f.writeAsStringSync(jsonEncode(t));
  }

  static T? readT<T extends Object>(StorageOption option,
      {Encoding encoding = utf8}) {
    requestPermission().then((value) => null);
    var f = io.File(_aStorageOptionMap[option]!);
    if (f.existsSync()) {
      return jsonDecode(f.readAsStringSync(encoding: encoding));
    } else {
      return null;
    }
  }

  static String? read(StorageOption option, {Encoding encoding = utf8}) {
    requestPermission().then((value) => null);
    var f = io.File(_aStorageOptionMap[option]!);
    if (f.existsSync()) {
      return f.readAsStringSync(encoding: encoding);
    } else {
      return null;
    }
  }

  static void ensureFolder(String path) {
    if (!io.Directory(path).existsSync()) {
      io.Directory(path).createSync(recursive: true);
    }
  }

  static void ensureFile(String path) {
    if (!io.File(path).existsSync()) {
      io.File(path).createSync(recursive: true);
    }
  }

  static Future<bool> requestPermission() async {
    // 请求权限
    PermissionStatus permission = await Permission.storage.request();
    // 如果权限被永久拒绝,则打开应用设置
    if (permission == PermissionStatus.permanentlyDenied ||
        permission == PermissionStatus.denied) {
      await openAppSettings();
    }
    // 返回权限状态
    return permission == PermissionStatus.granted;
  }
}
