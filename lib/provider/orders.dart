import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double Amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.Amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateStamp = DateTime.now();
    final url = Uri.parse(
        'https://flutterupdate1-default-rtdb.firebaseio.com/Orders.json');

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        Amount: total,
        products: cartProducts,
        dateTime: dateStamp,
      ),
    );
    notifyListeners();
  }
}
