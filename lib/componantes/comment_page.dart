import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  final String commentText;
  final String commentBy;
  final String time;
  const CommentPage(
      {super.key,
      required this.commentText,
      required this.commentBy,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(
            commentText,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          //  row comment by + time
          Row(
            children: [
              // user
              Text(
                commentBy,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(
                width: 10.0,
              ),
              // time
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
