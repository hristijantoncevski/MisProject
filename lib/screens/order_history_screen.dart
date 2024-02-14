import 'package:flutter/material.dart';
import 'package:misproject/services/orderProvider.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      await Provider.of<OrderProvider>(context, listen: false).loadOrders();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return isLoading ? const Center(child: CircularProgressIndicator())
              :
          orderProvider.orders.isEmpty ? const Center(child: Text('You have made no orders yet', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold))) :
          ListView.builder(
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${orderProvider.orders[index].id}'),
                  subtitle: Text('Order Price: \$${orderProvider.orders[index].totalPrice.toStringAsFixed(2)}'),
                  onTap: () {

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}