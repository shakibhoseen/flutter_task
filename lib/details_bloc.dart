
import 'dart:async';

import 'package:flutter_task/product_item.dart';

class DetailsBloc{
  ProductItem productItem ;
  StreamController<ProductItem> valueController = StreamController<ProductItem>();


  DetailsBloc(this.productItem);

  void add(ProductItem item){
    productItem = item;
    valueController.sink.add(productItem);
  }



  Stream<ProductItem> getAllItems(){
    return valueController.stream;
  }



  void dispose(){
    valueController.close();
  }

}