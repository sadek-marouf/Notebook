import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class costmer extends StatefulWidget {
  final String? namee;

  final String? title;
  final TextEditingController mycontroler;
  final String? Function(String?)? validator;
  IconData? iconn;

  costmer(
      {super.key,
      required this.iconn,
      required this.namee,
      required this.title,
      required this.mycontroler,
      required this.validator});

  @override
  State<costmer> createState() => _costmerState();
}

class _costmerState extends State<costmer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            child: Text(
              "${widget.title}",
              style: TextStyle(
                  color: Colors.purple[600],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 70,
            child: TextFormField(
              validator: widget.validator,
              controller: widget.mycontroler,
              decoration: InputDecoration(
                  hintText: "${widget.namee} ",
                  fillColor: Colors.grey[300],
                  filled: true,
                  icon: Icon(
                    widget.iconn,
                    color: Colors.purple[600],
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 197, 103, 97),
                        width: 5,
                      )),
                  focusColor: Colors.purple[600],
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(60))),
            ),
          ),
        ],
      ),
    );

    ;
  }
}

bool light = true;
