import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();
  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    this._autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this._autenticando = false;

    if (resp.statusCode == 200) {
      print(resp.body);
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this._autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
      "online": true
    };

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this._autenticando = false;

    if (resp.statusCode == 200) {
      print(resp.body);
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  // Getter del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = _storage.read(key: 'token');
    return token;
  }

  Future<bool> isLoggedIn() async {
    final String? token = await this._storage.read(key: 'token');
    if (token == null) return false;

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token!});

    if (resp.statusCode == 200) {
      print(resp.body);
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  static Future deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future logout() async {
    // Write value
    await _storage.delete(key: 'token');
  }
}
