import 'dart:io';

class Environment {
  static String apiUrl = Platform.isIOS
      ? 'http://localhost:3000/api'
      : 'http://192.168.2.164:3000/api';

  static String socketUrl =
      Platform.isIOS ? 'http://localhost:3000/' : 'http://192.168.2.164:3000/';
}
