import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;

  HomePage({required this.username, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

// Items listed
class _HomePageState extends State<HomePage> {
  List<String> products = [
    'Chicken Biriyani',
    'Veg Biriyani',
    'Egg Biriyani',
    'Ghee Rice',
  ];
  Map<String, int> cartItems = {};
  int maxStock = 2;

  void _addToCart(String product) {
    if (cartItems.containsKey(product)) {
      if (cartItems[product]! < maxStock) {
        setState(() {
          cartItems[product] = cartItems[product]! + 1;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Out of Stock'),
              content: Text('You cannot add more than $maxStock $product to cart.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        cartItems[product] = 1;
      });
    }
  }

  void _decreaseCartItem(String product) {
    setState(() {
      if (cartItems.containsKey(product)) {
        if (cartItems[product]! > 1) {
          cartItems[product] = cartItems[product]! - 1;
        } else {
          cartItems.remove(product);
        }
      }
    });
  }

  void _viewOrderDetails() {
    String email = widget.email; // default value
    String username = widget.username;
    String password = ''; // retrieving password from the registration process

    // Show order details dialog with user information
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Username: $username'),
              Text('Email: $email'),
              SizedBox(height: 16.0),
              Text('Items in Cart:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cartItems.entries.map((entry) {
                  return Text('${entry.key}: ${entry.value}');
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

// Homepage display page
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Food Ordering App'),
    ),
    body: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Welcome, ${widget.username}!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Products:',
            style: TextStyle(fontSize: 18.0),
          ),
          Column(
            children: products.map((product) {
              return ListTile(
                title: Text(product),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (cartItems.containsKey(product)) {
                            if (cartItems[product]! > 1) {
                              cartItems[product] = cartItems[product]! - 1;
                            } else {
                              cartItems.remove(product);
                            }
                          }
                        });
                      },
                    ),
                    Text(
                      cartItems.containsKey(product)
                          ? cartItems[product].toString()
                          : '0',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _addToCart(product);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _viewOrderDetails();
            },
            child: Text('View Order Details'),
          ),
        ],
      ),
    ),
  );
}
}