part of 'meals_bloc.dart';

sealed class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllMeals extends MealsEvent {
  const FetchAllMeals();
}

class FetchMealDetail extends MealsEvent {
  final String mealId;
  const FetchMealDetail(this.mealId);

  @override
  List<Object?> get props => [mealId];
}
