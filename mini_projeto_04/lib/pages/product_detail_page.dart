import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/product_list.dart';

import 'package:provider/provider.dart';


class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    final providerProdutos = Provider.of<ProductList>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id, 
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(product.description),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  ChangeNotifierProvider.value(
                    value: product, 
                    child: IconButton(
                      onPressed: () => Provider.of<ProductList>(context, listen: false).toggleFavorite(product),
                      icon: Consumer<Product>(
                        builder: (context, product, child) => Icon(
                            product.isFavorite ? Icons.favorite : Icons.favorite_border),
                      ),
                
                      color: Colors.red
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                  ChangeNotifierProvider.value(
                    value: product, 
                    child: IconButton(
                      onPressed: () => Provider.of<ProductList>(context, listen: false).toggleFavorite(product),
                      icon: Consumer<Product>(
                        builder: (context, product, child) => IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            providerProdutos.removeProduct(product);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      color: Colors.red
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}