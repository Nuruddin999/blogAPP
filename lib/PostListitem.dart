import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'Post.dart';
import 'PostUpdate.dart';
import 'RoutingPage.dart';
import 'ShowHideText.dart';
import 'api/blogservice.dart';

class PostListItem extends StatefulWidget {
  var context;

  PostListItem({this.posts, this.index});

  int index;
  List<Post> posts;

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  Image like = Image.asset("assets/heart.png");
  bool likepressed = false;
  Color color = Colors.green;
  void _deletePost(Post post) async {
    if (await blogservice().deleteData(post.id)) {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return RoutingPage(auth: new Auth(),);
      }));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  widget.posts[widget.index].accaunt,
                  style: TextStyle(fontSize: 13),
                )),
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Delete"),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PostUpdate(
                              post: widget.posts[widget.index],
                            );
                          }));
                        }
                        break;
                      case 2:
                        {
                            _deletePost(widget.posts[widget.index]);
                        }
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
          Image.network(
            widget.posts[widget.index].image,
            fit: BoxFit.cover,
            height: 350,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: likepressed
                      ? Image.asset(
                          "assets/redheart.png",
                          height: 35,
                          width: 25,
                        )
                      : Image.asset(
                          "assets/heart.png",
                          height: 35,
                          width: 25,
                        ),
                  onPressed: () {
                    setState(() {
                      likepressed
                          ? widget.posts[widget.index].like--
                          : widget.posts[widget.index].like++;
                      blogservice().updateData(widget.posts[widget.index].id, widget.posts[widget.index]);
                      likepressed = !likepressed;

                    });
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Text("${widget.posts[widget.index].like} likes"),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: "${widget.posts[widget.index].accaunt} ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ])),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
                  DescriptionTextWidget(text: widget.posts[widget.index].body))
        ],
      ),
    );
  }
}
