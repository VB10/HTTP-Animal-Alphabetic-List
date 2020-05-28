import 'package:alphabeticlist/core/base/base_model.dart';

class HTTPAnimalModel extends BaseModel<HTTPAnimalModel> {
  String description;
  String imageUrl;
  int statusCode;

  HTTPAnimalModel({this.description, this.imageUrl, this.statusCode});

  HTTPAnimalModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    imageUrl = json['imageUrl'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['statusCode'] = this.statusCode;
    return data;
  }

  @override
  HTTPAnimalModel fromJson(Map<String, Object> json) {
    return HTTPAnimalModel.fromJson(json);
  }
}
