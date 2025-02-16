import '../../../models/dtos/requests/category/category_insert_request.dart';
import '../../../models/dtos/requests/category/category_update_request.dart';
import '../../../models/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/providers/constant_colors.dart';
import 'category_screen_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryController categoryProvider;

  @override
  void initState() {
    super.initState();
    categoryProvider = CategoryController();
    categoryProvider.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryController>(
      create: (context) => categoryProvider,
      child: BlocConsumer<CategoryController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Category has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    categoryProvider.fetchData();
                  });
            } else {
              MyDialogUtils.showSuccessDialog(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
              );
            }
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showErrorDialog(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          } else if (state is ShowQuestionMessageState) {
            MyDialogUtils.showQuestionDialog(
                context: context,
                message: state.message,
                posActionTitle: "Yes",
                posAction: () async {
                  categoryProvider.deleteCategory(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is CategoryLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is CategoryLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is CategoryLoadedState) ||
              (previous is ShowSuccessMessageState &&
                  current is EmptyListState) ||
              (previous is LoadingState && current is ShowErrorMessageState);
        },
        builder: (context, state) {
          if (state is EmptyListState) {
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
                            onPressed: () {
                              showAddCategoryDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Category",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoadedState) {
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
                            onPressed: () {
                              showAddCategoryDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Category",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: DataTable(
                          columnSpacing: 16,
                          columns: [
                            DataColumn(label: Text("Category Name")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.categories?.length ?? 0,
                            (index) => categoryDataRow(
                              state.categories![index],
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Could Not Load The Categories Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow categoryDataRow(Category category, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(category.categoryName!.toString())),
        DataCell(
          DropdownButton<String>(
            hint: const Text(
              "Actions",
              style: TextStyle(fontSize: 14),
            ),
            items: [
              DropdownMenuItem(
                value: "Update",
                child: Container(
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Update",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "Delete",
                child: Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Delete",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "Update") {
                showEditCategoryDialog(context, category);
              } else if (value == "Delete") {
                categoryProvider.onDeleteCategoryPress(
                    "Are You Sure You Want To Delete This Category?",
                    category.id!);
              }
            },
            underline: Container(),
            icon: Icon(Icons.arrow_drop_down, size: 20),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  void showEditCategoryDialog(BuildContext context, Category category) {
    TextEditingController categoryNameControllerUpdate =
        TextEditingController(text: category.categoryName);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String initialCategoryName = category.categoryName!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit Category",
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
                          TextFormField(
                            controller: categoryNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Category Name",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure category name is not empty field";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ));
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
                if(initialCategoryName != categoryNameControllerUpdate.text) {
                  if (_formKey.currentState!.validate()) {
                    var request = CategoryUpdateRequest(
                        categoryName: categoryNameControllerUpdate.text);

                    await categoryProvider.updateCategory(
                        category.id!, request);

                    categoryNameControllerUpdate.clear();
                  }
                } else {
                  categoryProvider.categoryUpdatedScreenError("You must change at least one input field to update the category");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    TextEditingController categoryNameController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Category",
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
                        TextFormField(
                          controller: categoryNameController,
                          decoration: InputDecoration(
                            labelText: "Category Name",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Category name mustn't be empty";
                            }
                            return null;
                          },
                        ),
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
                  var request = CategoryInsertRequest(
                      categoryName: categoryNameController.text);

                  await categoryProvider.insertCategory(request);

                  categoryNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Insert", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
