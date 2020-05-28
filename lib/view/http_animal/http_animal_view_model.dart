import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import './http_animal.dart';
import 'model/animal.dart';

abstract class HttpAnimalViewModel extends State<HttpAnimal> {
  // Add your state and logic here

  Dio dio;
  String baseUrl = "https://hwasampleapi.firebaseio.com/";
  String path = "http.json";

  List<HTTPAnimalModel> httpAnimalList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<void> getHttpAnimalList() async {
    changeLoading();
    final response = await dio.get(path);
    switch (response.statusCode) {
      case HttpStatus.ok:
        final responseBodyList = response.data;
        if (responseBodyList is List) {
          httpAnimalList =
              responseBodyList.map((e) => HTTPAnimalModel.fromJson(e)).toList();
        }
        break;
      default:
    }
    changeLoading();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
