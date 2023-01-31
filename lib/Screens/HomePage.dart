import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:notes_app_flutter/Screens/Login_Screen.dart';
import 'package:notes_app_flutter/Screens/User_Profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  //Instance of FirebaseFirestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController notecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController upnotecontroller = TextEditingController();
  TextEditingController uptitlecontroller = TextEditingController();

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  void createNote() async {
    String note = notecontroller.text;
    String title = titlecontroller.text;

    if (note != '' && title != '') {
      Map<String, dynamic> notes = {'note': note, 'title': title};
      notecontroller.clear();
      titlecontroller.clear();

      await firestore.collection('Notess').add(notes);
    } else {
      Fluttertoast.showToast(msg: 'title & content can\'t be empty ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        title: const Text(
          'Note',
          style: TextStyle(fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => const UserProfile())));
              },
              icon: const Icon(
                Icons.person,
                size: 28,
              )),
          IconButton(
              onPressed: () {
                Dialogs.materialDialog(
                    msg: 'Are You Sure Want to Logout',
                    title: 'Logout',
                    titleStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    color: Colors.white,
                    context: context,
                    barrierDismissible: false,
                    actions: [
                      Column(
                        children: [
                          LottieBuilder.asset('Assets/Images/logout.json'),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconsButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: 'Cancel',
                                iconData: Icons.cancel_outlined,
                                color: Colors.red,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconsButton(
                                onPressed: () {
                                  logout();
                                  Navigator.pop(context);
                                },
                                text: 'Logout',
                                iconData: Icons.create,
                                color: Colors.green,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ],
                          )
                        ],
                      )
                    ]);
              },
              icon: const Icon(
                Icons.more_vert_outlined,
                size: 28,
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('Notess').snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: ((context, index) {
                                  Map<String, dynamic> data =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;

                                  var docId =
                                      snapshot.data!.docs[index].reference.id;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 5, bottom: 5),
                                    child: Slidable(
                                      startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) {
                                              firestore
                                                  .collection('Notess')
                                                  .doc(docId)
                                                  .delete();
                                            }),
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    uptitlecontroller.text =
                                                        data['title'];
                                                    upnotecontroller.text =
                                                        data['note'];
                                                    return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13)),
                                                        backgroundColor:
                                                            Colors.white,
                                                        title: const Text(
                                                          'Update',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        actions: [
                                                          Column(
                                                            children: [
                                                              TextField(
                                                                controller:
                                                                    uptitlecontroller,
                                                                decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    prefixIcon:
                                                                        const Icon(
                                                                            Icons.edit)),
                                                              ),
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    upnotecontroller,
                                                                decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    prefixIcon:
                                                                        const Icon(
                                                                            Icons.edit)),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconsButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    text:
                                                                        'Cancel',
                                                                    iconData: Icons
                                                                        .cancel_outlined,
                                                                    color: Colors
                                                                        .red,
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  IconsButton(
                                                                    onPressed:
                                                                        () {
                                                                      firestore
                                                                          .collection(
                                                                              'Notess')
                                                                          .doc(
                                                                              docId)
                                                                          .update({
                                                                        'title':
                                                                            uptitlecontroller.text,
                                                                        'note':
                                                                            upnotecontroller.text
                                                                      });
                                                                      upnotecontroller
                                                                          .clear();
                                                                      uptitlecontroller
                                                                          .clear();

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    text:
                                                                        'Update',
                                                                    iconData: Icons
                                                                        .create,
                                                                    color: Colors
                                                                        .green,
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ]);
                                                  });
                                            },
                                            backgroundColor:
                                                const Color(0xFF7BC043),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit',
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Title',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  data['title'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                const Text(
                                                  'Content',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  data['note'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                          } else {
                            return const Center(
                              child: Text('Error'),
                            );
                          }
                        } else {
                          return const Center(
                              child: SpinKitSpinningLines(
                            color: Colors.black,
                            duration: Duration(seconds: 3),
                            size: 60,
                          ));
                        }
                      })),
                )
              ],
            ),
            Positioned(
              left: 330,
              top: 730,
              child: FloatingActionButton(
                tooltip: 'create note',
                onPressed: (() {
                  Dialogs.materialDialog(
                      title: 'Note',
                      titleStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      color: Colors.white,
                      context: context,
                      barrierDismissible: false,
                      actions: [
                        Column(
                          children: [
                            TextField(
                              controller: titlecontroller,
                              decoration: InputDecoration(
                                  hintText: 'title',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.edit)),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            TextField(
                              controller: notecontroller,
                              decoration: InputDecoration(
                                  hintText: 'what\'s in your mind',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.edit)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconsButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'Cancel',
                                  iconData: Icons.cancel_outlined,
                                  color: Colors.red,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    createNote();
                                    Navigator.pop(context);
                                  },
                                  text: 'Create',
                                  iconData: Icons.create,
                                  color: Colors.green,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ],
                            )
                          ],
                        )
                      ]);
                }),
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
