import 'package:flutter/material.dart';
import 'package:pay_crunch/models/cart_item.dart';
import 'package:pay_crunch/models/product.dart';

class CartProduct extends StatelessWidget {

  final Product product;
  final CartItem cartItem;
  final Function increaseQuantityHandler;
  final Function decreaseQuantityHandler;
  final int index;

  const CartProduct({this.product, this.cartItem, this.increaseQuantityHandler, this.decreaseQuantityHandler, this.index});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Container(
            width: 104,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_drop_up,),
                  onPressed: () {
                  increaseQuantityHandler(index);
                  },
                ),
                Text("${cartItem.qty}"),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    decreaseQuantityHandler(cartItem,index);
                  },
                ),
              ],
            ),
          ),
          title: Text(product.name),
          trailing: Text("${product.price* cartItem.qty}"),
        ),
      ),
    );
  }
}
