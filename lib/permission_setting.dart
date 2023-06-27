import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactUtils {
  static Future<PermissionStatus> getContactsPermission() async {
    final permission = await Permission.contacts.status;

    if(permission.isDenied){
      return await Permission.contacts.request();
    }

   return permission;
  }
}

class PhotoUtils {
  Future<PermissionStatus?> getPhotosPermission() async {
    final permission = await Permission.photos.status;

    if(permission.isDenied){
      return await Permission.photos.request();
    }

   return permission;
    }
}

