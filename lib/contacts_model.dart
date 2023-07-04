import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

enum ContactSection {
  noContactsPermission,
  noContactsPermissionPermanent,
  isFetching,
  isEmpty,
  isLoaded,
}

class ContactModel extends ChangeNotifier {
  ContactSection _contactSection = ContactSection.isFetching;

  ContactSection get contactSection => _contactSection;

  set contactSection(ContactSection value) {
    if (value != _contactSection) {
      _contactSection = value;
      notifyListeners();
    }
  }

  List<Contact> contacts =[];

  Future<bool> requestContactsPermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = await Permission.contacts.request();
    } else {
      result = await Permission.contacts.request();
    }

    if (result.isGranted) {
      contactSection = ContactSection.isFetching;
      return true;
    } else if (Platform.isIOS || result.isPermanentlyDenied) {
      contactSection = ContactSection.noContactsPermissionPermanent;
    } else {
      contactSection = ContactSection.noContactsPermission;
    }
    return false;
  }

  Future<void> fetchContacts() async {
    final hasPermission = await requestContactsPermission();
    if (!hasPermission) {
      return;
    }

    contactSection = ContactSection.isFetching;

    try {
      final contactsResult = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      if (contactsResult.isNotEmpty) {
        contacts = contactsResult;
        contactSection = ContactSection.isLoaded;
      } else {
        contactSection = ContactSection.isEmpty;
      }
    } catch (e) {
      contactSection = ContactSection.isEmpty;
    }
  }
}
