import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:platepal/features/recipes/domain/entities/recipe_instructions.dart';

class InstructionsWidget extends StatefulWidget {
  final List<RecipeInstructionsEntity> recipeInstructionsEntity;

  const InstructionsWidget({super.key, required this.recipeInstructionsEntity});

  @override
  State<InstructionsWidget> createState() => _InstructionsWidgetState();
}

class _InstructionsWidgetState extends State<InstructionsWidget> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipeInstructionsEntity.first.steps!;

    return EnhanceStepper(
      physics: const NeverScrollableScrollPhysics(),
      currentStep: _currentStep,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            children: [
              if (_currentStep < steps.length - 1)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text(
                    'Back',
                    // style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        );
      },
      // stepIconSize: 30,
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_currentStep < steps.length - 1) {
          setState(() {
            _currentStep += 1;
          });
        }
      },
      onStepTapped: (step) {
        setState(() {
          _currentStep = step;
        });
      },
      steps: [
        for (var i = 0; i < steps.length; i++)
          EnhanceStep(
            isActive: _currentStep == i,
            title: Text(
              steps[i].step!,
              style: TextStyle(
                color: _currentStep == i ? Colors.black : Colors.grey,
              ),
            ),
            content: Column(
              children: [
                if (steps[i].equipment!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Equipment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                          for (var equipment in steps[i].equipment!)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "• ${equipment.name![0].toUpperCase()}${equipment.name!.substring(1)}",
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (steps[i].ingredients!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ingredients',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                          for (var ingredient in steps[i].ingredients!)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "• ${ingredient.name![0].toUpperCase()}${ingredient.name!.substring(1)}",
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (steps[i].length != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Length: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${steps[i].length!.number} ${steps[i].length!.unit}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
