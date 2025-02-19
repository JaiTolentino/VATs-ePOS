import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posadmin/counter/model/product_model.dart';

part 'product_state.dart';
part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    List<ProductModel> list = [];
    on<UpdateTemporaryList>((event, emit) {
      double subTotal = 0;
      double vatableSales = 0;
      double vat = 0.0;
      double total = 0;
      double change = 0;
      bool found = false;
      emit(ProductLoading());
      try {
        if (list.length == 0) {
          list.add(event.product);
        } else {
          for (final item in list) {
            if (item.productCode == event.product.productCode) {
              item.quantity++;
              found = true;
              break; // Stop looping after finding the product
            }
          }
          if (!found) {
            list.add(event.product);
          }
        }
        list.forEach((data) {
          subTotal = subTotal + (data.price * data.quantity);
          print('subtotal1: $subTotal');
          print('quantity: ${data.quantity}');
        });
        subTotal += event.serviceCharge;
        vatableSales = subTotal / 1.12;
        vat = vatableSales * 0.12;

        total = subTotal;
        change = event.cash - total;
        print('CHANGEEEEE $change');
        emit(ProductUpdated(list, subTotal, total, vat, vatableSales));
      } catch (e) {
        print('UpdateTemporaryList error : $e');
        emit(ProductError('Error updating list'));
      }
    });
    on<UpdateTemporaryListValue>(
      (event, emit) {
        double subTotal = 0;
        double vatableSales = 0;
        double vat = 0.0;
        double total = 0;
        emit(ProductLoading());
        try {
          list.forEach((data) {
            subTotal = subTotal + (data.price * data.quantity);
            print('subtotal: $subTotal');
          });
          subTotal += event.serviceCharge;
          vatableSales = subTotal / 1.12;
          vat = vatableSales * 0.12;

          total = subTotal;
          emit(ProductUpdated(list, subTotal, total, vat, vatableSales));
        } catch (e) {
          print(e);
          emit(ProductError('Failed to fetch data'));
        }
      },
    );
    on<GetChange>(
      (event, emit) {
        double subTotal = 0;
        double vatableSales = 0;
        double vat = 0.0;
        double total = 0;
        double change = 0;
        emit(ProductLoading());
        try {
          list.forEach((data) {
            subTotal = subTotal + (data.price * data.quantity);
          });
          subTotal += event.serviceCharge;
          vatableSales = subTotal / 1.12;
          vat = vatableSales * 0.12;

          total = subTotal;
          change = event.cash - total;
          emit(ProductChange(list, subTotal, change, total, vat, vatableSales));
        } catch (e) {
          print(e);
          emit(ProductError('Failed to fetch data'));
        }
      },
    );
    on<GetTemporaryList>(
      (event, emit) {
        emit(ProductLoading());
        try {
          emit(ProductLoaded(list));
        } catch (e) {
          print(e);
          emit(ProductError('Failed to fetch data'));
        }
      },
    );
    on<DeleteProduct>(
      (event, emit) {
        double subTotal = 0;
        double vatableSales = 0;
        double vat = 0.0;
        double total = 0;
        emit(ProductLoading());
        try {
          if (event.product.quantity > 1) {
            event.product.quantity--;
          } else {
            list.remove(event.product);
          }
          list.forEach((data) {
            subTotal = subTotal + (data.price * data.quantity);
            print('subtotal delete: $subTotal');
            print('quantity delete: ${data.quantity}');
            vatableSales = subTotal / 1.12;
            vat = vatableSales * 0.12;

            total = subTotal + event.serviceCharge;
          });
          emit(ProductUpdated(list, subTotal, total, vat, vatableSales));
        } catch (e) {
          print(e);
          emit(ProductError('Error removing item'));
        }
      },
    );
  }
}
