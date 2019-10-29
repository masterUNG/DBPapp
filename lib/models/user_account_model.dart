class UserAccountModel {

  // Field
  String idAcc, user, pass, level;



  // Constructor
  UserAccountModel(this.idAcc, this.user, this.pass, this.level);

  UserAccountModel.fromJSON(Map<String, dynamic> map){
    idAcc = map['id_acc'];
    user = map['user'];
    pass = map['pass'];
    level = map['level'];
  }


  
}