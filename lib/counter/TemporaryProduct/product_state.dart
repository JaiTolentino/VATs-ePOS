part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductUpdated extends ProductState {
  final List<ProductModel> products;
  final double subTotal;
  final double vat;
  final double total;
  final double vatableSales;
  ProductUpdated(
      this.products, this.subTotal, this.total, this.vat, this.vatableSales);
}

class ProductChange extends ProductState {
  final List<ProductModel> products;
  final double subTotal;
  final double vat;
  final double total;
  final double vatableSales;
  final double change;
  ProductChange(this.products, this.subTotal, this.change, this.total, this.vat,
      this.vatableSales);
}
