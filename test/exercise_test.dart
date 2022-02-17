//1 - Dado el siguiente fragmento de código, identifique y corrija para lograr un código Dart Efectivo
import 'dart:math' as m;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Shapes test',
    () async {
      final shapes = <Shape>[Circle(4.8), Circle(.9), Square(4.5), Square(.9)];
      for (var s in shapes) {
        print(s.area());
      }
    },
  );
}

const pi = 3.4;

abstract class Shape {
  double area();
}

/// Circle area calculator
/// Example
/// ```
/// final c = Circle(1.2);
/// print(c.area())
/// ```
class Circle extends Shape {
  final double radio;
  Circle(this.radio);
  @override
  double area() => radio * m.pow(pi, 2);
}

/// Square area calculator
/// Example
///
/// var s = Square(2);
/// print(s.area())
///

class Square extends Shape {
  final double side;
  Square(this.side);
  @override
  double area() => m.pow(side, 2).toDouble();
}
