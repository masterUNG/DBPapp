import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/show_detail_material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';

class SearchViewMaterial extends StatefulWidget {
  @override
  _SearchViewMaterialState createState() => _SearchViewMaterialState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SearchViewMaterialState extends State<SearchViewMaterial> {
  // Explicit
  List<EquipmentModel> equipmentModels = [];
  List<EquipmentModel> filterEquipmentModels = List();
  final debouncer = Debouncer(milliseconds: 500);

  // Method
  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    String url = 'https://www.androidthai.in.th/boss/getAllEquipmentMaster.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');
    for (var map in result) {
      EquipmentModel equipmentModel = EquipmentModel.formJSON(map);
      print('name = ${equipmentModel.name}');
      setState(() {
        equipmentModels.add(equipmentModel);
        filterEquipmentModels = equipmentModels;
      });
    }
  }

  Widget searchText() {
    return TextField(
      decoration: InputDecoration(hintText: 'Search'),
      onChanged: (value) {
        debouncer.run(() {
          setState(() {
            filterEquipmentModels = equipmentModels
                .where(
                    (u) => (u.name.toLowerCase().contains(value.toLowerCase())))
                .toList();
          });
        });
      },
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterEquipmentModels.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  showName(index),
                  showTotal(index),
                ],
              ),
            ),
            onTap: () {
              print('You Click ${filterEquipmentModels[index].name}');
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => ShowDetailMaterial(equipmentModel: filterEquipmentModels[index],));
              Navigator.of(context).push(materialPageRoute);
            },
          );
        },
      ),
    );
  }

  Widget showName(int index) {
    return Text(
      filterEquipmentModels[index].name,
      style: TextStyle(
        fontSize: MyStyle().h2,
      ),
    );
  }

  Widget showTotal(int index) {
    return Text(
      filterEquipmentModels[index].total,
      style: TextStyle(fontSize: MyStyle().h1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วัสดุ และ อุปกรณ์ คลังกลาง'),
      ),
      body: Column(
        children: <Widget>[
          searchText(),
          showListView(),
        ],
      ),
    );
  }
}
