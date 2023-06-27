import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_contact/main.dart';
import 'package:get_contact/permission_setting.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


class ContactItem extends StatefulWidget {
  
  final String name;
  final String number;
  final Uint8List avater;

  const ContactItem({Key? key, required this.name, required this.number, required this.avater}): super(key: key); 

  @override
  State<ContactItem> createState() => _ContactItemState();

}

class _ContactItemState extends State<ContactItem> {
  


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 50,
              child: Stack(
                children: [
                    Icon(
                    size: 50,
                    Icons.person,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera_outlined,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
            SizedBox(
              height: 20,
            ),
            Text(widget.name),
            SizedBox(
              height: 15,
            ),
            Text(widget.number),
          ]
          ),
      )
    );
  }


}