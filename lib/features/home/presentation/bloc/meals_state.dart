part of 'meals_bloc.dart';

enum MealsEmitState {
  initial,
  loading,
  success,
  error,

  detailLoading,
  detailSuccess,
  detailError,
}

class MealsState extends Equatable {
  final MealsEmitState emitState;

  final ApiListResponse<MealModel>? meals;

  final MealDetailModel? mealDetail;

  const MealsState({
    this.emitState = MealsEmitState.initial,
    this.meals,
    this.mealDetail,
  });

  MealsState copyWith({
    MealsEmitState? emitState,
    ApiListResponse<MealModel>? meals,
    MealDetailModel? mealDetail,
    bool clearMealDetail = false,
  }) {
    return MealsState(
      emitState: emitState ?? this.emitState,
      meals: meals ?? this.meals,
      mealDetail: clearMealDetail ? null : mealDetail ?? this.mealDetail,
    );
  }

  @override
  List<Object?> get props => [emitState, meals, mealDetail];
}
