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
    final PermissionStatus permission = await Permission.photos.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.photos].request();
      return permissionStatus[Permission.photos];
    } else {
      return permission;
    }
  }
}
