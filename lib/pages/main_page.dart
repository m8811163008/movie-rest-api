import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_rest_api/controller/main_page_data_controller.dart';
import 'package:movie_rest_api/models/main_page_data.dart';
import 'package:movie_rest_api/models/search_category.dart';
import 'package:movie_rest_api/widgets/movie_tile.dart';

import '../models/movie.dart';

//create new controller provider
final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
        (_) => MainPageDataController());

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final List<Movie> _movies = ref.watch(mainPageDataControllerProvider).movies;
  return _movies.isNotEmpty ? _movies[0].posterUrl : null;
});

class MainPage extends ConsumerWidget {
  //holding a reference to mainPageDataController
  late MainPageDataController _mainPageDataController;
  //keeping information regarding of main page data
  late MainPageData _mainPageData;
  late double _deviceHeight;
  late double _deviceWidth;
  late String? _selectedMoviePosterURL;
  MainPage({Key? key}) : super(key: key);

  final TextEditingController _searchTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _searchTextEditingController.text = _mainPageData.searchText;
    _selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);
    return _buildUI();
  }

  Widget _buildUI() => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SizedBox(
          width: _deviceWidth,
          height: _deviceHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _backgroundWidget(),
              _foregroundWidgets(),
            ],
          ),
        ),
      );

  Widget _backgroundWidget() {
    if (_selectedMoviePosterURL != null) {
      return Container(
        width: _deviceWidth,
        height: _deviceHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(_selectedMoviePosterURL!),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.expand();
    }
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight * 0.02, 0, 0),
      width: _deviceWidth * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidgets(),
          Container(
            height: _deviceHeight * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
            child: _movieListViewWidget(),
          )
        ],
      ),
    );
  }

  Widget _topBarWidgets() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    InputBorder _inputBorder = InputBorder.none;
    return SizedBox(
      width: _deviceWidth * 0.50,
      height: _deviceHeight * 0.05,
      child: TextField(
        controller: _searchTextEditingController,
        onSubmitted: (_value) =>
            _mainPageDataController.updateTextSearch(_value),
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            border: _inputBorder,
            focusedBorder: _inputBorder,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search....'),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      items: const [
        DropdownMenuItem(
            child: Text(
              SearchCategory.popular,
              style: TextStyle(color: Colors.white),
            ),
            value: SearchCategory.popular),
        DropdownMenuItem(
            child: Text(
              SearchCategory.upcoming,
              style: TextStyle(color: Colors.white),
            ),
            value: SearchCategory.upcoming),
        DropdownMenuItem(
            child: Text(
              SearchCategory.none,
              style: TextStyle(color: Colors.white),
            ),
            value: SearchCategory.none),
      ],
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(_value.toString())
          : null,
    );
  }

  Widget _movieListViewWidget() {
    final List<Movie> _movies = _mainPageData.movies;

    if (_movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (_onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext _context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: _deviceHeight * 0.01, horizontal: 0),
                child: GestureDetector(
                  child: MovieTile(
                      movie: _movies[index],
                      height: _deviceHeight * 0.20,
                      width: _deviceWidth * 0.85),
                  onTap: () {
                    _selectedMoviePosterURL = _movies[index].posterUrl;
                  },
                ),
              );
            }),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
