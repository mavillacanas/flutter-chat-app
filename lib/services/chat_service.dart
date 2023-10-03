import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/models/usuario.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/global/environment.dart';

class ChatService with ChangeNotifier {
  Usuario? usuarioPara;

  Future getChat(String usuarioID) async {
    try {
      final token = await AuthService.getToken();

      final resp = await http.get(
          Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'),
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      // TODO: verificar que la respuesta es OK
      final mesajesResponse = mensajesResponseFromJson(resp.body);
      return mesajesResponse.mensajes;
    } catch (e) {
      return [];
    }
  }
}
