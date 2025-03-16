import 'package:flutter/material.dart';

import 'new_post_page.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            child: ListTile(
              title: Text(post.title),
              subtitle: Text(post.contentSnippet),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_up),
                  Text(post.upvoteCount.toString()),
                  SizedBox(width: 8),
                  Icon(Icons.comment),
                  Text(post.commentCount.toString()),
                ],
              ),
              onTap: () {
                // TODO: Navigate to PostDetailsPage
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()),
          );
        },
      ),
    );
  }
}

class Post {
  final String title;
  final String contentSnippet;
  final int upvoteCount;
  final int commentCount;

  Post({
    required this.title,
    required this.contentSnippet,
    required this.upvoteCount,
    required this.commentCount,
  });
}

final List<Post> posts = [
  Post(
    title: 'Question about Crop Rotation',
    contentSnippet: 'What are the best practices for crop rotation in this region?',
    upvoteCount: 10,
    commentCount: 5,
  ),
  Post(
    title: 'Best Fertilizer for Tomatoes',
    contentSnippet: 'Looking for recommendations on the best fertilizer for tomatoes.',
    upvoteCount: 15,
    commentCount: 8,
  ),
];
