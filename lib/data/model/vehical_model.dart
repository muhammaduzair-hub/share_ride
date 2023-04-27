class VehicleModel {
  final int vid;
  final String vName;
  final String vPic;
  final String vRate;
  final String vArrivingTime;

  VehicleModel(
      {required this.vName,
      required this.vid,
      required this.vPic,
      required this.vRate,
      required this.vArrivingTime});

// VehicleModel.fromJson(Map<String, dynamic> json) {
//   postId = json['postId'];
//   id = json['id'];
//   name = json['name'];
//   email = json['email'];
//   body = json['body'];
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['postId'] = this.postId;
//   data['id'] = this.id;
//   data['name'] = this.name;
//   data['email'] = this.email;
//   data['body'] = this.body;
//   return data;
// }
}
