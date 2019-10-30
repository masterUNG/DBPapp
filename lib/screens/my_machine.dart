import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';

class MyMachine extends StatefulWidget {
  @override
  _MyMachineState createState() => _MyMachineState();
}

class _MyMachineState extends State<MyMachine> {
  
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

  int indexMaterial = 2;


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
          colors: [Colors.white, Colors.green.shade600],
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