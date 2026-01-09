import 'package:flutter/material.dart';
import 'package:meal_app/core/extensions/app_extensions.dart';


import '../../../config/colors/app_colors.dart';
import 'custom_text_field.dart';

mixin SearchMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchController.addListener(_handleSearchChange);
  }

  @override
  void dispose() {
    searchController.removeListener(_handleSearchChange);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearchChange() {
    if (searchController.text.isNotEmpty != isSearching) {
      setState(() => isSearching = searchController.text.isNotEmpty);
    }
    onSearchChanged(searchController.text);
  }

  void clearSearch() {
    searchController.clear();
    setState(() => isSearching = false);
    FocusScope.of(context).unfocus();
  }

  void startSearch() {
    setState(() => isSearching = true);
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  void onSearchChanged(String searchTerm);

  Widget buildSearchField({
    Duration? duration,
    Curve? curve,
    EdgeInsets? margin,
    EdgeInsets? copyWithMargin,
    String? hintText,
    String? headingLabelText,
  }) =>
      AnimatedContainer(
        duration: duration ?? const Duration(milliseconds: 300),
        curve: curve ?? Curves.easeInOut,
        margin:
            margin?.copyWith(top: isSearching ? (copyWithMargin?.top ?? 40) : margin.top) ??
            EdgeInsets.all(16).copyWith(top: isSearching ? 40 : 0),
        child: CustomTextField(
          filled: true,
          fillColor: AppColors.kAppDisabled.withValues(alpha: 0.05),
          disableAllBorder: true,
      headingLabelText: headingLabelText,
          focusNode: searchFocusNode,
          controller: searchController,
      hintText: hintText ?? "Search here...",
          prefixIcon: isSearching
              ? IconButton(onPressed: clearSearch, icon: const Icon(Icons.arrow_back), splashRadius: 20)
              : IconButton(onPressed: startSearch, icon: const Icon(Icons.search), splashRadius: 20),
          onChanged: (value) async {
            // Debounce the search to avoid too many API calls
            await Future.delayed(const Duration(milliseconds: 500));
            if (searchController.text == value) {
              // Ensure value hasn't changed during delay
              onSearchChanged(value);
            }
          },
        ),
  ).pOnly(top: isSearching ? kToolbarHeight : 0);
}