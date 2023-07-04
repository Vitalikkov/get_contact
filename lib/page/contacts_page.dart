
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_contact/components/contact_list.dart';
import 'package:get_contact/contacts_model.dart';
import 'package:get_contact/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../components/button.dart';

class ContactPage extends StatefulWidget{
  
  @override
  _ContactPageState createState() => _ContactPageState();


 

}

class _ContactPageState extends State<ContactPage> with WidgetsBindingObserver{

  late final ContactModel _model;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _model = ContactModel();

    _askGetConatcsPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.contactSection == ContactSection.noContactsPermissionPermanent)) {
      _detectPermission = false;
      _model.requestContactsPermission();
    } else if (state == AppLifecycleState.paused &&
        _model.contactSection == ContactSection.noContactsPermissionPermanent) {
      _detectPermission = true;
    }
  }

  Future<void> _askGetConatcsPermission() async {
    final hasContactPermission = await _model.requestContactsPermission();
    if (hasContactPermission) {
      try {
        await _model.fetchContacts();
      } on Exception catch (e) {
        debugPrint('Error: $e');
        // Show an error to the user if the pick file failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please allow to "Get Contacts"'),
          ),
        );
      }
    }
  }


  Future<void> _showAppSettingsDialog() async {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Permission Required'),
                content: const Text('Please grant access to contacts in App Settings.'),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),

                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Open Settings'),

                  ),
                ],
              );
            },
          );

          if (result == true) {
            openAppSettings();
          }
        }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<ContactModel>(
        builder: (context, model, child) {
          Widget widget;

          switch (model.contactSection) {
            case ContactSection.noContactsPermission:
              widget = GetButton(onPressed: _askGetConatcsPermission);
              break;
            case ContactSection.noContactsPermissionPermanent:
              widget = GetButton(onPressed: _showAppSettingsDialog);
              break;
            case ContactSection.isFetching:
              widget = const Center(child: CircularProgressIndicator());
              break;
            case ContactSection.isEmpty:
              widget = const Center(child: Text('You don\'t have contacts'));
              break;
            case ContactSection.isLoaded:
              widget = ContactList(contacts: _model.contacts);
              break;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(MyApp.title),
            ),
            body: widget,
          );
        },
      ),
    );
  }
}

