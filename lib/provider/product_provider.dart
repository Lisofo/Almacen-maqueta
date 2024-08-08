import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  String _producto = '';


  String get producto => _producto;


  void setProducto (String product) {
    _producto = product;
    notifyListeners();
  }

  String getProduct(){
    return producto;
  }
}