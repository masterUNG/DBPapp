import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_account_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowDetailMaterial extends StatefulWidget {
  final EquipmentModel equipmentModel;
  ShowDetailMaterial({Key key, this.equipmentModel}) : super(key: key);
  @override
  _ShowDetailMaterialState createState() => _ShowDetailMaterialState();
}

class _ShowDetailMaterialState extends State<ShowDetailMaterial> {
  // Explicit
  EquipmentModel myEquipmentModel;
  String userString, levelString = '';

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
      myEquipmentModel = widget.equipmentModel;
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print('userString = $userString');
    findLevel();
  }

  Future findLevel() async {
    String url = '${MyStyle().urlGetUserWhereUser}$userString';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');
    for (var map in result) {
      UserAccountModel userAccountModel = UserAccountModel.fromJSON(map);
      setState(() {
        levelString = userAccountModel.level;
      });
    }
  }

  Widget showName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('ชื่อ : ${myEquipmentModel.name}'),
      ],
    );
  }

  Widget contentRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        myGroup(),
        myType(),
      ],
    );
  }

  Widget myGroup() {
    return Text('กลุ่ม : ${myEquipmentModel.group}');
  }

  Widget myType() {
    return Text('ประเภท : ${myEquipmentModel.type}');
  }

  Widget showTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'จำนวนคงเหลือ : ${myEquipmentModel.total} ${myEquipmentModel.unit}',
          style: TextStyle(
            fontSize: MyStyle().h2,
          ),
        ),
      ],
    );
  }

  Widget showButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            increaseButton(),
            decreaseButton(),
          ],
        ),
      ],
    );
  }

  Widget increaseButton() {
    return Expanded(
      child: RaisedButton.icon(
        color: Colors.green.shade800,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'เพิ่ม',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget decreaseButton() {
    return Expanded(
      child: RaisedButton.icon(
        color: Colors.red.shade800,
        icon: Icon(
          Icons.remove,
          color: Colors.white,
        ),
        label: Text(
          'ลด',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงรายละเอียด คลังกลาง'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                contentRow1(),
                Divider(),
                showName(),
                Divider(),
                showTotal(),
              ],
            ),
          ), levelString == '1' ? showButton(): SizedBox(),
        ],
      ),
    );
  }
}
