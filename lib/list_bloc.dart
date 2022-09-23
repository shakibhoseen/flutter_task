
import 'dart:async';

import 'package:flutter_task/product_item.dart';

class ListBloc{
  List<ProductItem> productList =[];
  StreamController<List<ProductItem>> valueController = StreamController<List<ProductItem>>();

  void add(List<ProductItem> items){
    productList.addAll(items);
    valueController.sink.add(productList);
  }

  void removeAdd(List<ProductItem> items){
    productList.clear();
    productList.addAll(items);
    valueController.sink.add(productList);
  }

  Stream<List<ProductItem>> getAllItems(){
    return valueController.stream;
  }

  void pressedHandle(ProductItem item, int valuePress){
    int size = productList.length;
    for(int i=0; i<size; i++){
      if(productList[i] == item){
        productList[i].perssValue = valuePress;
        break;
      }
    }
    valueController.sink.add(productList);
  }

  void dispose(){
    valueController.close();
  }

}