import 'package:chat/global/enviroment.dart';
import 'package:chat/models/mensaje.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'auth_services.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final token = await AuthService.getToken();

    print(usuarioID);

    try {
      final resp = await http.get(
          Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioID'),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      if (resp.statusCode == 200) {
        final mensajesResponse = mensajesResponseFromJson(resp.body);

        return mensajesResponse.mensajes;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
