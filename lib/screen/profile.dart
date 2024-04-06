import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatschat_app/screen/forgot_pass.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final currentUser = FirebaseAuth.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[100]!,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['image_url']),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.docs[index]['username'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Email Address',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(snapshot.data!.docs[index]['email']),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                elevation: 1,
                                fixedSize: const Size(150, 40),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Log out'),
                                      content: const Text(
                                          'Are you sure?? you want to Sign out.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'no',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            FirebaseAuth.instance.signOut();
                                          },
                                          child: const Text(
                                            'yes',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Log out',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetPassword(),
                                      ));
                                },
                                child: const Text('Forgot Password??')),
                            const Spacer()
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'all user of this app can view your messeges in that group chat.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            elevation: 1,
                            fixedSize: const Size(150, 40),
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                      'Are you sure?? You want to delete your account.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'no',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        FirebaseStorage.instance
                                            .ref()
                                            .child(
                                                'user_images/${snapshot.data!.docs[index]['email']}.jpg')
                                            .delete();
                                        FirebaseAuth.instance.currentUser!
                                            .delete();
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(uid)
                                            .delete()
                                            .then((value) => FirebaseAuth
                                                .instance
                                                .signOut());
                                      },
                                      child: const Text(
                                        'yes',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Note: your data will be deleted permanently, but your chats will remain in the chat group.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
