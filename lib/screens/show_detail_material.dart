import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_account_model.dart';
import 'package:dbpapp/screens/my_dialog.dart';
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
  String userString, levelString = '', numberString, nameString;
  final formKey = GlobalKey<FormState>();

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
        onPressed: () {
          showAlert(0);
        },
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
        onPressed: () {
          showAlert(1);
        },
      ),
    );
  }

  Widget showTitle(int index) {
    List<IconData> titleIcons = [Icons.add, Icons.remove];
    List<String> titles = ['กระบวนการเพิ่ม', 'กระบวนการลด'];

    return ListTile(
      leading: Icon(
        titleIcons[index],
        size: 36.0,
      ),
      title: Text(
        titles[index],
        style: TextStyle(
          fontSize: MyStyle().h2,
        ),
      ),
    );
  }

  Widget showContent(int index) {
    List<String> labels = ['ใส่จำนวนที่ต้องการเพิ่ม', 'ใส่จำนวนที่ต้องการลด'];

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: labels[index],
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่จำนวนด้วยคะ';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              numberString = value.trim();
            },
          ),
          SizedBox(
            height: 4.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ชื่อผู้ทำรายการ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ชื่อทำรายการด้วยคะ';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              nameString = value.trim();
            },
          )
        ],
      ),
    );
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton(int index) {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('number = $numberString, name = $nameString, index = $index');
          if (index == 0) {
            increaseProcess();
            Navigator.of(context).pop();
          } else {
            decreaseProcess();
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  Future<void> increaseProcess()async{
    String ideq = myEquipmentModel.idEq;
    String totalString = myEquipmentModel.total;
    int totalAInt = int.parse(totalString);
    int numberAInt = int.parse(numberString);
    totalAInt = totalAInt + numberAInt;

    String url = 'https://www.androidthai.in.th/boss/editEquipmentWhereIdMaster.php?isAdd=true&id_eq=$ideq&total=$totalAInt';  

    Response response = await get(url);
    var result = json.decode(response.body);
    if (result.toString() == 'true') {
      print('Equipment Success');
      insertReport('0', totalAInt);
      // var currentTime = DateTime.now();
      // print('currentTime = $currentTime');

    } else {
      normalAlert(context, 'Have Error', 'Please Try Again');
    }

  }

  Future<void> insertReport(String process, int totalAInt)async{

    String key = myEquipmentModel.key;
    String group = myEquipmentModel.group;
    String type = myEquipmentModel.type;
    String unit = myEquipmentModel.unit;
    String total = '${myEquipmentModel.total} -> $totalAInt';
    String myProcess = process;

    String url = 'https://www.androidthai.in.th/boss/addReportMaster.php?isAdd=true&key_re=$key&user_re=$nameString&group_re=$group&type_re=$type&unit_re=$unit&total_re=$total&process_re=$myProcess';

    Response response = await get(url);
    var result = json.decode(response.body);
    if (result.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalAlert(context, 'Error', 'Please Try again');
    }

  }

  Future<void> decreaseProcess()async{}

  

  

  void showAlert(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            title: showTitle(index),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showContent(index),
            ),
            actions: <Widget>[
              okButton(index),
              cancelButton(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
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
          ),
          levelString == '1' ? showButton() : SizedBox(),
        ],
      ),
    );
  }
}
