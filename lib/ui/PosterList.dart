import 'package:flutter/material.dart';
import 'package:show_girl_img/entity/Poster.dart';
import 'package:show_girl_img/ui/PosterShow.dart';

class PosterList extends StatelessWidget {

  final List<Poster> items;

  PosterList({Key key, @required this.items /*,@required this.group*/
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          // mainAxisSpacing: 10.0,//Y
          crossAxisSpacing: 7.0, //X
          childAspectRatio: 0.7),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return new GestureDetector(
          child: Image.network(items[index].url),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new PosterShow(
                group: this.items[index].imgGroup,
                store: 0,
              );
            }));
          },
        );
      },
    );
  }
}