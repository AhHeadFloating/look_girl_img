import 'package:flutter/material.dart';
import 'package:show_girl_img/entity/Poster.dart';

class SimpleList extends StatefulWidget{

  List<Poster> items;

  SimpleList({Key key,@required this.items}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return new _SimpleListState();
  }

}

class _SimpleListState extends State<SimpleList>{
  
  @override
  Widget build(BuildContext context) {
    if(widget.items == null){
      widget.items = new List<Poster>();
    }
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context,index){
          return Image.network(widget.items[index].url);
        }
    );
  }
  
}