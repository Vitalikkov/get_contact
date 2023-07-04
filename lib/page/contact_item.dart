import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_contact/main.dart';
import 'package:get_contact/image_model.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactItem extends StatefulWidget {
  
  final String name;
  final String number;
  final Uint8List? avatar;
  final Function(Uint8List? avatar)? onAvatarChanged;

  const ContactItem({Key? key, required this.name, required this.number, required this.avatar, required this.onAvatarChanged,}): super(key: key);

  @override
  State<ContactItem> createState() => _ContactItemState();

}

class _ContactItemState extends State<ContactItem> with WidgetsBindingObserver{
  late final ImageModel _model;
  bool _detectPermission = false;
  bool _hasAvatar = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _model = ImageModel();
    _hasAvatar = widget.avatar != null && widget.avatar!.isNotEmpty;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasAvatar = widget.avatar != null && widget.avatar!.isNotEmpty;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.imageSection == ImageSection.noStoragePermissionPermanent)) {
      _detectPermission = false;
      _model.requestFilePermission();
    } else if (state == AppLifecycleState.paused &&
        _model.imageSection == ImageSection.noStoragePermissionPermanent) {
      _detectPermission = true;
    }
  }

  Future<void> _askPermission(Uint8List? currentAvatar) async {
    _checkPermissionsAndPickImage();
    switch (_model.imageSection) {
      case ImageSection.noStoragePermission:
        _checkPermissionsAndPickImage();
        break;
      case ImageSection.noStoragePermissionPermanent:
         _showAppSettingsDialog();
        break;
      case ImageSection.isBrowse:

        break;
      case ImageSection.isLoaded:
        if (_model.file != null) {
          widget.onAvatarChanged?.call(_model.file?.readAsBytesSync());
        } else {
          widget.onAvatarChanged?.call(currentAvatar);
        }
        break;
    }
  }

  Future<void> _checkPermissionsAndPickImage() async {
    final hasFilePermission = await _model.requestFilePermission();
    if (hasFilePermission) {
      try {
        await _model.pickImage();
      } on Exception catch (e) {
        debugPrint('Error when picking a file: $e');
        // Show an error to the user if the pick file failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when picking a image'),
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
          content: const Text('Please grant access to photo in App Settings.'),
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
            GestureDetector(
              onTap: (){
                _askPermission(widget.avatar);
              },
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  image: _model.file != null
                      ? DecorationImage(
                    image: MemoryImage(File(_model.file!.path) as Uint8List) as ImageProvider<Object>,
                    fit: BoxFit.cover,
                  )
                      : (widget.avatar != null && widget.avatar!.isNotEmpty
                      ? DecorationImage(
                    image: MemoryImage(widget.avatar!),
                    fit: BoxFit.cover,
                  )
                      : null),
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_model.file == null &&
                          (widget.avatar == null || widget.avatar!.isEmpty))
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
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.name),
            const SizedBox(
              height: 15,
            ),
            Text(widget.number),
          ]
          ),
      )
    );
  }


}