import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:ecoflow_v3/models/user.dart" as MyAppUser;

import '../models/post.dart';
import '../services/authentication_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget loginDialogue(context) {
    return AlertDialog(
      title: const Text('Login'),
      content: const Text('Please login to continue'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop();
            AuthService.signOut();
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget postCard(post, user) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: double.infinity,
        height: 500,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              post.imageUrl ?? '',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.userPhoto ?? '',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  post.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),

        // show current user icon if user is logged in else show anonymous icon
        actions: [
          if (AuthService().user != null)
            IconButton(
                onPressed: () {},
                icon: AuthService().user!.photoURL != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          AuthService().user!.photoURL!,
                        ),
                      )
                    : const Icon(Icons.person_outline))
          else
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outline),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // check if AuthService().user is not null and isAnonymous is true
          if (AuthService().user != null &&
              AuthService().user!.isAnonymous == true) {
            // show a dialog to ask user to login
            showDialog(
              context: context,
              builder: (context) {
                return loginDialogue(context);
              },
            );
          }

          // if user is logged in with google, navigate to post upload screen
          else {
            Navigator.of(context).pushNamed('/postupload');
          }
        },
        child: const Icon(Icons.add_a_photo),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = Post.fromMap(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>,
                        // id
                        snapshot.data!.docs[index].id,
                      );

                      return GestureDetector(
                        onTap: () async {
                          final userSnapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(post.userId)
                              .get();
                          final user = MyAppUser.User.fromMap(
                              userSnapshot.data() as Map<String, dynamic>,
                              userSnapshot.id);
                          Navigator.of(context).pushNamed(
                            '/postdetail',
                            arguments: {
                              'post': post,
                              'user': user,
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(post.userId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData &&
                                  snapshot.data != null) {
                                final userData = snapshot.data!.data();
                                final user = MyAppUser.User.fromMap(
                                  userData ?? const {},
                                  snapshot.data!.id,
                                );

                                return postCard(post, user);
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                        height: 500,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        )));
                              } else {
                                return const Text('Error');
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text('Error');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
