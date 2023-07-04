import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_contact/main.dart';
import 'package:get_contact/image_model.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactItem extends StatefulWidget {
  
  final String name;
  final String number;
  final Uint8List? avatar;

  const ContactItem({Key? key, required this.name, required this.number, required this.avatar}): super(key: key);

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
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                image: widget.avatar != null && widget.avatar!.isNotEmpty
                    ? DecorationImage(
                  image: MemoryImage(widget.avatar!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: ClipOval(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.avatar == null || widget.avatar!.isEmpty)
                    const Icon(
                      size: 50,
                      color: Colors.white,
                      Icons.person,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Center(
                          child: Icon(

                            color: Colors.white,
                            Icons.photo_camera_outlined,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
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