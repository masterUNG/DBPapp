import 'dart:convert';
import 'package:dbpapp/models/equipment_model.dart';
import 'package:http/http.dart' as http;


class Services {
  static const String url = 'https://www.androidthai.in.th/boss/getAllEquipmentMaster.php';

  static Future<List<EquipmentModel>> getEquipmentModel() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<EquipmentModel> list = parseEquipmentModel(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<EquipmentModel> parseEquipmentModel(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EquipmentModel>((json) => EquipmentModel.formJSON(json)).toList();
  }
}