import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/lables.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  titulo: 'Messenger',
                ),
                _Form(),
                Labels(
                  label1: 'No tienes cuenta?',
                  label2: 'Crea una cuenta ahora!',
                  ruta: 'register',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(
        top: 40.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passController,
            isPassword: true,
          ),
          BotonAzul(
            label: "Login",
            onPress: authService.autenticando
                ? null
                : () async {
                    // ocultar el teclado
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailController.text.trim(),
                        passController.text.trim());
                    if (loginOk) {
                      // conectar al socket
                      socketService.connect();
                      // navegar a otra pantalla
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      // Mostrar alerta
                      mostrarAlerta(context, 'Login incorrecto',
                          "Credenciales invalidas");
                    }
                  },
          )
        ],
      ),
    );
  }
}
