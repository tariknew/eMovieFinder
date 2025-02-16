import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/order/order_sales_report_insert_request.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/helpers/report_generator.dart';
import '../../../utils/providers/constant_colors.dart';
import '../../../utils/providers/recommender_provider.dart';
import '../moviescreen/movie_screen_view_model.dart';
import 'order_sales_report_screen_view_model.dart';

class OrderSalesReportScreen extends StatefulWidget {
  const OrderSalesReportScreen({Key? key}) : super(key: key);

  @override
  State<OrderSalesReportScreen> createState() => _OrderSalesReportScreenState();
}

class _OrderSalesReportScreenState extends State<OrderSalesReportScreen> {
  late OrderController orderProvider;
  late RecommenderController recommenderProvider;

  @override
  void initState() {
    super.initState();
    orderProvider = OrderController();
    recommenderProvider = RecommenderController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchMovies();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final response = await MovieController().fetchMovies();

    if (response != null) {
      setState(() {
        orderProvider.movies = response;
      });
    }
  }

  void showAddOrdersDialog(BuildContext context) {
    TextEditingController yearController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? selectedMovie;
    dynamic selectedMovieId;
    String? selectedMonth;

    List<Map<String, dynamic>> months = [
      {"name": "January", "value": 1},
      {"name": "February", "value": 2},
      {"name": "March", "value": 3},
      {"name": "April", "value": 4},
      {"name": "May", "value": 5},
      {"name": "June", "value": 6},
      {"name": "July", "value": 7},
      {"name": "August", "value": 8},
      {"name": "September", "value": 9},
      {"name": "October", "value": 10},
      {"name": "November", "value": 11},
      {"name": "December", "value": 12},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Get Orders Count Of The Movie",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                  key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: yearController,
                          decoration: InputDecoration(
                            labelText: "Year",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Month",
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<dynamic>(
                            isExpanded: true,
                            value: selectedMonth,
                            hint: Text("Select Month"),
                            items:
                                months.map<DropdownMenuItem<dynamic>>((month) {
                              return DropdownMenuItem<dynamic>(
                                value: month["name"],
                                child: Text(
                                  month["name"],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (dynamic newValue) {
                              setState(() {
                                selectedMonth = newValue;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey),
                                color: secondaryColor,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FormField<dynamic>(
                          validator: (value) {
                            if (value == null) {
                              return "Please select a movie";
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Movie",
                                  style: TextStyle(fontSize: 16),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<dynamic>(
                                    isExpanded: true,
                                    value: selectedMovieId,
                                    hint: Text("Select Movie"),
                                    items: (orderProvider.movies?.resultList ?? [])
                                        .map((movie) => DropdownMenuItem<dynamic>(
                                      value: movie.id,
                                      child: Text(
                                        movie.title!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      state.didChange(newValue);
                                      setState(() {
                                        selectedMovieId = newValue;
                                        selectedMovie = orderProvider.movies?.resultList
                                            .firstWhere((movie) => movie.id == selectedMovieId)
                                            .title;
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: Colors.grey),
                                        color: secondaryColor,
                                      ),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 20,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  var searchRequest = OrderSalesReportInsertRequest(
                    movieId: selectedMovieId,
                    year: yearController.text.isNotEmpty
                        ? int.parse(yearController.text)
                        : null,
                    month: selectedMonth != null
                        ? months.firstWhere(
                            (month) => month["name"] == selectedMonth)["value"]
                        : null,
                  );

                  var response =
                      await orderProvider.getOrderSalesReport(searchRequest);

                  if (response != null) {
                    bool isSuccess = await generateAndSavePdf(
                        selectedMovie!, response.totalOrders!);
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("PDF generated successfully at the location where you saved it")),
          );
        }
                  }
                  yearController.clear();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Get Information",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderController>(
      create: (context) => orderProvider,
      child: BlocConsumer<OrderController, BaseState>(
        listener: (context, state) {
          if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessDialog(
              context: context,
              message: state.message,
              posActionTitle: "Ok",
            );
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showErrorDialog(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await fetchMovies();
                            showAddOrdersDialog(context);
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Get Information of Orders",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            recommenderProvider
                                .trainFavouriteMoviesModel(context);
                          },
                          icon: const Icon(Icons.info, color: Colors.white),
                          label: const Text(
                            "Train Favourite Movies Model",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
