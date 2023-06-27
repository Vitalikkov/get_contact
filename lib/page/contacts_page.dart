
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_contact/main.dart';
import 'package:get_contact/page/contact_item.dart';
import 'package:get_contact/permission_setting.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactPage extends StatefulWidget{
  
  @override
  _ContactPageState createState() => _ContactPageState();


 

}

class _ContactPageState extends State<ContactPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Contact> contacts = [];
  bool isLoading = true;
 
  @override
  void initState() {
    super.initState();
    askGetConatcsPermission();
  }

  Future askGetConatcsPermission() async{
    final permission = await ContactUtils.getContactsPermission();

    switch (permission) {
      case PermissionStatus.granted:
        fetchContacts();
        break;
      case PermissionStatus.denied:
        setState(() {
          isLoading = false;
        });
        showSnackBar();
        break;
      case PermissionStatus.permanentlyDenied:
        showAppSettingsDialog();
        break;
      default:
        showSnackBar();
        setState(() {
          isLoading = false;
        });
        break;

    }
    
  }

  void showSnackBar() async {
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('Please allow to "Get Contacts"'),
            duration: Duration(seconds: 3),
          ),
        );
  }

  Future<void> showAppSettingsDialog() async {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Permission Required'),
                content: Text('Please grant access to contacts in App Settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Open Settings'),
                  ),
                ],
              );
            },
          );

          if (result == true) {
            openAppSettings();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }

  void fetchContacts() async {
   contacts = await ContactsService.getContacts();
   setState(() {
        isLoading = false;
      });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar (
        title: Text(MyApp.title),
      ),
      body:  isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty 
            ? buildButton(context) 
            : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactItem(name: contacts[index].givenName!, number: contacts[index].phones![0].value!, avater:contacts[index].avatar! ,),
                        ),
                      );
                    }, 
                  child: ListTile(
                   leading: CircleAvatar(
                    backgroundImage: contacts[index].avatar?.isNotEmpty == true
                        ? null
                        : MemoryImage(contacts[index].avatar!),
                    child: contacts[index].avatar?.isEmpty == true
                        ? Text(
                            contacts[index].givenName![0],
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
                      contacts[index].givenName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      contacts[index].phones![0].value!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    horizontalTitleGap: 12,
                  ),
                );
              },
            ), 
      );
    
  }


  Widget buildButton(
        BuildContext context) =>
          Container(
            child: Center(
              child:FilledButton(
                  onPressed: askGetConatcsPermission,
                  child: Text('Get Contant'),
                  ),
              
            ),
          );
          
        
        



}

