import 'package:chat/models/usuarios_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat/models/usuario.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthService.getToken();

      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
