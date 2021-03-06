import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../provider/cart.dart';
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

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutterupdate1-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    print(json.decode(response.body));
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            Amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                    //  email:item['email']
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateStamp = DateTime.now();
    final url = Uri.parse(
        'https://flutterupdate1-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');

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
