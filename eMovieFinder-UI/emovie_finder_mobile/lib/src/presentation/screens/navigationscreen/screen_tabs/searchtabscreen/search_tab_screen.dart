import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../models/searchobjects/movie_search_object.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../basewidgets/movieposter.dart';
import '../../navigation_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/searchtabscreen/search_tab_screen_view_model.dart';
import '../moviedetailtabscreen/movie_detail_tab_screen.dart';

class SearchTabScreen extends StatefulWidget {
  static const String routeName = 'searchtabscreen';
  static const String path = '/searchtabscreen';

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  late SearchTabScreenViewModel viewModel;

  late final TextEditingController _searchByTitleController;

  String? selectedSortBy;
  dynamic selectedCategory;

  final double minPrice = 0.0;
  late double maxPrice = 0.0;

  RangeValues _priceRange = const RangeValues(0, 0);

  @override
  void initState() {
    super.initState();
    viewModel = SearchTabScreenViewModel();
    viewModel.homeScreenViewModel =
        Provider.of<NavigationScreenViewModel>(context, listen: false);
    _searchByTitleController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLatestMoviePrice();
      await fetchCategories();
      await getAllMovies();
    });
  }

  Future<void> fetchCategories() async {
    final response = await viewModel.fetchCategories();

    if (response != null) {
      viewModel.categories = response;
      setState(() {});
    }
  }

  Future<void> fetchLatestMoviePrice() async {
    final response = await viewModel.getLatestMoviePrice();

    if (response != null) {
      maxPrice = response;
      setState(() {
        _priceRange = RangeValues(0, maxPrice);
      });
    }
  }

  Future<void> performSearch() async {
    final categoryId = selectedCategory == null ? null : selectedCategory?.id;

    String? orderByValue = selectedSortBy == 'Last Added'
        ? OrderBy.lastAddedMovies.value
        : selectedSortBy == 'Most Popular'
            ? OrderBy.averageRating.value
            : null;

    final searchRequest = MovieSearchObject(
      title: _searchByTitleController.text,
      categoryId: categoryId,
      priceGTE: _priceRange.start,
      priceLTE: _priceRange.end,
      isAdministratorPanel: false,
      orderBy: orderByValue,
      isDescending: true,
    );

    await viewModel.getSearchResults(searchRequest);
  }

  Future<void> getAllMovies() async {
    final searchRequest = MovieSearchObject(
      isAdministratorPanel: false,
      priceGTE: _priceRange.start,
      priceLTE: _priceRange.end,
    );

    await viewModel.getSearchResults(searchRequest);
  }

  @override
  void dispose() {
    super.dispose();
    _searchByTitleController.dispose();
    viewModel.provider = null;
    viewModel.homeScreenViewModel = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    viewModel.onPressBackAction();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchByTitleController,
                    cursorColor: MyTheme.gray,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.all(10),
                      fillColor: MyTheme.blackFour,
                      hintText: "Search by movie title",
                      hintStyle:
                          const TextStyle(color: MyTheme.gray, fontSize: 18),
                      prefixIcon: const Icon(
                        EvaIcons.search,
                        color: MyTheme.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hoverColor: Colors.transparent,
                    ),
                    onChanged: (value) {
                      performSearch();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          const Divider(color: Colors.grey, height: 1, thickness: 1),
          const SizedBox(height: 23),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sort by:',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 5),
                      buildDropdown(
                        hint: 'Select how you would like to sort movies',
                        items: <String>['None', 'Last Added', 'Most Popular'],
                        value: selectedSortBy,
                        onChanged: (String? value) {
                          setState(() => selectedSortBy = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category:',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 5),
                      buildCategoryDropdown(
                        hint: 'Select a movie category',
                        items: viewModel.categories?.resultList ?? [],
                        value: selectedCategory,
                        onChanged: (dynamic selectedCategory) {
                          setState(() {
                            this.selectedCategory = selectedCategory;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Price Range',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                buildPriceSlider(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey, height: 1, thickness: 1),
          const SizedBox(height: 27),
          Expanded(
            child: BlocConsumer<SearchTabScreenViewModel, BaseState>(
              listener: (context, state) {
                if (state is MovieDetailsAction) {
                  GoRouter.of(context).pushNamed(MovieDetailTabScreen.routeName,
                      extra: state.movie);
                  viewModel.homeScreenViewModel!.setSelectedIndex(9);
                } else if (state is BackAction) {
                  context.pop(context);
                }
              },
              buildWhen: (previous, current) {
                return (previous is EmptyListState &&
                        current is LoadingState) ||
                    (previous is LoadingState && current is EmptyListState) ||
                    (previous is LoadingState &&
                        current is MoviesLoadedState) ||
                    (previous is LoadingState &&
                        current is ShowErrorMessageState) ||
                    (previous is MoviesLoadedState &&
                        current is LoadingState) ||
                    (previous is ShowErrorMessageState &&
                        current is LoadingState);
              },
              builder: (context, state) {
                if (state is EmptyListState) {
                  return Center(child: Image.asset('assets/images/empty.png'));
                } else if (state is LoadingState) {
                  return const Center(
                      child: CircularProgressIndicator(color: MyTheme.gold));
                } else if (state is MoviesLoadedState) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) => MoviePoster(
                            movie: state.movies?.resultList[index],
                            goToDetailsScreen: viewModel.goToDetailsScreen,
                          ),
                          itemCount: state.movies?.count,
                        ),
                      ),
                    ],
                  );
                } else if (state is ShowErrorMessageState) {
                  return Center(child: Image.asset('assets/images/empty.png'));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryDropdown({
    required String hint,
    required List<dynamic> items,
    required dynamic value,
    required ValueChanged<dynamic> onChanged,
  }) {
    final categoryItems = [
      null,
      ...items,
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.blackFour,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<dynamic>(
          isExpanded: true,
          hint: buildHint(hint),
          items: categoryItems.map((dynamic category) {
            return DropdownMenuItem<dynamic>(
              value: category,
              child: Text(
                category == null
                    ? 'All Categories'
                    : category.categoryName ?? 'Unknown',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          value: value,
          onChanged: (newCategory) {
            setState(() {
              selectedCategory = newCategory;
            });
            performSearch();
          },
          iconStyleData: const IconStyleData(
            icon: Icon(EvaIcons.arrowDown, color: MyTheme.gray),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyTheme.blackFour,
            ),
          ),
          buttonStyleData: ButtonStyleData(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyTheme.blackFour,
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return Colors.transparent;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.blackFour,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: buildHint(hint),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          value: value,
          onChanged: (newSortBy) {
            setState(() {
              selectedSortBy = newSortBy;
            });
            performSearch();
          },
          iconStyleData: const IconStyleData(
              icon: Icon(EvaIcons.arrowDown, color: MyTheme.gray)),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyTheme.blackFour,
            ),
          ),
          buttonStyleData: ButtonStyleData(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyTheme.blackFour,
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              return Colors.transparent;
            }),
          ),
        ),
      ),
    );
  }

  Widget buildHint(String hint) {
    return Row(
      children: [
        const Icon(
          EvaIcons.menu,
          color: MyTheme.gray,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 18,
              color: MyTheme.gray,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildPriceSlider() {
    return SliderTheme(
      data: const SliderThemeData(
        activeTrackColor: MyTheme.gold,
        inactiveTrackColor: MyTheme.blackFour,
        thumbColor: MyTheme.gold,
        trackHeight: 8,
      ),
      child: RangeSlider(
        values: _priceRange,
        min: minPrice,
        max: maxPrice,
        divisions: 25,
        labels: RangeLabels(
          '€${_priceRange.start.round()}',
          '€${_priceRange.end.round()}',
        ),
        onChanged: (newRange) {
          setState(() => _priceRange = newRange);
        },
        onChangeEnd: (newRange) {
          performSearch();
        },
      ),
    );
  }
}
