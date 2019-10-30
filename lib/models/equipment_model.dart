class EquipmentModel {
  String idEq, key, name, type, group, unit, imageId, limit, total;

  EquipmentModel(this.idEq, this.key, this.name, this.type, this.group,
      this.unit, this.imageId, this.limit, this.total);

  EquipmentModel.formJSON(Map<String, dynamic> map) {
    idEq = map['id_eq'];
    key = map['key'];
    name = map['name'];
    type = map['type'];
    group = map['group'];
    unit = map['unit'];
    imageId = map['image_id'];
    limit = map['limit'];
    total = map['total'];
  }
}
