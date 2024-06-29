import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zinary/classes/string_ex.dart';
import 'package:zinary/screens/cart.dart';

import '../classes/app_color.dart';
import '../classes/carts.dart';
import '../classes/main_class.dart';

main() async {
  await GetStorage.init();
  runApp(const Details(id: ''));
}

class Details extends StatefulWidget {
  final String id;

  const Details({super.key, required this.id});

  @override
  State<Details> createState() => _State();
}

class _State extends State<Details> {
  final box = GetStorage();
  final dio = Dio();

  bool loading = true, absorb = true, addingCart = false, tm = false, allOk = false, itemAdded = false, reload = false;

  String title = '', desc = '', category = '', img = '';
  num price = 0, ratings = 0, count = 0;

  num cart = 0;
  num itemCount = 0;
  int itemIndex = 0;
  String itemId = '';
  String removeId = '';

  List<Carts> ls = [];

  @override
  void initState() {
    itemId = widget.id;
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AbsorbPointer(
        absorbing: absorb,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MainClass.customBar(),
          body: Column(
            children: [
              Container(
                color: AppColor.colorApp,
                padding: MainClass.padA(12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: MainClass.padS(0, 4),
                        child: const Icon(Icons.arrow_back_rounded, size: 24, color: Colors.white),
                      ),
                    ),
                    MainClass.bW(12),
                    Expanded(
                      child: MainClass.txtW6('Details', 16),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) =>
                              const Cart()),
                        ).then((value) {
                          setState((){
                            if(value != null){
                              reload = (value)['chk'];
                              if(reload){
                                if((value)['id'] == itemId){
                                  removeId = (value)['id'];
                                }
                                getCart();
                              }
                            }
                          });
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          MainClass.txtW5(cart.toString(), 14)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              MainClass.bH(12),
              if (!loading && allOk)
                Expanded(
                  child: Padding(
                    padding: MainClass.padA(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            shadowColor: AppColor.colorApp,
                            child: Center(
                              child: Image.network(
                                img,
                                width: MainClass.devW(context, 2),
                                height: MainClass.devW(context, 1.5),
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(
                                      width: MainClass.devW(context, 2),
                                      height: MainClass.devW(context, 1.5),
                                      child: Padding(
                                        padding: MainClass.padA(4),
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: AppColor.colorApp.withOpacity(0.3),
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, exception, stackTrace) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.colorApp,
                                          border: Border.all(
                                            color: Colors.white,
                                          )),
                                      alignment: Alignment.center,
                                      width: MainClass.devW(context, 2),
                                      height: MainClass.devW(context, 1.5),
                                      child: Text(title.substring(0, 2),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Satoshi')));
                                },
                              ),
                            ),
                          ),
                          MainClass.bH(12),
                          MainClass.txtB5(title, 14),
                          Text('₦${price.toStringAsFixed(2)}',
                              maxLines: 1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          MainClass.bH(12),
                          MainClass.txtB6('Description', 14),
                          MainClass.txtB5(desc.toString().inCaps, 14),
                          MainClass.bH(12),
                          MainClass.txtB6('Category', 14),
                          MainClass.txtB5(category.toString().inCaps, 14),
                          MainClass.bH(12),
                          MainClass.txtB6('Ratings', 14),
                          Row(
                            children: [
                              MainClass.txtB5(ratings.toString().inCaps, 14),
                              MainClass.bW(8),
                              Expanded(child: MainClass.ratingRow(ratings)),
                            ],
                          ),
                          MainClass.bH(12),
                          MainClass.txtB6('Reviews', 14),
                          MainClass.txtB5(count.toString(), 14),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!loading && !allOk)
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          loading = true;
                          absorb = true;
                          allOk = false;
                        });
                        getDetails();
                      },
                      child: MainClass.txtB5('Click here to refresh', 14),
                    ),
                  ),
                ),
              if (loading && !allOk) Expanded(child: MainClass.prog()),
              if (!loading && allOk)
                Container(
                    padding: MainClass.padA(12),
                    margin: MainClass.padA(12),
                    decoration: BoxDecoration(
                      color: AppColor.colorApp,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 24),
                        if (!itemAdded)
                          Expanded(
                              child: addingCart
                                  ? Padding(
                                      padding: MainClass.padS(4, 0),
                                      child: MainClass.progW(),
                                    )
                                  : InkWell(
                                      onTap: () => addCart(),
                                      child: Padding(
                                        padding: MainClass.padS(6, 0),
                                        child: Center(child: MainClass.txtW5('Add to Cart', 16)),
                                      ))),
                        if (itemAdded)
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => updateCart('sub'),
                                child: Container(
                                  padding: MainClass.padS(4, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: MainClass.txtB5(' - ', 20),
                                ),
                              ),
                              MainClass.bW(16),
                              MainClass.txtW5(itemCount.toString(), 14),
                              MainClass.bW(16),
                              InkWell(
                                onTap: () => updateCart('add'),
                                child: Container(
                                  padding: MainClass.padS(4, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: MainClass.txtB5(' + ', 20),
                                ),
                              ),
                            ],
                          )),
                      ],
                    )),
            ],
          ),
        ),
      ),
    );
  }

  getDetails() async {
    setState(() {
      tm = false;
    });
    int statCode = 0;
    final response = await dio
        .get(
      MainClass.getBaseUrl() + 'products/$itemId',
      options: Options(
        sendTimeout: MainClass.tm(),
        contentType: "application/json",
        validateStatus: (statusCode) {
          if (statusCode == null) {
            return false;
          }
          if (statusCode == 400 || statusCode <= 500) {
            setState(() {
              statCode = statusCode;
            });
            return true;
          } else {
            setState(() {
              statCode = statusCode;
            });
            return statusCode >= 200 && statusCode < 300;
          }
        },
      ),
    )
        .timeout(MainClass.tm(), onTimeout: () {
      setState(() {
        tm = true;
      });
      return showSnackT('Low Network Coverage, Please retry after a few minutes');
    }).onError((error, stackTrace) {
      RequestOptions req = RequestOptions();
      return Response(requestOptions: req);
    });

    if (response.statusCode == 200) {
      var js = response.data;

      title = js['title'].toString();
      price = js['price'];
      desc = js['description'].toString();
      category = js['category'].toString();
      img = js['image'].toString();
      ratings = js['rating']['rate'];
      count = js['rating']['count'];

      getCart();

    } else {
      showSnack('Network Error, Please retry after a few minutes ${statCode.toString()}');
    }
  }

  addCart() async {
    setState(() {
      tm = false;
      addingCart = true;
    });
    int statCode = 0;
    final response = await dio
        .post(
      MainClass.getBaseUrl() + 'carts',
      data: jsonEncode(<String, dynamic>{
        'userId': 1,
        'date': DateTime.now().toString().split(' ')[0],
        'products': [
          {
            "productId": itemId,
            "quantity": 1,
          }
        ],
      }),
      options: Options(
        sendTimeout: MainClass.tm(),
        contentType: "application/json",
        validateStatus: (statusCode) {
          if (statusCode == null) {
            return false;
          }
          if (statusCode == 400 || statusCode <= 500) {
            setState(() {
              statCode = statusCode;
            });
            return true;
          } else {
            setState(() {
              statCode = statusCode;
            });
            return statusCode >= 200 && statusCode < 300;
          }
        },
      ),
    )
        .timeout(MainClass.tm(), onTimeout: () {
      setState(() {
        tm = true;
      });
      return showSnackT('Low Network Coverage, Please retry after a few minutes');
    }).onError((error, stackTrace) {
      RequestOptions req = RequestOptions();
      return Response(requestOptions: req);
    });

    if (response.statusCode == 200) {
      updateCart('add');
    } else {
      showSnack('Network Error, Please retry after a few minutes ${statCode.toString()}');
    }
  }

  getCart() {
    var js = box.read('carts');
    if (js != null) {
      try {
        List j = js;
        if(j.isNotEmpty){
          ls = js;
          for (int i = 0; i < ls.length; i++) {
            if(reload){
              if (ls[i].id == itemId) {
                itemCount = ls[i].count;
                itemIndex = i;
                itemAdded = true;
              } else{
                itemCount = 0;
                itemAdded = false;
              }
            } else {
              if (ls[i].id == itemId) {
                itemCount = ls[i].count;
                itemIndex = i;
                if(reload == true && removeId == itemId){
                  itemAdded = false;
                } else {
                  itemAdded = true;
                }
                break;
              }
            }

          }
        } else {
          itemAdded = false;
        }

      } on FormatException {
        def();
      }
    } else {
      def();
    }

    setState(() {
      loading = false;
      absorb = false;
      allOk = true;
      cart = ls.length;
    });
  }

  updateCart(ty) {
    if(ls.isEmpty){
      Carts c = Carts(itemId, title, price, img, 1);
      cart = ls.length + 1;
      itemCount = 1;
      itemAdded = true;
      ls.add(c);
      box.write('carts', ls);
    } else {
      if (itemCount == 0) {
        Carts c = Carts(itemId, title, price, img, 1);
        cart = ls.length + 1;
        itemIndex = ls.length;
        itemCount = 1;
        itemAdded = true;
        ls.add(c);
        box.write('carts', ls);
      }
      else if (itemCount == 1) {
        if (ty == 'sub') {
          cart = ls.length - 1;
          itemCount = 0;
          itemAdded = false;
          ls.remove(ls[itemIndex]);
          box.write('carts', ls);
        } else {
          itemCount++;
          Carts c = Carts(itemId, title, price, img, itemCount);
          ls[itemIndex] = c;
          //ls.insert(itemIndex, c);
          // ls.remove(ls[itemIndex]);
          // ls.add(c);
          // itemIndex = ls.length;
          box.write('carts', ls);
        }
      }
      else if (itemCount > 1) {
        if (ty == 'sub') {
          itemCount--;
          Carts c = Carts(itemId, title, price, img, itemCount);
          ls[itemIndex] = c;
          // ls.remove(ls[itemIndex]);
          // ls.add(c);
          // itemIndex = ls.length - 1;
          box.write('carts', ls);
        } else {
          itemCount++;
          Carts c = Carts(itemId, title, price, img, itemCount);
          ls[itemIndex] = c;
          //ls.insert(itemIndex, c);
          // ls.remove(ls[itemIndex]);
          // ls.add(c);
          // itemIndex = ls.length;
          box.write('carts', ls);
        }
      }
      else {
        MainClass.snack(context, 'Error unable to add product to cart', 'e');
      }
    }


    setState(() {
      addingCart = false;
      absorb = false;
    });
  }

  showSnack(s) {
    if(!tm){
      MainClass.snack(context, s, 'e');
      setState(() {
        allOk = false;
        loading = false;
        absorb = false;
      });
    }

  }

  showSnackT(s) {
    if(tm){
      MainClass.snack(context, s, 'e');
      setState(() {
        allOk = false;
        loading = false;
        absorb = false;
      });
    }
  }

  def(){
    box.write('carts', ls);
    itemCount = 0;
    itemAdded = false;
    itemIndex = 0;
  }

}
