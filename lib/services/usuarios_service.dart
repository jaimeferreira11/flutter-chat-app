import 'package:chat/global/enviroment.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_services.dart';

import 'package:http/http.dart' as http;

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    final token = await AuthService.getToken();

    try {
      final resp = await http.get(Uri.parse('${Enviroment.apiUrl}/usuarios'),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      if (resp.statusCode == 200) {
        final usuarioResponse = usuariosResponseFromJson(resp.body);

        return usuarioResponse.usuarios;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
