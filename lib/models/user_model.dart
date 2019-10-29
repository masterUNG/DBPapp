class UserModel {
  String employeeId, name, department, section, division, email, phone;

  UserModel(this.employeeId, this.name, this.department, this.section,
      this.division, this.email, this.phone);

  UserModel.fromJSON(Map<String, dynamic> map){
    employeeId = map['employee_id'];
    name = map['name'];
    department = map['devartment'];
    section = map['section'];
    division = map['division'];
    email = map['email'];
    phone = map['phone'];
  }

}
