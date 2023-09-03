import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileStoreMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String applicationType = '';
  SettableMetadata? metadata;

  Future<String> uploadFile(
    File file,
    String filefolderName,
    String filename,
    String id,
  ) async {
    Reference ref = _firebaseStorage
        .ref()
        .child(filefolderName)
        .child(FirebaseAuth.instance.currentUser!.displayName!)
        .child(filename)
        .child(id);

    String fileExtension = file.path.split('.').last.toLowerCase();

    if (fileExtension == 'pdf') {
      applicationType = 'application/pdf';
      metadata = SettableMetadata(
        contentType: applicationType,
        customMetadata: {
          'description': 'Files',
          'Id': id,
        },
        contentEncoding: 'utf-8',
        cacheControl: 'no-cache',
        contentLanguage: 'en',
        contentDisposition: 'inline',
      );
    } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      applicationType = 'image/jpeg';
      metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'description': 'Photo',
          'Id': id,
        },
      );
    } else if (fileExtension == 'png') {
      applicationType = 'image/png';
      metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {
          'description': 'Photo',
          'Id': id,
        },
      );
    } else if (fileExtension == 'heic') {
      applicationType = 'image/heic';
      metadata = SettableMetadata(
        contentType: 'image/heic',
        customMetadata: {
          'description': 'Photo',
          'Id': id,
        },
      );
    } else if (fileExtension == 'mp4') {
      applicationType = 'video/mp4';
      metadata = SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {
          'description': 'Video',
          'Id': id,
        },
      );
    } else if (fileExtension == 'mp3') {
      applicationType = 'audio/mpeg';
      metadata = SettableMetadata(
        contentType: 'audio/mpeg',
        customMetadata: {
          'description': 'Audio',
          'Id': id,
        },
      );
    } else {
      // Handle other media types as needed
    }
    UploadTask uploadTask = ref.putFile(file, metadata);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> fileUpload(
    File file,
    String filefolderName,
    String filename,
    String id,
  ) async {
    String res = "Some Error Occured";
    try {
      String url = await uploadFile(file, filefolderName, filename, id);
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      DocumentReference userDoc;

      userDoc = FirebaseFirestore.instance.collection('descriptions').doc(id);

      String fileExtension = file.path.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      } else if (fileExtension == 'png') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      } else if (fileExtension == 'heic') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      }
      if (fileExtension == 'mp4') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      } else if (fileExtension == 'mp3') {
        await userDoc.update({
          'userid': uid,
          filename: url,
          '${filename}_Id': id,
        });
      } else {
        // Handle other media types as needed
      }
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
