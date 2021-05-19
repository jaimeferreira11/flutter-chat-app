// To parse this JSON data, do
//
//     final mensaje = mensajeFromJson(jsonString);

import 'dart:convert';

Mensaje mensajeFromJson(String str) => Mensaje.fromJson(json.decode(str));

String mensajeToJson(Mensaje data) => json.encode(data.toJson());

class Mensaje {
  Mensaje({
    this.de,
    this.para,
    this.mensaje,
    this.createdAt,
    this.updatedAt,
  });

  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: json["createdAt"] == null
            ? new DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["createdAt"] == null
            ? new DateTime.now()
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt == null ? '' : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? '' : updatedAt.toIso8601String(),
      };
}
