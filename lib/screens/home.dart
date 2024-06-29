import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zinary/classes/products.dart';
import 'package:zinary/classes/string_ex.dart';
import 'package:zinary/screens/details.dart';

import '../classes/app_color.dart';
import '../classes/main_class.dart';
import '../widgets/edt_clear.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _State();
}

class _State extends State<HomeMain> {

  final dio = Dio();

  bool loading = true, absorb = true, tm = false, allOk = false;

  List<Products> ls = [];
  List<Products> lsSh = [];

  FocusNode shFocus = FocusNode();
  TextEditingController shController = TextEditingController();

  @override
  void initState() {
    getProducts();
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
                    Expanded(
                      child: EdtClear(
                          onChanged: (v) {
                            setState(() {
                              List<Products> lsd = [];
                              if(v.isEmpty){
                                lsd = lsSh;
                              } else {
                                lsd = lsSh.where((ls) => ls.title.toString().toLowerCase().contains(v.toLowerCase())).toList();
                              }
                              ls = lsd;
                            });
                          },
                          focusNode: shFocus,
                          textController: shController,
                          textInputType: TextInputType.text,
                          hint: 'Search products',
                          max: 64),
                    ),
                  ],
                ),
              ),
              MainClass.bH(12),
              if(!loading && allOk)
                Expanded(
                  child: Padding(
                    padding: MainClass.padA(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 8),
                      itemCount: ls.length,
                      itemBuilder: (context, i) {
                        Products p = ls[i];
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () => MainClass.open(context, Details(id: p.id)),
                          child: Card(
                            elevation: 4,
                            shadowColor: AppColor.colorApp,
                            child: Container(
                                width: MainClass.devW(context, 6),
                                padding: MainClass.padA(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.network(
                                        p.image,
                                        width: MainClass.devW(context, 4),
                                        height: MainClass.devW(context, 4),
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: SizedBox(
                                              width: MainClass.devW(context, 4),
                                              height: MainClass.devW(context, 4),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    alignment: WrapAlignment.center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: AppColor.colorApp.withOpacity(0.3),
                                                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
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
                                                )
                                            ),
                                            alignment: Alignment.center,
                                            width: MainClass.devW(context, 4),
                                            height: MainClass.devW(context, 4),
                                            child: Text(p.title.substring(0, 2), maxLines: 1, textAlign: TextAlign.center,style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700,fontFamily: 'Satoshi'))
                                          );
                                        },
                                      ),
                                    ),
                                    MainClass.bH(12),
                                    Text(p.title.toString().inCaps, maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,fontFamily: 'Satoshi')),
                                    MainClass.bH(4),
                                    Text('₦${p.price.toStringAsFixed(2)}', maxLines: 1,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if(!loading && !allOk)
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          loading = true;
                          absorb = true;
                          allOk = false;
                        });
                        getProducts();
                      },
                      child: MainClass.txtB5('Click here to refresh', 14),
                    ),
                  ),
                ),
              if(loading && !allOk)
                Expanded(child: MainClass.prog())
            ],
          ),
        ),
      ),
    );
  }

  getProducts() async {
    setState(() {
      tm = false;
    });
    int statCode = 0;
    final response = await dio.get(MainClass.getBaseUrl()+'products',
      options: Options(
        sendTimeout: MainClass.tm(),
        contentType: "application/json",
        validateStatus: (statusCode){
          if(statusCode == null){
            return false;
          }
          if(statusCode == 400 || statusCode <= 500){
            setState(() {
              statCode = statusCode;
            });
            return true;
          }else{
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

    if(response.statusCode == 200){
      var js = response.data;

      for(int i = 0; i < js.length;i++){

        Products p = Products(
            js[i]['id'].toString(),
            js[i]['title'].toString(),
            js[i]['price'],
            js[i]['description'].toString(),
            js[i]['category'].toString(),
            js[i]['image'].toString(),
            js[i]['rating']['rate'],
            js[i]['rating']['count']
        );

        ls.add(p);
        lsSh.add(p);
      }

      setState(() {
        loading = false;
        absorb = false;
        allOk = true;
      });

    }
    else {
      showSnack('Network Error, Please retry after a few minutes ${statCode.toString()}');
    }

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

}
