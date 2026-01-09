import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/utiles/api_response_handler.dart';
import 'package:meal_app/features/home/data/model/favorite_meal_db_model.dart';
import 'package:meal_app/features/home/data/model/meal_detail_model.dart';
import 'package:meal_app/features/home/data/model/meal_model.dart';

import '../../data/repository/meals_repository.dart';

part 'meals_event.dart';
part 'meals_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealsRepository _repository;

  MealsBloc(this._repository) : super(const MealsState()) {
    on<FetchAllMeals>(_onFetchAllMeals);
    on<FetchMealDetail>(_onFetchMealDetail);
  }

  Future<void> _onFetchAllMeals(
    FetchAllMeals event,
    Emitter<MealsState> emit,
  ) async {
    emit(state.copyWith(emitState: MealsEmitState.loading));

    final response = await _repository.fetchAllMeals();

    if (response.success) {
      emit(state.copyWith(emitState: MealsEmitState.success, meals: response));
    } else {
      emit(state.copyWith(emitState: MealsEmitState.error));
    }
  }

  Future<void> _onFetchMealDetail(
    FetchMealDetail event,
    Emitter<MealsState> emit,
  ) async {
    emit(state.copyWith(emitState: MealsEmitState.detailLoading));

    final meal = await _repository.fetchMealDetail(event.mealId);

    if (meal != null) {
      emit(
        state.copyWith(
          emitState: MealsEmitState.detailSuccess,
          mealDetail: meal,
        ),
      );
    } else {
      emit(state.copyWith(emitState: MealsEmitState.detailError));
    }
  }
}

class FavoritesCubit extends Cubit<List<FavoriteMealDbModel>> {
  FavoritesCubit(this._repo) : super([]);

  final MealsRepository _repo;

  Future<void> loadFavorites() async {
    final list = await _repo.getFavorites();

    emit(list);
  }

  bool isFavorite(String id) {
    final result = state.any((e) => e.id == id);

    return result;
  }

  Future<void> toggle(FavoriteMealDbModel meal) async {
    await _repo.toggleFavorite(meal);

    await loadFavorites();
  }
}
