import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:misproject/models/cartOrder.dart';
import 'package:misproject/services/orderProvider.dart';
import 'package:misproject/services/shoppingCartProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ShoppingCartProvider>(context, listen: false).loadCartItems();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, shoppingCartProvider, child) {
        return Container(
          margin: const EdgeInsets.only(top: 25, left: 10, right: 10),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              title(),
              shoppingCartProvider.cartItems.isNotEmpty ?
              Expanded(
                child: ListView.builder(
                  itemCount: shoppingCartProvider.cartItems.length,
                  itemBuilder: (context, index){
                    final item = shoppingCartProvider.cartItems[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.foodItem.name),
                        subtitle: Text('\$${item.foodItem.price} x quantity: ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  shoppingCartProvider.updateQuantity(item, item.quantity - 1);
                                }
                              },
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  shoppingCartProvider.updateQuantity(item, item.quantity + 1);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  shoppingCartProvider.removeFromCart(item.id);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ) : const Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Icon(Icons.remove_shopping_cart_outlined, size: 60,color: Colors.red),Text('You have nothing in your cart', style: TextStyle(fontSize: 18))]))),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Price: \$${shoppingCartProvider.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 17),),
                  ElevatedButton(
                    onPressed: () {
                      final order = CartOrder(
                        id: const Uuid().v4(),
                        totalPrice: shoppingCartProvider.totalPrice,
                        timestamp: DateTime.timestamp(),
                        items: shoppingCartProvider.cartItems,
                      );

                      Provider.of<OrderProvider>(context, listen: false).addOrder(order);

                      shoppingCartProvider.clearCart();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Order placed'),
                            duration: const Duration(milliseconds: 1000),
                            width: 280.0,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )
                      );

                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget title() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Cart', style: TextStyle(fontSize: 22)),
      ],
    );
  }
}

