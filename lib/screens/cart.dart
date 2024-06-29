import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../classes/app_color.dart';
import '../classes/carts.dart';
import '../classes/main_class.dart';

main() async {
  await GetStorage.init();
  runApp(const Cart());
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _State();
}

class _State extends State<Cart> {
  final box = GetStorage();

  bool cartUpdate = false, reload = false;

  String itemId = '0';
  num total = 0;

  List<Carts> ls = [];

  @override
  void initState() {
    getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (b) {
          if (!b) {
            Navigator.pop(context, {'chk': reload, 'id': itemId});
            return;
          }
        },
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
                      onTap: () => Navigator.pop(context, {'chk': reload, 'id': itemId}),
                      child: Padding(
                        padding: MainClass.padS(0, 4),
                        child: const Icon(Icons.arrow_back_rounded, size: 24, color: Colors.white),
                      ),
                    ),
                    MainClass.bW(12),
                    Expanded(
                      child: MainClass.txtW6('Cart', 16),
                    ),
                  ],
                ),
              ),
              MainClass.bH(12),
              if (ls.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.remove_shopping_cart_outlined, size: 64, color: AppColor.colorApp),
                      MainClass.bH(12),
                      MainClass.txtB5('You have no item in your cart', 16),
                    ],
                  ),
                ),
              if (ls.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: MainClass.padA(16),
                  child: ListView.builder(
                    itemCount: ls.length,
                    itemBuilder: (BuildContext context, int i) {
                      final Carts c = ls[i];
                      return Card(
                        elevation: 4,
                        shadowColor: AppColor.colorApp,
                        child: Padding(
                          padding: MainClass.padA(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    c.image,
                                    width: 24,
                                    height: 28,
                                    loadingBuilder:
                                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: CircularProgressIndicator(
                                            color: AppColor.colorApp.withOpacity(0.3),
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
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
                                          width: 24,
                                          height: 28,
                                          child: Text(c.title.substring(0, 2),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Satoshi')));
                                    },
                                  ),
                                  MainClass.bW(8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.title,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        Text('₦${c.price.toStringAsFixed(2)} * ${c.count}',
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              MainClass.bH(8),
                              InkWell(
                                  onTap: () => updateCart(i, c.id),
                                  child: const Text('Remove',
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              MainClass.bH(12),
              if (ls.isNotEmpty)
                Padding(
                  padding: MainClass.padA(16),
                  child: ElevatedButton(
                    style: MainClass.btnSty(),
                    onPressed: () => MainClass.snack(context, 'End of assessment process', 's'),
                    child: Text('Checkout (₦${total.toStringAsFixed(2)})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  getCart() {
    var js = box.read('carts');
    if (js != null) {
      try {
        List j = js;
        if (j.isNotEmpty) {
          ls = js;
          for (int i = 0; i < ls.length; i++) {
            num x = ls[i].price * ls[i].count;
            total = x + total;
          }
        }
      } on FormatException {
        ls = [];
      }
    }
  }

  updateCart(id, proId) {
    if(ls.isNotEmpty){
      num x = ls[id].price * ls[id].count;
      total = total - x;
    }

    ls.removeAt(id);
    box.write('carts', ls);

    setState(() {
      reload = true;
      itemId = proId;
    });
  }
}
