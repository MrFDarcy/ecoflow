import 'package:flutter/material.dart';

import '../models/post.dart';

import "package:photo_view/photo_view.dart";

class PostDetailsScreen extends StatelessWidget {
  PostDetailsScreen({super.key});

  static const routeName = '/postdetail';

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    return Scaffold(
        appBar: AppBar(
          title: const Text('PostDetailsScreen'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text("Image"),
                            ),
                            body: Container(
                              child: PhotoView(
                                minScale: PhotoViewComputedScale.contained * 1,
                                maxScale: PhotoViewComputedScale.contained * 1,
                                imageProvider: NetworkImage(post.imageUrl),
                              ),
                            ),
                          )));
                },
                child: Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        post.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        post.userProfileImg,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      post.username,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  post.caption,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: Text(
              //     post.description,
              //     style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  post.description != null
                      ? post.description.toString()
                      : "This post has no description",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
            ]),
          ),
        ));
  }
}
