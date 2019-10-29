import 'dart:convert';

import 'package:dbpapp/models/user_account_model.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Store extends StatefulWidget {
  final UserAccountModel userAccountModel;
  Store({Key key, this.userAccountModel}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  // Explicit
  UserAccountModel _userAccountModel;
  String loginString = '';
  UserModel userModel;

  // Method
  void closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _userAccountModel = widget.userAccountModel;
    print('userLogin = ${_userAccountModel.user}');
    findNameLogin();
  }

  Widget menuCenterStore() {
    return ListTile(
      leading: Icon(
        Icons.extension,
        size: 36.0,
        color: Colors.blue[600],
      ),
      title: Text('คลังกลาง'),
      subtitle: Text('คำอธิบาย คลังกลาง ว่าคือ อะไร ?'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuElectricStore() {
    return ListTile(
      leading: Icon(
        Icons.flash_on,
        size: 36.0,
        color: Colors.red[600],
      ),
      title: Text('คลังไฟฟ้า'),
      subtitle: Text('คำอธิบาย คลังไฟฟ้า ว่าคือ อะไร ?'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuMachineStore() {
    return ListTile(
      leading: Icon(
        Icons.settings,
        size: 36.0,
        color: Colors.purple[600],
      ),
      title: Text('คลังเคลื่องกล'),
      subtitle: Text('คำอธิบาย คลังเคลื่องกล ว่าคือ อะไร ?'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuPasswordStore() {
    return ListTile(
      leading: Icon(
        Icons.lock,
        size: 36.0,
        color: Colors.green[600],
      ),
      title: Text('เปลี่ยน รหัส'),
      subtitle: Text('คำอธิบาย เปลี่ยน รหัส ว่าคือ อะไร ?'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuLogOutStore() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.deepOrange[600],
      ),
      title: Text('Log Out'),
      subtitle: Text('คำอธิบาย Log Out ว่าคือ อะไร ?'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Future<void> findNameLogin() async {
    String url = '${MyStyle().urlGetNameWhereUser}${_userAccountModel.user}';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');
    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJSON(map);
        loginString = userModel.name;
        print('loginString = $loginString');
      });
    }
  }

  Widget showLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Login by $loginString',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget showAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          child: Image.asset('images/avatar.png'),
        ),
      ],
    );
  }

  Widget showHeadDrawer() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          showAvatar(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHeadDrawer(),
          menuCenterStore(),
          Divider(),
          menuElectricStore(),
          Divider(),
          menuMachineStore(),
          Divider(),
          menuPasswordStore(),
          Divider(),
          menuLogOutStore(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      body: Text('body'),
      drawer: showDrawer(),
    );
  }
}
