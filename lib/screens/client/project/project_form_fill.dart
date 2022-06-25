import 'dart:collection';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'project_requirements2.dart';
import 'project_requirements1.dart';
import 'upload_project.dart';

class ProjectRequirementsForm extends StatefulWidget {
 @override
  _ProjectRequirementsFormState createState() => _ProjectRequirementsFormState();
}

class _ProjectRequirementsFormState extends State<ProjectRequirementsForm> {
  var currentStep = 0;
  @override
  Widget build(BuildContext context) {
    var mapData = HashMap<String, String>();
    mapData["title"] = Requirements1State.controllerTitle.text;
    mapData["description"] = Requirements1State.controllerDescription.text;
    mapData["category"] = Requirements1.getDropdownValue();
    mapData["price"] = Requirements2State.controllerPrice.text;
    mapData["time"] = Requirements2.getDropdownValue();

    List<Step> steps = [
      Step(
        title: FittedBox(fit: BoxFit.fitWidth, child: Text('Step 1   ', style: TextStyle(fontSize: 11),)),
        content: Requirements1(),
        state: currentStep == 0 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text('Step 2   ', style: TextStyle(fontSize: 12)),
        content: Requirements2(),
        state: currentStep == 1 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text('Confirm & Post', style: TextStyle(fontSize: 12)),
        content: Upload(mapData),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Project'),
        backgroundColor: color1,
      ),
      body: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
        width: MediaQuery.of(context).size.width * 0.98,
        child: Theme(
          data: ThemeData(
              colorScheme: ColorScheme.light(
                  primary: color1,
              )
          ),
          child: Stepper(
            currentStep: this.currentStep,
            steps: steps,
            type: StepperType.horizontal,
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
            },
            onStepContinue: () {
              setState(() {
                if (currentStep == steps.length - 1) {
                  print('end');
                }

                else {

                  if (currentStep < steps.length - 1) {
                    if (currentStep == 0 &&
                        Requirements1State.formKey.currentState!.validate()) {
                      currentStep = currentStep + 1;
                    } else if (currentStep == 1 &&
                        Requirements2State.formKey.currentState!.validate()) {
                      currentStep = currentStep + 1;
                    }
                  } else {
                    currentStep = 0;
                  }
                }

             });
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep = currentStep - 1;
                } else {
                  currentStep = 0;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
