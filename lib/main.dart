import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  List<Poster> posterList = new List<Poster>.generate(20, (i)=>new Poster("title:$i","url$i"));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: new PosterList(
          items:posterList
        ),
        // body:new PosterShow(
        //   store: 1,
        // )
      )
    );
  }
}

class PosterList extends StatelessWidget{

  final List<Poster> items;
  PosterList({Key key,@required this.items}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            // mainAxisSpacing: 10.0,//Y
            crossAxisSpacing: 10.0,//X
            childAspectRatio: 0.7
          
          ),
          itemCount: 50,
          itemBuilder: (context,index){
            return new GestureDetector(
              child: Image.network("https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3200334446,1487314372&fm=27&gp=0.jpg"),
              onTap: (){
               Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return new PosterShow(
                    store: 1,
                    url:"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=344662154,2265901569&fm=27&gp=0.jpg"
                  );
                }
               ));
              },
            );
          },
          
    );
  }
}


class PosterShow extends StatelessWidget{
  final int store;
  final String url;
  PosterShow({Key key,@required this.store,@required this.url}):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: new GestureDetector(
          child: new Image.network(url),
          onHorizontalDragEnd: (endDetails) async {
            if((endDetails.velocity.pixelsPerSecond.dx - endDetails.velocity.pixelsPerSecond.dy < 0)){
              http.Response response = await http.get(url);
              print(response.body);
              print("左");
              Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return new PosterShow(
                    store: 1,
                    url:"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=4075680052,587526839&fm=27&gp=0.jpg"
                  );
                }
            ));
            }else{
              print("右");
               Navigator.pop(context);
            }
      }
        )
        
      ),
    );
  }
}

class Poster{
  String title;
  String url;
  
  Poster(this.title,this.url);
}