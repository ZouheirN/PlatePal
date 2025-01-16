// Generated by Hive CE
// Do not modify
// Check in to version control

import 'package:hive_ce/hive.dart';
import 'package:platepal/config/hive/hive_adapters.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(EntEntityAdapter());
    registerAdapter(ExtendedIngredientsEntityAdapter());
    registerAdapter(LengthEntityAdapter());
    registerAdapter(MeasuresEntityAdapter());
    registerAdapter(MetricEntityAdapter());
    registerAdapter(RandomRecipesEntityAdapter());
    registerAdapter(RecipeEntityAdapter());
    registerAdapter(RecipeInstructionsEntityAdapter());
    registerAdapter(ResultEntityAdapter());
    registerAdapter(SearchRecipeEntityAdapter());
    registerAdapter(SimilarRecipesEntityAdapter());
    registerAdapter(StepEntityAdapter());
    registerAdapter(UsEntityAdapter());
  }
}
