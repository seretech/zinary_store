import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

class MainClass {

  static bH(res) {
    double a1 = res.toDouble();
    return SizedBox(height: a1);
  }

  static bW(res) {
    double a1 = res.toDouble();
    return SizedBox(width: a1);
  }

  static devH(ctx, sz) {
    double a1 = sz.toDouble();
    return MediaQuery.of(ctx).size.height / a1;
  }

  static devW(ctx, sz) {
    double a1 = sz.toDouble();
    return MediaQuery.of(ctx).size.width / a1;
  }

  static tm() {
    return const Duration(seconds: 30);
  }

  static getBaseUrl(){
    return 'https://fakestoreapi.com/';
  }

  static txtW4(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtW5(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtW6(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtB4(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.black, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtB5(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.black, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w500));
  }

  static txtB6(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.black, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w600));
  }

  static padA(i) {
    double a = i.toDouble();
    return EdgeInsets.all(a);
  }

  static padS(t, l) {
    double ver = t.toDouble();
    double hor = l.toDouble();
    return EdgeInsets.only(top: ver, bottom: ver, left: hor, right: hor);
  }

  static padO(t, b, l, r) {
    double tp = t.toDouble();
    double bt = b.toDouble();
    double le = l.toDouble();
    double rt = r.toDouble();
    return EdgeInsets.only(top: tp, bottom: bt, left: le, right: rt);
  }

  static prog(){
    return Center(
      child: CircularProgressIndicator(
        color: AppColor.colorApp,
      ),
    );
  }

  static progW(){
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  static open(ctx, p) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) => p),
    );
  }

  static customBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        elevation: 0,
        systemOverlayStyle: Platform.isIOS ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: AppColor.colorApp,
            statusBarIconBrightness: Brightness.light),
      ),
    );
  }

  static ratingRow(r) {
    return Row(
      children: [
        Icon(Icons.star, color: r >= 1 ? Colors.orange : Colors.grey.withOpacity(0.7), size: 16),
        MainClass.bW(2),
        Icon(Icons.star, color: r >= 2 ? Colors.orange : Colors.grey.withOpacity(0.7), size: 16),
        MainClass.bW(2),
        Icon(Icons.star, color: r >= 3 ? Colors.orange : Colors.grey.withOpacity(0.7), size: 16),
        MainClass.bW(2),
        Icon(Icons.star, color: r >= 4 ? Colors.orange : Colors.grey.withOpacity(0.7), size: 16),
        MainClass.bW(2),
        Icon(Icons.star, color: r >= 5 ? Colors.orange : Colors.grey.withOpacity(0.7), size: 16),
      ],
    );
  }

  static btnSty() {
    return ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      backgroundColor: AppColor.colorApp,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static snack(ctx, sms, ty) {
    if (ty == 's') {
      AnimatedSnackBar(
        builder: ((context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: AppColor.colorApp,
            ),
            padding: padS(4, 8),
            child: Wrap(
              children: [
                Text(sms, style: const TextStyle(color: Colors.white, fontFamily: 'Satoshi', fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }),
        duration: const Duration(seconds: 5),
      ).show(ctx);
    } else {
      otherSnack(ctx, sms, ty);
    }
  }

  static otherSnack(ctx, sms, ty){
    AnimatedSnackBarType stat = AnimatedSnackBarType.success;

    if (ty == 'e') {
      stat = AnimatedSnackBarType.error;
    } else if (ty == 'i') {
      stat = AnimatedSnackBarType.info;
    } else if (ty == 'w') {
      stat = AnimatedSnackBarType.warning;
    } else {
      stat = AnimatedSnackBarType.success;
    }

    AnimatedSnackBar.material(sms,
        type: stat,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        duration: const Duration(seconds: 5),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight)
        .show(ctx);
  }

}
