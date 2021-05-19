import 'dart:io';

import 'package:chat/models/mensaje.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensajes);

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> chat = await this.chatService.getChat(uid);

    final historial = chat.map((e) => new ChatMessage(
        texto: e.mensaje,
        uid: e.de,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300))
          ..forward()));

    _messages.insertAll(0, historial);
    setState(() {});
  }

  void _escucharMensajes(dynamic data) {
    ChatMessage mensaje = new ChatMessage(
        texto: data['mensaje'],
        uid: data['de'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));

    _messages.insert(0, mensaje);
    setState(() {});
    mensaje.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          title: Column(
            children: [
              CircleAvatar(
                maxRadius: 14,
                child: Text(
                  chatService.usuarioPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                chatService.usuarioPara.nombre,
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  return _messages[i];
                },
              )),
              Divider(
                height: 1,
              ),
              Container(
                color: Colors.white,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: textController,
            onSubmitted: _handleSubmit,
            onChanged: (value) {
              if (value.trim().length > 0) {
                _estaEscribiendo = true;
              } else {
                _estaEscribiendo = false;
              }
              setState(() {});
            },
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // boton enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: !_estaEscribiendo
                        ? null
                        : () => _handleSubmit(textController.text.trim()))
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        color: Colors.blue[400],
                        onPressed: !_estaEscribiendo
                            ? null
                            : () => _handleSubmit(textController.text.trim())),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    final messasge = ChatMessage(
      texto: texto,
      uid: this.authService.usuario.uid,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, messasge);
    messasge.animationController.forward();

    textController.clear();
    _focusNode.requestFocus();
    _estaEscribiendo = false;
    setState(() {});
    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    this.socketService.socket.off('mensaje-personal');

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
