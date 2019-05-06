import 'package:flutter/material.dart';
import 'package:show_girl_img/entity/Poster.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:show_girl_img/constant/ProjectConstant.dart';
import 'package:device_info/device_info.dart';
import 'package:show_girl_img/ui/TestTimeOut.dart';

class PosterShow extends StatefulWidget {
  final int store;
  final String group;
  List<Poster> posterList = new List<Poster>();
  int testState;

  PosterShow(
      {Key key,
      @required this.store,
      @required this.group,
      this.posterList
      })
      : super(key: key);

  @override
  _PosterShowState createState() {
    return new _PosterShowState();
  }
}

class _PosterShowState extends State<PosterShow> {
  @override
  void initState() {
    super.initState();
    sendDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.posterList == null){
      widget.posterList = List<Poster>();
      var poster = new Poster(
        url: "",
        imgGroup: "-1"
      );
      widget.posterList.add(poster);
    }
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text((widget.store+1).toString() + " / " + widget.posterList.length.toString()),
              backgroundColor: Colors.deepOrange,
            ),
            body: new GestureDetector(

                child: returnContext(),
                onHorizontalDragEnd: (endDetails) {
                  nextPage(context, endDetails);
                },
                onDoubleTap: (){
                  for(int i=0;i<=widget.store;i++){
                    Navigator.pop(context);
                  }
                },
                ),

        )
    );
  }

  void nextPage(context, endDetails) {
    if ((endDetails.velocity.pixelsPerSecond.dx -
            endDetails.velocity.pixelsPerSecond.dy <
        0)) {
      print("左");
      if(widget.testState == 1){
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return new PosterShow(
          group: widget.posterList[0].imgGroup,
          store: widget.store + 1,
          posterList: widget.posterList,
        );
      }));
    } else {
      print("右");
      Navigator.pop(context);
    }
  }

  /**
   * 根据组id查找套图
   */
  Future<List<Poster>> findByGroup(String group) async {

    http.Response response2 = await http
        .get(ProjectConstant.BaseUrl + "/img/findByGroup?group=" + group);
    print(response2);
    List list = JSON.jsonDecode(response2.body);

      List<Poster> posterList = new List<Poster>();
      for (int i = 0; i < list.length; i++) {
        Poster poster = Poster.fromJson(list[i]);
        posterList.add(poster);
      }
    setState(() {
      widget.posterList = posterList;
    });
    return widget.posterList;
  }

  /**
   * 根据状态返回  图片 or 最后一页 or 加载中 or 试用期到了
   */
  Widget returnContext() {

    if (widget != null && widget.posterList != null) {
      if (widget.store >= widget.posterList.length) {
        return Container(
          child: Text(
            "最后一张啦\n"
            "左滑返回上一张\n"
            "双击返回列表页"
            ,
            style: TextStyle(fontSize: 40.0),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
        );
      } else {
        return Container(
          width: 10000,
          height: 10000,
          child: new Image.network(widget.posterList[widget.store].url),
        );

      }
    } else {
      return new CircularProgressIndicator();
    }
  }

  Future<Map<String, Object>> sendDeviceId() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo1 = await deviceInfo.androidInfo;
    var device = androidInfo1.device;
    http.Response response = await http.get(
        ProjectConstant.BaseUrl + "/project/updateDevice?deviceId=" + device);
    Map<String, Object> map = JSON.jsonDecode(response.body);
    int state = 0;
    if (map["state"] == 0) {
      print("体验中");
      state = 0;
    } else if (map["state"] == 1) {
      print("体验结束");
      state = 1;
    } else if (map["state"] == 2) {
      print("已经开通会员");
      state = 2;
    }

    if(state == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return new TestTimeOut(
        );
      }));
    }else{
      findByGroup(widget.group);
    }
    print(deviceInfo);
    return map;
  }
}
