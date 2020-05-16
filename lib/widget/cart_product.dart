import 'package:flutter/material.dart';
import 'package:pay_crunch/models/cart_item.dart';

class CartProduct extends StatelessWidget {
  final CartItem cartItem;
  final Function increaseQuantityHandler;
  final Function decreaseQuantityHandler;
  final int index;

  const CartProduct({
    @required this.cartItem,
    @required this.increaseQuantityHandler,
    @required this.decreaseQuantityHandler,
    @required this.index,
  });

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
                  icon: Icon(
                    Icons.arrow_drop_up,
                  ),
                  onPressed: () {
                    increaseQuantityHandler(cartItem,index);
                  },
                ),
                Expanded(child: Text("${cartItem.qty}")),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    decreaseQuantityHandler(cartItem, index);
                  },
                ),
              ],
            ),
          ),
          title: Text(cartItem.product.name),
          trailing: Text("${cartItem.product.price * cartItem.qty}"),
        ),
      ),
    );
  }
}
