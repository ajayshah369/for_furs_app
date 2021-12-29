import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';

class AddOrEditPet extends StatefulWidget {
  const AddOrEditPet({Key? key, this.pet = const {}}) : super(key: key);

  final Map<dynamic, dynamic> pet;
  @override
  _AddOrEditPetState createState() => _AddOrEditPetState();
}

class _AddOrEditPetState extends State<AddOrEditPet> {
  bool updateMode = false;
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  String name = '';
  double age = 0;
  String breed = '';
  List<String> tags = [];

  @override
  void initState() {
    if (widget.pet.isNotEmpty) {
      updateMode = true;
      name = widget.pet['name'];
      age = widget.pet['age'].toDouble();
      breed = widget.pet['breed'];
    }
    super.initState();
  }

  void onSubmit(BuildContext ctx) {
    FocusScope.of(ctx).unfocus();
    final bool formValid = form.currentState!.validate();

    if (!formValid) {
      return;
    }

    form.currentState!.save();

    final Map<String, String> data = {
      'name': name,
      'age': age.toString(),
      'breed': breed,
    };

    if (updateMode) {
      Provider.of<User>(context, listen: false)
          .updatePet(ctx, widget.pet['_id'], data);
    } else {
      Provider.of<User>(ctx, listen: false).addNewPet(ctx, data);
    }
  }

  Widget input(
      {required String label,
      required Function save,
      required Function validator,
      required String initialValue,
      String hint = '',
      String prefixText = '',
      int maxLength = 100,
      int maxLine = 1,
      keyboardType = TextInputType.text,
      required BuildContext ctx}) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 12, right: 12),
      height: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                fontStyle: FontStyle.italic),
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            initialValue: initialValue,
            onSaved: (v) {
              save(v);
            },
            validator: (v) {
              return validator(v);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: maxLength,
            maxLines: maxLine,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                contentPadding: const EdgeInsets.all(6),
                isDense: true,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                prefixText: prefixText,
                counterText: '',
                counter: null,
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.grey.shade600)),
                errorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.red.shade900)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Theme.of(ctx).colorScheme.secondary))),
          ),
        ],
      ),
    );
  }

  bool isNumeric(String str) {
    try {
      double.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(updateMode ? 'Edit Pet' : 'Add New Pet'),
      titleTextStyle: Theme.of(context).textTheme.headline3,
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Form(
                  key: form,
                  child: Column(
                    children: [
                      input(
                          initialValue: name,
                          label: 'Name',
                          save: (String v) {
                            setState(() {
                              name = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          ctx: context),
                      input(
                          initialValue: age == 0.0 ? '' : age.toString(),
                          keyboardType: TextInputType.number,
                          label: 'Age',
                          save: (String v) {
                            setState(() {
                              age = double.parse(v);
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter age';
                            } else if (!isNumeric(v)) {
                              return 'Please enter a valid age';
                            } else if (double.parse(v) < 0) {
                              return 'Please enter age between 0 and 30';
                            }
                            return null;
                          },
                          ctx: context),
                      input(
                          initialValue: breed,
                          label: 'Breed',
                          save: (String v) {
                            setState(() {
                              breed = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter breed';
                            }
                            return null;
                          },
                          ctx: context),
                      const SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                        onPressed:
                            Provider.of<User>(context).addOrupdatePetLoading
                                ? null
                                : () => onSubmit(context),
                        child: Provider.of<User>(context).addOrupdatePetLoading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic),
                              ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Theme.of(context).colorScheme.secondary;
                            }
                            return Theme.of(context).colorScheme.secondary;
                          }),
                          // fixedSize: MaterialStateProperty.all(
                          //     const Size(double.infinity, 48)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }
}
