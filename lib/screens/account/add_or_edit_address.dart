import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../../utilities/spr_list.dart';
import '../../providers/user.dart';

class AddOrEditAddress extends StatefulWidget {
  const AddOrEditAddress({Key? key, this.address = const {}}) : super(key: key);
  final Map<dynamic, dynamic> address;
  @override
  State<AddOrEditAddress> createState() => _AddOrEditAddressState();
}

class _AddOrEditAddressState extends State<AddOrEditAddress> {
  bool updateMode = false;

  final List<String> countries = ['India'];
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  bool chooseState = false;
  bool chooseCountry = false;
  bool sprError = false;

  String country = 'India';
  String fullName = '';
  String mobileNumber = '';
  String pinCode = '';
  String fhbca = '';
  String acssv = '';
  String landmark = '';
  String tc = '';
  String spr = '';
  String addressType = 'Home';

  @override
  void initState() {
    if (widget.address.isNotEmpty) {
      updateMode = true;
      country = widget.address['country'];
      fullName = widget.address['fullName'];
      mobileNumber = widget.address['mobileNumber'];
      pinCode = widget.address['pinCode'];
      fhbca = widget.address['fhbca'];
      acssv = widget.address['acssv'];
      landmark = widget.address['landmark'];
      tc = widget.address['tc'];
      spr = widget.address['spr'];
      addressType = widget.address['addressType'];
    }
    super.initState();
  }

