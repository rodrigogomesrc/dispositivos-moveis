import 'package:f08_eshop_app/components/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../model/product_list.dart';

class ProductGrid extends StatefulWidget {
  final bool showOnlyFavoritos;
  ProductGrid(this.showOnlyFavoritos);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<void> _fetchProductsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = Provider.of<ProductList>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: _fetchProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar os produtos. Tente novamente mais tarde!",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return Consumer<ProductList>(
                  builder: (ctx, productList, child) {
                    final filteredProducts = productList.items.where((product) {
                      return !widget.showOnlyFavoritos || product.isFavorite;
                    }).toList();

                    return ProductGridView(products: filteredProducts);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i], 
        child: ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
