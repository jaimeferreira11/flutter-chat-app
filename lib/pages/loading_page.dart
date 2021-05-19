import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chechLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Iniciando...'),
          );
        },
      ),
    );
  }

  Future chechLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    print('El usuario tiene login: $autenticado');
    if (autenticado) {
      // Conectar al socket
      socketService.connect();
      //Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 0),
              pageBuilder: (_, __, ___) => UsuariosPage()));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 0),
              pageBuilder: (_, __, ___) => LoginPage()));
    }
  }
}
