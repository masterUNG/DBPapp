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
  @override
  void initState() {
    super.initState();
    _userAccountModel = widget.userAccountModel;
    print('userLogin = ${_userAccountModel.user}');
    findNameLogin();
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
    return Text('Login by $loginString');
  }

  Widget showAvatar() {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Image.asset('images/avatar.png'),
    );
  }

  Widget showHeadDrawer() {
    return DrawerHeader(
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
