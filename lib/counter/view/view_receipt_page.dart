import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:posadmin/counter/Dropdown/dropdown_bloc.dart';
import 'package:posadmin/counter/cubit/dropdown_cubit.dart';
import 'package:posadmin/counter/firebase_service/firestore_bloc.dart';
import 'package:posadmin/counter/firebase_service/firestore_service.dart';
import 'package:posadmin/counter/model/product_model.dart';

class ViewReceiptPage extends StatelessWidget {
  const ViewReceiptPage({required this.code, super.key});
  final int code;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FirestoreBloc(FirestoreService())),
          BlocProvider(create: (context) => DropdownBloc()),
        ],
        child: ViewReceiptView(
          code: code,
        ));
  }
}

class ViewReceiptView extends StatefulWidget {
  const ViewReceiptView({required this.code, super.key});
  final int code;

  @override
  State<ViewReceiptView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<ViewReceiptView> {
  TextEditingController searchController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  List<DropdownMenuItem<String>> dropdownData = [
    DropdownMenuItem(
      child: Text(''),
      value: '',
    ),
    DropdownMenuItem(
      child: Text('Tires'),
      value: 'Tires',
    ),
    DropdownMenuItem(
      child: Text('Oils'),
      value: 'Oils',
    ),
    DropdownMenuItem(
      child: Text('Shocks'),
      value: 'Shocks',
    ),
    DropdownMenuItem(
      child: Text('Bolts'),
      value: 'Bolts',
    ),
    DropdownMenuItem(
      child: Text('Air Filter'),
      value: 'Air Filter',
    ),
    DropdownMenuItem(
      child: Text('Accessories'),
      value: 'Accessories',
    ),
    DropdownMenuItem(
      child: Text('Others'),
      value: 'Others',
    ),
  ];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/');
    }
    print('widget code:${widget.code}');
    BlocProvider.of<FirestoreBloc>(context).add(GetReceipt(widget.code));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(37, 40, 54, 1),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: BlocBuilder<FirestoreBloc, FirestoreState>(
                builder: (context, state) {
                  if (state is FirestoreReceiptLoaded) {
                    DateTime dateTime = DateTime.parse(
                      state.receipt.dateTimeCreated,
                    );
                    String formattedDate =
                        DateFormat('E, d MMM yyyy HH:mm:ss').format(dateTime);

                    double subTotal = 0;
                    double VAT = 0;
                    double Total;
                    List<int> totals = [];
                    print('count ${state.receipt.products.length}');
                    for (final product in state.receipt.products) {
                      var total = product.price * product.quantity;
                      totals.add(total);
                    }

                    for (final total in totals) {
                      subTotal = subTotal + total;
                    }

                    VAT = subTotal * 0.12;
                    Total = subTotal;
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromRGBO(31, 29, 43, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: GestureDetector(
                              onDoubleTap: () => context.go('/expenses'),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                // height: MediaQuery.of(context).size.height * .85,
                                width: MediaQuery.of(context).size.width * .35,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Text(
                                          "VAT'S Marketing Corporation",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: DottedBorder(
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(5),
                                                strokeWidth: 2,
                                                dashPattern: [5, 6],
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 20),
                                                  child: Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Container(
                                                      width: 70,
                                                      height: 30,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          "VAT'S",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Address',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 230,
                                            child: Text(
                                              state.receipt!.address,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Operator',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            state.receipt!.POSoperator,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Customer Name',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            state.receipt!.customerName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Payment Method',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            state.receipt!.paymentMethod,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Reference Number',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            state.receipt!.referenceNumber
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      for (var product
                                          in state.receipt.products)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    product.name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '@${NumberFormat("#,##0.00").format(product.price)}x${product.quantity}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        109, 114, 120, 1),
                                                    fontSize: 9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${NumberFormat("#,##0.00").format(product.price * product.quantity)} PHP',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(subTotal + state.receipt.serviceCharge)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Vatable Sales',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(state.receipt.vatableSales)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'VAT',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(state.receipt.vat)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Service Charge',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(state.receipt!.serviceCharge)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(subTotal + state.receipt.serviceCharge)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Cash',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(state.receipt!.cash)} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Change',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat("#,##0.00").format(state.receipt.cash - (subTotal + state.receipt.serviceCharge))} PHP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Thanks for fueling our passion. Drop by again, if your wallet isn't still sulking. You're always welcome here!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 9),
                                        ),
                                      ),
                                      Image.asset(
                                          'assets/images/Receipt_Logo.png'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is FirestoreOperationSuccess) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Edit Product",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              controller: productController,
                              style: TextStyle(
                                height: 3,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintText: 'Enter Product Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              enabled: false,
                              controller: codeController,
                              style: TextStyle(
                                height: 3,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey,
                                focusColor: Colors.white,
                                hintText: 'Enter Product Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<DropdownBloc, DropdownState>(
                          builder: (context, state) {
                            if (state is DropdownSuccessState) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: DropdownButton(
                                    padding: EdgeInsets.only(left: 10),
                                    value: state.value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 3,
                                        fontSize: 16),
                                    items: dropdownData,
                                    onChanged: (value) {
                                      BlocProvider.of<DropdownBloc>(context)
                                          .add(DropdownUpdateValue(value!));
                                      typeController.text = value;
                                    },
                                    iconSize: 0,
                                    underline: SizedBox(),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                iconColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Color.fromRGBO(57, 181, 74, 1),
                                fixedSize: Size(200, 40)),
                            child: Text(
                              'Edit Product',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 17),
                            ),
                            onPressed: () {
                              if (productController.text.isNotEmpty &&
                                  codeController.text.isNotEmpty &&
                                  typeController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty &&
                                  quantityController.text.isNotEmpty) {
                                ProductModel product = new ProductModel(
                                  int.parse(
                                    codeController.text.trim(),
                                  ),
                                  productController.text.trim(),
                                  typeController.text.trim(),
                                  int.parse(
                                    priceController.text.trim(),
                                  ),
                                  int.parse(
                                    quantityController.text.trim(),
                                  ),
                                  '',
                                );
                                BlocProvider.of<FirestoreBloc>(
                                  context,
                                ).add(
                                  UpdateProduct(
                                    product,
                                  ),
                                );
                                productController.text = '';
                                codeController.text = '';

                                priceController.text = '';
                                quantityController.text = '';
                                context.go('/inventory');
                              } else {
                                const snackBar = SnackBar(
                                  content: Text(
                                    'Please fill in the fields',
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              controller: priceController,
                              style: TextStyle(
                                height: 3,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintText: 'Enter Product Price',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              controller: quantityController,
                              style: TextStyle(
                                height: 3,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintText: 'Enter Product Quantity',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    iconColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor:
                                        Color.fromRGBO(57, 181, 74, 1),
                                    fixedSize: Size(200, 40)),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                                onPressed: () {
                                  context.go('/inventory');
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    iconColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor:
                                        Color.fromRGBO(57, 181, 74, 1),
                                    fixedSize: Size(200, 40)),
                                child: Text(
                                  'Edit Product',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                                onPressed: () {
                                  if (productController.text.isNotEmpty &&
                                      codeController.text.isNotEmpty &&
                                      typeController.text.isNotEmpty &&
                                      priceController.text.isNotEmpty &&
                                      quantityController.text.isNotEmpty) {
                                    ProductModel product = new ProductModel(
                                      int.parse(
                                        codeController.text.trim(),
                                      ),
                                      productController.text.trim(),
                                      typeController.text.trim(),
                                      int.parse(
                                        priceController.text.trim(),
                                      ),
                                      int.parse(
                                        quantityController.text.trim(),
                                      ),
                                      '',
                                    );
                                    BlocProvider.of<FirestoreBloc>(
                                      context,
                                    ).add(
                                      UpdateProduct(
                                        product,
                                      ),
                                    );
                                    productController.text = '';
                                    codeController.text = '';
                                    typeController.text = '';
                                    priceController.text = '';
                                    quantityController.text = '';
                                    context.go('/inventory');
                                  } else {
                                    const snackBar = SnackBar(
                                      content: Text(
                                        'Please fill in the fields',
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(
                        child: TextButton(
                      child: Text('LALALALALAL'),
                      onPressed: () => context.go('/pos'),
                    ));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
