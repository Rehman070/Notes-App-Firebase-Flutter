import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? profileDP;

  void profileImage() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedImage = File(selectedImage.path);

      setState(() {
        profileDP = convertedImage;
      });

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProfileDPs')
          .child(const Uuid().v1())
          .putFile(profileDP!);

      TaskSnapshot taskSnapshot = await uploadTask;
      Fluttertoast.showToast(msg: 'Image Uploaded Sucessfully!');

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> storeImage = {'profileImage': downloadUrl};

      FirebaseFirestore.instance.collection('DPs').add(storeImage);
    } else {
      Fluttertoast.showToast(msg: 'Cancel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 66,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: 390,
              height: 780,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CupertinoButton(
                      onPressed: () {
                        profileImage();
                      },
                      child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade500,
                          backgroundImage: (profileDP != null)
                              ? FileImage(profileDP!)
                              : null)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Name Here',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Your Email Here',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Colors.black12,
                    indent: 50,
                    endIndent: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'About App',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27, right: 20),
                    child: Container(
                      child: Column(
                        children: const [
                          Text(
                            "Notes is the best place to jot down quick thoughts or to save longer notes filled with checklists, images, web links, scanned documents, handwritten notes, or sketches. And with iCloud, it's easy to keep all your devices in sync, so you'll always have your notes with you.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )),
                      const SizedBox(
                        width: 50,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Help',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
