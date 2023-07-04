import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get_contact/page/contact_item.dart';


class ContactList extends StatefulWidget{
  final List<Contact>? contacts;

  const ContactList({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contacts?.length ?? 0,
      itemBuilder: (context, index) {
        Uint8List? image = widget.contacts?[index].photo;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactItem(
                  name:
                  '${widget.contacts?[index].name.first} ${widget.contacts?[index].name.last}',
                  number: widget.contacts?[index].phones.first.number ?? '',
                  avatar: widget.contacts?[index].photo ?? Uint8List(0),
                ),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: image != null && image.isNotEmpty
                  ? MemoryImage(image)
                  : null,
              child: (image == null || image.isEmpty)
                  ? Text(
                widget.contacts?[index].name.first?[0] ?? '',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.primaries[
                  Random().nextInt(Colors.primaries.length)],
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              )
                  : null,
            ),
            title: Text(
              '${widget.contacts?[index].name.first} ${widget.contacts?[index].name.last}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              widget.contacts?[index].phones.first.number ?? '', // Використовуйте оператор ?? для надання значення за замовчуванням
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            horizontalTitleGap: 12,
          ),
        );
      },
    );
  }
}



