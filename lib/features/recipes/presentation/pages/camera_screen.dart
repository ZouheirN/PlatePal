import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:platepal/features/recipes/domain/entities/image_analysis.dart';
import 'package:platepal/features/recipes/presentation/bloc/recipes/recipes_bloc.dart';
import 'package:platepal/features/recipes/presentation/bloc/recipes/recipes_event.dart';
import 'package:platepal/features/recipes/presentation/bloc/recipes/recipes_state.dart';
import 'package:platepal/features/recipes/presentation/widgets/image_analysis_card.dart';
import 'package:platepal/features/recipes/presentation/widgets/select_image_sheet.dart';
import 'package:platepal/injection_container.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _recipeBloc = sl<RecipesBloc>();
  final _imagesRecipeBloc = sl<RecipesBloc>();

  @override
  void initState() {
    _recipeBloc.add(const GetImagesAnalysis());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        actions: [
          SelectImageSheet(
            onImageSelected: (img) {
              _imagesRecipeBloc.add(GetImageAnalysis(image: img));

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocListener(
            bloc: _imagesRecipeBloc,
            listener: (context, state) {
              if (state is RecipesLoading) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      duration: Duration(minutes: 1),
                      content: Text('Uploading image...'),
                    ),
                  );
              }

              if (state is ImageAnalysisDone) {
                _imagesRecipeBloc.add(
                  StoreImageAnalysis(
                    image: state.image!,
                    imageAnalysisEntity: state.imageAnalysis!,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Image uploaded!'),
                    ),
                  );
              }

              if (state is ImageAnalysisError) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Error uploading image!'),
                    ),
                  );
              }
            },
            child: BlocBuilder(
              bloc: _recipeBloc,
              builder: (context, state) {
                if (state is RecipesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ImagesAnalysisDone) {
                  final valueListenable = state.recipeAnalysis;

                  return ValueListenableBuilder(
                    valueListenable: valueListenable!,
                    builder: (context, box, child) {
                      final List images = (box as Box).keys.toList();
                      final List<ImageAnalysisEntity?> recipesAnalyses =
                          List<ImageAnalysisEntity?>.from(
                              (box).values.toList());

                      if (recipesAnalyses.isEmpty) {
                        return const Center(
                          child: Text(
                              'Take pictures to get detailed food analysis!'),
                        );
                      }

                      return GridView.builder(
                        cacheExtent: 1000,
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: recipesAnalyses.length,
                        itemBuilder: (context, index) {
                          return ImageAnalysisCard(
                            image: File(images[index] as String),
                            recipeAnalysis: recipesAnalyses[index],
                          );
                        },
                      );
                    },
                  );
                }

                if (state is ImagesAnalysisError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
