import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuariosService = UsuarioService();

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            authService.usuario.nombre,
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              // desconectar el socket
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Icon(
                  socketService.serverStatus == ServerStatus.Online
                      ? Icons.check_circle
                      : Icons.offline_bolt,
                  color: socketService.serverStatus == ServerStatus.Online
                      ? Colors.blue[400]
                      : Colors.red),
            )
          ],
        ),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(
              complete: Icon(
                Icons.check,
                color: Colors.blue[400],
              ),
              waterDropColor: Colors.blue[400],
            ),
            onRefresh: _cargarUsuarios,
            controller: _refreshController,
            child: _listviewUsuarios()));
  }

  void _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  ListView _listviewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) {
          return _usuarioListTitle(usuarios[i]);
        },
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTitle(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green.shade300 : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
