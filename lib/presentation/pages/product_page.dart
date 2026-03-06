import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_state.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          switch (state.status) {
            case ProductStatus.initial:
              return const Center(
                child: Text("Toque no botão para carregar os produtos."),
              );

            case ProductStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ProductStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Erro desconhecido.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.loadProducts,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              );

            case ProductStatus.success:
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final Product product = state.products[index];
                  return ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price}"),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.loadProducts,
        child: const Icon(Icons.download),
      ),
    );
  }
}
