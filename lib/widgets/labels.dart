import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String textHasAccount;
  final String textRuta;

  const Labels(
      {super.key,
      required this.ruta,
      required this.textHasAccount,
      required this.textRuta});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.textHasAccount,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(this.textRuta,
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
