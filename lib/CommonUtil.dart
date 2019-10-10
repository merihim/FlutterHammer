import 'dart:math';

class CommonUtil{
  static int rollD6() {
    return (1 + Random().nextInt(6));
  }

 static int rollD3() {
    return (1 + Random().nextInt(3));
  }
}