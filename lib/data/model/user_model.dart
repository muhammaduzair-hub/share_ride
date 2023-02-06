class UserModel {
  late String id;
  String? name;
  String? email;
  String? phoneno;
  String? address;
  String? type;
  String? password;
  String? imgUrl ;
  bool? isDriver ;
  int? age;
  int? cnic;
  bool? isVehicalAdded;
  String? vehicalName;
  String? vehicalModel;
  String? vehicalNo;
  String? vehicalImgUrl;

  UserModel(
      {required this.id,
        this.name,
        this.email,
        this.phoneno,
        this.address,
        this.type,
        this.password,
        this.imgUrl,
        this.isDriver,
        this.age,
        this.cnic,
        this.isVehicalAdded,
        this.vehicalModel,
        this.vehicalName,
        this.vehicalNo,this.vehicalImgUrl
      });

  UserModel.initial()
      : id = '0',
        name = '',
        email = '',
        phoneno = '123456',
        address = '',
        type = '',
        password ='',
        imgUrl = '',
        isVehicalAdded = false,
        vehicalName = '',
        vehicalModel = '',
        vehicalNo = '',
        isDriver = false,
        vehicalImgUrl ="";



  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
    type = json['type'];
    password = json['password'];
    imgUrl = json['imgUrl'];
    isDriver = json["isDriver"];
    cnic = json["cnic"];
    age = json["age"];
    isVehicalAdded = json['isVehicalAdded'];
    vehicalNo = json["vehicalNo"];
    vehicalName = json["vehicalName"];
    vehicalModel = json["vehicalModel"];
    vehicalImgUrl = json["vehicalImgUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.email;
    data['phoneno'] = this.phoneno;
    data['address'] = this.address;
    data['type'] = this.type;
    data['password'] = this.password;
    data['imgUrl']= imgUrl ;
    data["isDriver"]= isDriver ;
    data["cnic"]= cnic ;
    data["age"] =age ;
    data['isVehicalAdded']=isVehicalAdded;
    data["vehicalNo"]= vehicalNo;
    data["vehicalName"]= vehicalName ;
    data["vehicalModel"]=vehicalModel ;
    data["vehicalImgUrl"]= vehicalImgUrl;
    return data;
  }

  String get getId => id.toString();

}