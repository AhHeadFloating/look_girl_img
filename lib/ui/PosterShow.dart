import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:show_girl_img/entity/Poster.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class PosterShow extends StatelessWidget {
  final int store;
  final String group;
  List<Poster> posterList = null;

  PosterShow(
      {Key key, @required this.store, @required this.group, this.posterList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = ScreenUtil.getInstance();

    // TODO 这里如果拆分的话，应该先把判断显示图片还是显示最后一页的方法拆分出去
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("test"),
            backgroundColor: Colors.deepOrange,
          ),
          body: new GestureDetector(
              child: new FutureBuilder(
                  future: findByGroup(this.group),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (this.store >= posterList.length) {
                        return Container(
                          width: screen.width / 1,
                          height: screen.height + 0.0,
                          child: Text(
                            "最后一张啦\n点击返回上一张",
                            style: TextStyle(fontSize: 40.0),
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                        );
                      }
                      return new Image.network(posterList[store].url);
                    } else {
                      return new CircularProgressIndicator();
                    }
                  }),
              onHorizontalDragEnd: (endDetails) {
                nextPage(context,endDetails);
              })),
    );
  }

  /**
   * 查找所有的套图的开头一张图片
   */
  Future<List<Poster>> findByGroup(String group) async {
    http.Response response = await http
        .get("http://192.168.43.130:8080/img/findByGroup?group=" + group);
    print(response);
    List list = JSON.jsonDecode(response.body);
    this.posterList = new List<Poster>();
    for (int i = 0; i < list.length; i++) {
      Poster poster = Poster.fromJson(list[i]);
      posterList.add(poster);
    }
    return posterList;
  }

  /**
   * 往左滑下一页
   * 往右划上一页
   */
  void nextPage(context, endDetails) {
    if ((endDetails.velocity.pixelsPerSecond.dx -
            endDetails.velocity.pixelsPerSecond.dy <
        0)) {
      print("左");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return new PosterShow(
            group: this.posterList[0].imgGroup,
            store: this.store + 1,
            posterList: this.posterList);
      }));
    } else {
      print("右");
      Navigator.pop(context);
    }
  }
}
