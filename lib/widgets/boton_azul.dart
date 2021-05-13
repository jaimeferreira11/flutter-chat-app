import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String label;
  final Function onPress;

  const BotonAzul({Key key, @required this.label, @required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 2, primary: Colors.blue, shape: StadiumBorder()),
          child: Container(
            width: double.infinity,
            height: 55.0,
            child: Center(
                child: Text(
              this.label,
              style: TextStyle(fontSize: 18.0),
            )),
          ),
          onPressed: this.onPress),
    );
  }
}
