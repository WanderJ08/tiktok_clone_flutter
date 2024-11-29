import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  final String videoID;

  CommentsScreen({required this.videoID});

  @override
  Widget build(BuildContext context) {
    TextEditingController commentTextEditingController =
        TextEditingController();
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
                      onPressed: () {},
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
