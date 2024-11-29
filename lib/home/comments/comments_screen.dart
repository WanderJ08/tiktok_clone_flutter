import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/comments/comments_controller.dart';

class CommentsScreen extends StatelessWidget {
  final String videoID;

  CommentsScreen({required this.videoID});

  TextEditingController commentTextEditingController = TextEditingController();
  CommentsController commentsController = Get.put(CommentsController());
  @override
  Widget build(BuildContext context) {
    commentsController.updatedCurrentVideoID(videoID);
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            //display comments
            
            //Comments box
            Container(
                color: Colors.white24,
                child: ListTile(
                  title: TextFormField(
                    controller: commentTextEditingController,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Add a comment here",
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        if (commentTextEditingController.text.isNotEmpty) {
                          commentsController.saveNewCommentToDatabase(
                              commentTextEditingController.text);

                          commentTextEditingController.clear();
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 40,
                      )),
                ))
          ],
        ),
      ),
    ));
  }
}