  void onSubmit(BuildContext ctx) {
    FocusScope.of(ctx).unfocus();
    final bool formValid = form.currentState!.validate() && spr.isNotEmpty;
    setState(() {
      sprError = spr.isEmpty;
    });

    if (!formValid) {
      return;
    }

    form.currentState!.save();

    final Map<String, String> data = {
      'country': country,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'pinCode': pinCode,
      'fhbca': fhbca,
      'acssv': acssv,
      'landmark': landmark,
      'tc': tc,
      'spr': spr,
      'addressType': addressType,
    };

    if (updateMode) {
      Provider.of<User>(context, listen: false)
          .updateAddress(ctx, widget.address['_id'], data);
    } else {
      Provider.of<User>(ctx, listen: false).addNewAddress(ctx, data);
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

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(updateMode ? 'Edit Address' : 'Add New Address'),
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
            child: Stack(children: [
              SingleChildScrollView(
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 16, left: 12, right: 12),
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.grey.shade600))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Country',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic),
                            ),
                            Container(
                              height: 32,
                              padding:
                                  const EdgeInsets.only(left: 6, right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    chooseCountry = true;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        country == ''
                                            ? 'Select Country'
                                            : country,
                                        style: TextStyle(
                                          color: country == ''
                                              ? Colors.grey.shade700
                                              : Colors.black,
                                          fontSize: 15,
                                          // fontWeight: FontWeight.w600,
                                        )),
                                    const Icon(
                                      FontAwesome5.chevron_down,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      input(
                          initialValue: fullName,
                          label: 'Full Name',
                          save: (String v) {
                            setState(() {
                              fullName = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                          ctx: context),
                      input(
                          initialValue: mobileNumber.isNotEmpty
                              ? mobileNumber.substring(4)
                              : mobileNumber,
                          label: 'Mobile number',
                          save: (String v) {
                            setState(() {
                              mobileNumber = '+91 ' + v;
                            });
                          },
                          validator: (String v) {
                            if (!RegExp(r'^[1-9]{1}[0-9]{9}$').hasMatch(v)) {
                              return 'Please enter valid mobile number';
                            }
                            return null;
                          },
                          hint: '10-digit mobile number',
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          ctx: context),
                      input(
                          initialValue: pinCode,
                          label: 'Pin code',
                          save: (String v) {
                            setState(() {
                              pinCode = v;
                            });
                          },
                          validator: (String v) {
                            if (!RegExp(r'^[0-9]{6}$').hasMatch(v)) {
                              return 'Please enter valid pin code';
                            }
                            return null;
                          },
                          hint: '6 digits [0-9] Pin code',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          ctx: context),
                      input(
                          initialValue: fhbca,
                          label:
                              'Flat, House no., Building, Company, Apartment',
                          save: (String v) {
                            setState(() {
                              fhbca = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter flat / house no. / building / company / apartment';
                            }
                            return null;
                          },
                          ctx: context),
                      input(
                          initialValue: acssv,
                          label: 'Area, Colony, Street, Sector, Village',
                          save: (String v) {
                            setState(() {
                              acssv = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter area / colony / street / sector / village';
                            }
                            return null;
                          },
                          ctx: context),
                      input(
                          initialValue: landmark,
                          label: 'Landmark',
                          save: (String v) {
                            setState(() {
                              landmark = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter landmark';
                            }
                            return null;
                          },
                          hint:
                              'E.g. Near AIIMS Flyover, Behind Regal Cinema, etc.',
                          ctx: context),
                      input(
                          initialValue: tc,
                          label: 'Town/City',
                          save: (String v) {
                            setState(() {
                              tc = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Please enter town / city';
                            }
                            return null;
                          },
                          ctx: context),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 16, left: 12, right: 12),
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
                                    color: sprError
                                        ? Colors.red.shade900
                                        : Colors.grey.shade600))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'State / Province / Region',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic),
                            ),
                            Container(
                              height: 32,
                              padding:
                                  const EdgeInsets.only(left: 6, right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    chooseState = true;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(spr == '' ? 'Select State' : spr,
                                        style: TextStyle(
                                          color: spr == ''
                                              ? Colors.grey.shade700
                                              : Colors.black,
                                          fontSize: 15,
                                          // fontWeight: FontWeight.w600,
                                        )),
                                    const Icon(
                                      FontAwesome5.chevron_down,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 16, left: 12, right: 12),
                        height: 56,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Address Type',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addressType = 'Home';
                                    });
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      color: Colors.grey[300],
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          color: addressType == 'Home'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Colors.grey[300],
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 3,
                                                  color: addressType == 'Home'
                                                      ? Colors.black
                                                      : Colors.grey.shade600))),
                                      child: const Text(
                                        'Home',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addressType = 'Office';
                                    });
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      color: Colors.grey[300],
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          color: addressType == 'Office'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Colors.grey[300],
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 3,
                                                  color: addressType == 'Office'
                                                      ? Colors.black
                                                      : Colors.grey.shade600))),
                                      child: const Text(
                                        'Office',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(
                      onPressed:
                          Provider.of<User>(context).addOrupdateAddressLoading
                              ? null
                              : () => onSubmit(context),
                      child:
                          Provider.of<User>(context).addOrupdateAddressLoading
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
            ]),
          ),
          if (chooseState)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    chooseState = false;
                  });
                },
                child: Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        width: MediaQuery.of(context).size.width * 0.7,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 3,
                                          color: Colors.grey.shade600))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select  State',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        chooseState = false;
                                      });
                                    },
                                    child: const Text(
                                      'X',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height -
                                          appBar.preferredSize.height -
                                          MediaQuery.of(context).padding.top) *
                                      0.75 -
                                  50,
                              child: ListView.builder(
                                  itemCount: sprList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          spr = sprList[index];
                                          chooseState = false;
                                          sprError = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 12, bottom: 6),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade600))),
                                        child: Text(
                                          sprList[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
          if (chooseCountry)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    chooseCountry = false;
                  });
                },
                child: Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        width: MediaQuery.of(context).size.width * 0.7,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 3,
                                          color: Colors.grey.shade600))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select  Country',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        chooseCountry = false;
                                      });
                                    },
                                    child: const Text(
                                      'X',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height -
                                          appBar.preferredSize.height -
                                          MediaQuery.of(context).padding.top) *
                                      0.75 -
                                  50,
                              child: ListView.builder(
                                  itemCount: countries.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          country = countries[index];
                                          chooseCountry = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 12, bottom: 6),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade600))),
                                        child: Text(
                                          countries[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
