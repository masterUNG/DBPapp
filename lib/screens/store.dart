import 'dart:convert';

import 'package:dbpapp/models/user_account_model.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/home.dart';
import 'package:dbpapp/screens/main_store.dart';
import 'package:dbpapp/screens/my_electric.dart';
import 'package:dbpapp/screens/my_machine.dart';
import 'package:dbpapp/screens/my_material.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> titleAppBars = ['คลังกลาง', 'คลังไฟฟ้า', 'คลังเคลื่องกล'];
  int indexTitleAppBar = 0;
  Widget currentWidget = MyMaterial();

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
        setState(() {
          indexTitleAppBar = 0;
          currentWidget = MyMaterial();
        });
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
        setState(() {
          indexTitleAppBar = 1;
          currentWidget = MyElectric();
        });
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
        setState(() {
          indexTitleAppBar = 2;
          currentWidget = MyMachine();
        });
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

  Widget spcialButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iconChangePassword(),
        iconLogOut(),
      ],
    );
  }

  Widget iconLogOut() {
    return IconButton(tooltip: 'Log Out',
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.white,
        size: 36.0,
      ),
      onPressed: () {processLogOut();},
    );
  }

  Future<void> processLogOut()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context)=>Home());
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route)=>false);

  }

  Widget iconChangePassword() {
    return IconButton(tooltip: 'Change Password',
      icon: Icon(
        Icons.lock,
        color: Colors.white,
        size: 36.0,
      ),
      onPressed: () {},
    );
  }

  Widget showLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Login by $loginString',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        spcialButton(),
      ],
    );
  }

  Widget showAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 80.0,
          height: 80.0,
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
          // menuPasswordStore(),
          // Divider(),
          // menuLogOutStore(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().textColor,
        title: Text(titleAppBars[indexTitleAppBar]),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
