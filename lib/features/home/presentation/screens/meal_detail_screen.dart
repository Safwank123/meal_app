import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/config/typography/app_typography.dart';
import 'package:meal_app/core/common_widgets/custom_image_widget.dart';
import 'package:meal_app/features/home/data/model/meal_detail_model.dart';
import 'package:meal_app/features/home/presentation/bloc/meals_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.mealId});

  final String mealId;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}
class _MealDetailScreenState extends State<MealDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubePlayerController? _youtubeController;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MealsBloc>().add(FetchMealDetail(widget.mealId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  String _getYoutubeId(String url) {
    return YoutubePlayer.convertUrlToId(url) ?? '';
  }

  void _initYoutubeController(String url) {
    if (_currentVideoUrl == url) return;

    _currentVideoUrl = url;
    _youtubeController?.dispose();

    _youtubeController = YoutubePlayerController(
      initialVideoId: _getYoutubeId(url),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MealsBloc, MealsState>(
        buildWhen: (prev, curr) =>
            curr.emitState == MealsEmitState.detailLoading ||
            curr.emitState == MealsEmitState.detailSuccess ||
            curr.emitState == MealsEmitState.detailError,
        builder: (context, state) {
          if (state.emitState == MealsEmitState.detailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.emitState == MealsEmitState.detailError ||
              state.mealDetail == null) {
            return const Center(child: Text("Failed to load meal"));
          }

          final meal = state.mealDetail!;

          if (meal.youtube.isNotEmpty) {
            _initYoutubeController(meal.youtube);
          }

          return NestedScrollView(
            
             headerSliverBuilder: (context, _) => [
  SliverAppBar(
    expandedHeight: 300,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      background: Hero(
        tag: meal.id,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageViewerScreen(
                  imageUrl: meal.image,
                  heroTag: meal.id,
                ),
              ),
            );
          },
          child: CustomImageWidget(
            imageUrl: meal.image,
            height: 300,
          ),
        ),
      ),
    ),
  ),
  SliverPersistentHeader(
    pinned: true,
    delegate: _StickyTabBarDelegate(
      TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Ingredients"),
          Tab(text: "Steps"),
        ],
      ),
    ),
  ),
            ],

            body: TabBarView(
              controller: _tabController,
              children: [
                _overview(meal),
                _ingredients(meal),
                _steps(meal),
              ],
            ),
          );
        },
      ),
    );
  }

 
  Widget _overview(MealDetailModel meal) {
    final hasVideo = meal.youtube.isNotEmpty && _youtubeController != null;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MealsBloc>().add(FetchMealDetail(widget.mealId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
     
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text("Instructions",
                          style: AppTypography.style16Bold),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    meal.instructions,
                    style:
                        AppTypography.style14Regular.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
          ),

          
          if (hasVideo) ...[
            const SizedBox(height: 24),
            Text("Cooking Video",
                style: AppTypography.style16Bold),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _ingredients(MealDetailModel meal) => RefreshIndicator(
        onRefresh: () async {
          context.read<MealsBloc>().add(FetchMealDetail(widget.mealId));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: meal.ingredients.length,
          itemBuilder: (context, index) {
            final ingredient = meal.ingredients[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.2),
                  child: const Icon(Icons.restaurant_menu, color: Colors.green, size: 20),
                ),
                title: Text(
                  ingredient['name']!,
                  style: AppTypography.style14SemiBold,
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    ingredient['measure']!,
                    style: AppTypography.style13Regular.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _steps(MealDetailModel meal) {
    final steps = meal.instructions
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MealsBloc>().add(FetchMealDetail(widget.mealId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: AppTypography.style12Bold.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: AppTypography.style14Regular.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}



class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  final String imageUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            panEnabled: true,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
