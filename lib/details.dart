import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_task/details_bloc.dart';

import 'package:flutter_task/product_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexagon/hexagon.dart';
import 'package:http/http.dart' as http;

late String routeSlug1;
class Details extends StatefulWidget {



  Details({required routeSlug}){
    routeSlug1 = routeSlug;
  }

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  StreamController<int> valueController = StreamController<int>();
  DetailsBloc detailsBloc = DetailsBloc(ProductItem("", "", "", "", "", "", 0, "", "", "", ""));
  int valuePress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueController.sink.add(0);
    hitApi("https://panel.supplyline.network/api/product-details/$routeSlug1");

  }

  void increment() {
    valuePress++;
    valueController.sink.add(valuePress);

  }

  void decrement() {
    valuePress--;
    valueController.sink.add(valuePress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        title: Text(
          "প্রোডাক্ট ডিটেইল",
          style: TextStyle(
            color: Color(0xff323232),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'BalooDa',
          ),
        ),
        backgroundColor: Color(0xffF7F2FF),
        iconTheme: IconThemeData(
          color: Color(0xff323232),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 25,
            ),
           /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "প্রোডাক্ট ডিটেইল",
                    style: TextStyle(
                      color: Color(0xff323232),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: 'BalooDa',
                    ),
                  )
                ],
              ),
            ),*/
            design(),
          ],
        ),
      ),
    );
  }

  Widget design() {

    return StreamBuilder<ProductItem>(
      stream: detailsBloc.getAllItems(),
      initialData: ProductItem("", "", "", "", "", "", 0, "", "", "", ""),
      builder: (context, snapshot) {
        ProductItem? productItem = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 60,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Flexible(
                            child: SizedBox(
                              height: 28,
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          fontFamily: 'BalooDa', fontSize: 13),
                                      hintText: 'কাঙ্ক্ষিত পণ্যটি খুঁজুন'),
                                ),
                              ),
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/search3.png'),
                            height: 24,
                            width: 24,
                            color: Color(0xffA7A7A7),
                          )
                        ],
                      ),
                    ),
                  ),
                  elevation: 1,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // image holder 3 item
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: 50,
                    height: 270,
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: 240,
                    height: 300,
                    child: Center(
                      child: productItem!.imgUrl.isEmpty? Text("loading") : Image.network(
                        productItem.imgUrl ,
                        height: 200,
                        width: 154,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: 50,
                    height: 270,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 32,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: title(productItem),
            ),
          ],
        );
      }
    );
  }

  Widget title(ProductItem data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         Text(data.product,
            style: const TextStyle(
                color: Color(0xff19181B),
                fontSize: 24,
                fontFamily: 'BalooDa',
                fontWeight: FontWeight.w600)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text("ব্রান্ডঃ ",
                  style: TextStyle(
                      color: Color(0xff646464),
                      fontSize: 14,
                      fontFamily: 'BalooDa',
                      fontWeight: FontWeight.w500)),
              Text( data.brandName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'BalooDa',
                      fontWeight: FontWeight.w500)),
              const Card(
                color: Color(0xffDA2079),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SizedBox(
                  height: 6,
                  width: 6,
                ),
              ),
              const Text("ডিস্ট্রিবিউটরঃ ",
                  style: TextStyle(
                      color: Color(0xff646464),
                      fontSize: 14,
                      fontFamily: 'BalooDa',
                      fontWeight: FontWeight.w500)),
              Text(data.seller,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'BalooDa',
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<int>(
            stream: valueController.stream,
            initialData: 0,
            builder: (context, snapshot) {
              return Stack(
                alignment: Alignment.bottomCenter,
                overflow: Overflow.visible,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Text("ক্রয়মূল্যঃ",
                                      style: TextStyle(
                                          color: Color(0xffDA2079),
                                          fontSize: 20,
                                          fontFamily: 'BalooDa',
                                          fontWeight: FontWeight.w600)),
                                  Text(data.kroy,
                                      style: const TextStyle(
                                          color: Color(0xffDA2079),
                                          fontSize: 20,
                                          fontFamily: 'BalooDa',
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Text("বিক্রয়মূল্যঃ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'BalooDa',
                                          fontWeight: FontWeight.w500)),
                                  Text(data.bikroy,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppin',
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            const DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashColor: Color(0xffA0A0A0),
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Text("লাভঃ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'BalooDa',
                                          fontWeight: FontWeight.w500)),
                                  Text(data.lav,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppin',
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("বিস্তারিত",
                          style: TextStyle(
                              color: Color(0xff323232),
                              fontSize: 20,
                              fontFamily: 'BalooDa',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              GestureDetector(
                                child: HexagonWidget.pointy(
                                  width: 90,
                                  color: Colors.red,
                                  cornerRadius: 20,
                                  elevation: 8,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                          Color(0xff6210E1),
                                          Color(0xff1400AE)
                                        ])),
                                    child: Center(
                                      child: snapshot.data! <= 0
                                          ? const Text(
                                              "এটি কিনুন",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'BalooDa'),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Image(
                                                  image: AssetImage(
                                                      "assets/cart_shop.png"),
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                Text(
                                                  "কার্ট",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily: 'BalooDa'),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  if(snapshot.data!<=0) {
                                    increment();
                                  }
                                },
                              ),
                              Visibility(
                                visible: snapshot.data!>0,
                                child: Positioned(
                                    right: 4,
                                    top: 14,
                                    child: Card(
                                      color: Color(0xffFFCCE4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child:  SizedBox(
                                        width: 26,
                                        child: Text(
                                          "${snapshot.data}",
                                          style: const TextStyle(
                                            color: Color(0xffDA2079),
                                            fontFamily: 'BalooDa',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: snapshot.data! > 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffFFBFDD),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  SizedBox.fromSize(
                                    child: FloatingActionButton(
                                      onPressed: () {
                                         decrement();
                                      },
                                      tooltip: '-',
                                      child: const Text("-", style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Poppin'),),
                                      backgroundColor: Color(0xffFFBFDD),
                                    ),
                                    size: const Size.square(30),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${snapshot.data} পিস",
                                    style: const TextStyle(
                                      color: Color(0xffDA2079),
                                      fontSize: 14,
                                      fontFamily: 'Poppin'
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox.fromSize(
                                    child: FloatingActionButton(
                                      backgroundColor: Color(0xff1400AE),
                                      onPressed: () {
                                        increment();
                                      },
                                      tooltip: '-',
                                      child: const Icon(Icons.add),
                                    ),
                                    size: Size.square(30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
        Html(
          data:
              data.description
        ),
      ],
    );
  }



  Future hitApi(String url) async {
    log("hit call");

    var response = await http.get(Uri.parse(url));
    /* setState(() {
        data = json.decode(response.body); // json array
        print(data);
      });*/

    //var obj = json.decode(response.body);
    var obj = json.decode(utf8.decode(response.bodyBytes));
    var data = obj["data"];

    var brandName = data["brand"]["name"];


      var image = data["image"];
      var product_name = data["product_name"];
      var description = data["description"];
      var stock = data["stock"];
      var seller = data["seller"];

      var charge = data["charge"];
      var current_charge = charge["current_charge"];
      var selling_price = charge["selling_price"];
      var profit = charge["profit"];


      var productItem = ProductItem(product_name, image, "৳ $current_charge",
          "৳ $selling_price", "৳ $profit", "৳ 0", stock, description, seller, brandName, "" );



      log("hit $data");
      log("hit $image");

      detailsBloc.add(productItem);

  }



}


