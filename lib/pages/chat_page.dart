import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [];

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
                  'Te',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Nombre',
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
    print(texto);

    final messasge = ChatMessage(
      texto: texto,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, messasge);
    messasge.animationController.forward();

    textController.clear();
    _focusNode.requestFocus();
    _estaEscribiendo = false;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
