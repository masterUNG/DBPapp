import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/search_view_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyMaterial extends StatefulWidget {
  @override
  _MyMaterialState createState() => _MyMaterialState();
}

class _MyMaterialState extends State<MyMaterial> {
  // Explicit
  List<String> iconMaterials = [
    'images/matcenter.png',
    'images/matelect.png',
    'images/mapmachine.png'
  ];

  List<String> iconWarn = [
    'images/worn0.png',
    'images/worn1.png',
    'images/worn2.png'
  ];

  List<String> iconHistory = [
    'images/his0.png',
    'images/his1.png',
    'images/his2.png'
  ];

  int indexMaterial = 0;

  // MethodCall

  Widget cardMenu1() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconMaterials[indexMaterial]),
        ),
        title: Text(
          'วัสดุ และ อุปกรณ์',
          style: TextStyle(
            fontSize: MyStyle().h2,
          ),
        ),
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => SearchViewMaterial());
              Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget cardMenu2() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconWarn[indexMaterial]),
        ),
        title: Text(
          'แจ้งเตือน',
          style: TextStyle(
            fontSize: MyStyle().h2,
          ),
        ),
      ),
    );
  }

  Widget cardMenu3() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconHistory[indexMaterial]),
        ),
        title: Text(
          'ประวัติการทำรายการ',
          style: TextStyle(
            fontSize: MyStyle().h2,
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 50.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          cardMenu1(),
          SizedBox(
            height: 8.0,
          ),
          cardMenu2(),
          SizedBox(
            height: 8.0,
          ),
          cardMenu3(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, MyStyle().mainColor],
          radius: 1.5,
          center: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: <Widget>[
          content(),
        ],
      ),
    );
  }
}
