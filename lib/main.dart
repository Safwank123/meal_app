import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/config/network/network_bloc.dart';
import 'package:toastification/toastification.dart';

import 'package:meal_app/config/api/api_services.dart';
import 'package:meal_app/features/home/data/repository/meals_repository.dart';
import 'package:meal_app/features/home/presentation/bloc/meals_bloc.dart';
import 'package:meal_app/features/home/presentation/screens/meal_list_screen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mealsRepository = MealsRepository(ApiServices());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MealsBloc(mealsRepository)..add(const FetchAllMeals()),
        ),
        BlocProvider(
          create: (_) =>
              FavoritesCubit(mealsRepository)..loadFavorites(),
        ),
        BlocProvider(
          create: (_) =>
              NetworkBloc(connectivity: Connectivity()),
          lazy: false,
        ),
      ],
      child: ToastificationWrapper(
        config: const ToastificationConfig(maxToastLimit: 1),
        child: BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (!state.isConnected) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: const Text("No Internet"),
                description:
                    const Text("You are offline. Showing cached data."),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }

            if (state.isRestored) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text("Internet Restored"),
                description:
                    const Text("Back online. Data will refresh."),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Meal App',
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const MealListScreen(),
          ),
        ),
      ),
    );
  }
}


final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<ScaffoldState>();
