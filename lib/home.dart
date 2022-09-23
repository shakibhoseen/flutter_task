import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_task/details.dart';
import 'package:flutter_task/list_bloc.dart';
import 'package:flutter_task/product_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ListBloc listBloc;
  bool isSendShow = false;
  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  var nextPage = "f";
  StreamController<bool> activeSendController = StreamController<bool>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    activeSendController.sink.add(isSendShow);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (!nextPage.isEmpty) {
          hitApi(nextPage, false);
        } else {
          print("empty list");
        }
      }
    });

    textEditingController.addListener(() {
        if(textEditingController.text.isNotEmpty) {
          isSendShow = true;

        }else{
          isSendShow = false;
        }
        activeSendController.sink.add(isSendShow);
    });

    listBloc = ListBloc();
    hitApi("https://panel.supplyline.network/api/product/search-suggestions/",
        false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 50,
            ),
           /* Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration.collapsed(
                                hintText: 'কাঙ্ক্ষিত পণ্যটি খুঁজুন'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            hitApi(
                                "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=${textEditingController.text}",
                                true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              elevation: 1,
            ),*/

            StreamBuilder<bool>(
              stream: activeSendController.stream,
              initialData: false,
              builder: (context, snapshot) {


                return Padding(
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
                            children:  [
                              Flexible(
                                child: SizedBox(
                                  height: 28,
                                  child: Center(
                                    child: TextField(
                                      controller: textEditingController,
                                      decoration: const InputDecoration.collapsed(
                                          hintStyle: TextStyle(
                                              fontFamily: 'BalooDa', fontSize: 13),
                                          hintText: 'কাঙ্ক্ষিত পণ্যটি খুঁজুন'),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  hitApi(
                                      "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=${textEditingController.text}",
                                      true);
                                },
                                child: Image(
                                  image: snapshot.data==false  ? const AssetImage('assets/search3.png'): const AssetImage('assets/send.png'),
                                  height: 24,
                                  width: 24,
                                  color: Color(0xffA7A7A7),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      elevation: 1,
                    ),
                  ),
                );
              }
            ),

            const SizedBox(
              height: 10,
            ),
            Expanded(child: layout(context))
          ],
        ),
      ),
    );
  }

  Widget layout(BuildContext context) {
    return StreamBuilder<List<ProductItem>>(
        stream: listBloc.getAllItems(),
        initialData: [],
        builder: (context, snapshot) {
          List<ProductItem>? productList = snapshot.data;
          return MasonryGridView.builder(
              controller: scrollController,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
              itemCount: productList != null ? productList.length + 1 : 1,
              itemBuilder: (context, index) {
                if (productList != null) {
                  if (index < productList.length) {
                    return GestureDetector(
                      onTap: (){

                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Details(routeSlug: productList[index].slug)));

                      } ,
                      child: item(
                          productList[index].product,
                          productList[index].imgUrl,
                          productList[index].kroy,
                          productList[index].bikroy,
                          productList[index].lav,
                          productList[index].oldLav,
                          productList[index].perssValue,
                          productList[index],
                          productList[index].stock),
                    );
                  } else {
                    return Center(
                        child: nextPage.isEmpty
                            ? const SizedBox(
                                height: 250,
                                child: Center(
                                  child: Text(
                                    "No more Data",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : CircularProgressIndicator());
                  }
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                        child: /*nextPage.isEmpty
                            ? Text("No More Data")
                            :*/ CircularProgressIndicator()),
                  );
                }

                print("stream builder call $index");
              });
        });
  }

  Widget item(String product, String imgUrl, String kroy, String bikroy,
      String lav, String oldLav, int pressValue, ProductItem item, int stock) {
    StreamController<int> valueController = StreamController<int>();
    valueController.sink.add(pressValue);
    int valuePress = pressValue;

    void increment() {
      log("stock $stock");
      if (stock <= valuePress) {
        Fluttertoast.showToast(
            msg: "Stock have only $valuePress items",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff1400AE),
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      valuePress++;
      valueController.sink.add(valuePress);
      listBloc.pressedHandle(item, valuePress);
    }

    void decrement() {
      valuePress--;
      valueController.sink.add(valuePress);
      item.perssValue = valuePress;
    }

    return Stack(
        alignment: Alignment.bottomCenter,
        overflow: Overflow.visible,
        children: [
          Column(
            children: [
              Card(
                color: const Color(0xffFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Visibility(
                            child: stock > 0
                                ? const SizedBox(
                                    height: 24,
                                  )
                                : SizedBox(
                                    height: 24,
                                    child: Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xffFFCCE4),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 9),
                                          child: Text(
                                            "স্টকে নেই",
                                            style: TextStyle(
                                              color: Color(0xffC62828),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                          ),
                          Image.network(
                            imgUrl,
                            height: 120,
                            width: 90,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 34,
                            child: Text(
                              product,
                              style: const TextStyle(
                                color: Color(0xff323232),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "ক্রয়",
                                    style: TextStyle(
                                      color: Color(0xff646464),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    kroy,
                                    style: const TextStyle(
                                      color: Color(0xffDA2079),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                oldLav,
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Color(0xffDA2079),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "বিক্রয়",
                                    style: TextStyle(
                                      color: Color(0xff646464),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    bikroy,
                                    style: const TextStyle(
                                      color: Color(0xff646464),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "লাভ",
                                    style: TextStyle(
                                      color: Color(0xff646464),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    lav,
                                    style: const TextStyle(
                                      color: Color(0xff646464),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
          Positioned(
              bottom: -50,
              child: StreamBuilder<int>(
                  stream: valueController.stream,
                  initialData: valuePress,
                  builder: (context, snapshot) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            color: Color(0xffFFCCE4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(children: [
                              Visibility(
                                visible: snapshot.data != 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xffFFCCE4),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox.fromSize(
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              decrement();
                                            },
                                            tooltip: '-',
                                            child: const Text("-"),
                                            backgroundColor: Color(0xffFFBFDD),
                                          ),
                                          size: const Size.square(30),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${snapshot.data} পিস",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
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
                              Visibility(
                                visible: snapshot.data == 0,
                                child: SizedBox.fromSize(
                                  child: FloatingActionButton(
                                    backgroundColor: Color(0xff1400AE),
                                    onPressed: () {
                                      increment();
                                    },
                                    tooltip: '-',
                                    child: const Icon(Icons.add),
                                  ),
                                  size: Size.square(35),
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    );
                  }))
        ]);
  }

  Future hitApi(String url, bool isRemove) async {
    log("hit call");

    var response = await http.get(Uri.parse(url));
    /* setState(() {
        data = json.decode(response.body); // json array
        print(data);
      });*/

    //var obj = json.decode(response.body);
    var obj = json.decode(utf8.decode(response.bodyBytes));
    var products = obj["data"]["products"];

    var count = products["count"];
    var next = products["next"];
    nextPage = next ?? "";
    var results = products["results"];
    //print("count initial value for future : ${count ?? "Empty"}");

    int size = results.length;

    List<ProductItem> productList = [];
    for (int i = 0; i < size; i++) {
      var image = results[i]["image"];
      var product_name = results[i]["product_name"];
      var slug = results[i]["slug"];

      var charge = results[i]["charge"];
      var current_charge = charge["current_charge"];
      var selling_price = charge["selling_price"];
      var profit = charge["profit"];
      var discount_charge = charge["discount_charge"];

      int stock = results[i]["stock"];

      productList.add(ProductItem(product_name, image, "৳ $current_charge",
          "৳ $selling_price", "৳ $profit", "৳ $discount_charge", stock, "", "", "", slug));
    }

    if (!isRemove) {
      listBloc.add(productList);
    } else {
      listBloc.removeAdd(productList);
    }
  }
}
