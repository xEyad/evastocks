import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosooh/components/image_picker_dialog.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/validators.dart';
import 'package:provider/provider.dart';

import '../../components/custom_button.dart';
import '../../utils/functions.dart';

class UpdateProfile2 extends StatefulWidget {
  const UpdateProfile2({
    super.key,
  });

  @override
  State<UpdateProfile2> createState() => _UpdateProfile2State();
}

class _UpdateProfile2State extends State<UpdateProfile2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController nationalId = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController martialStatus = TextEditingController();
  final TextEditingController annualIncome = TextEditingController();
  final TextEditingController netSavings = TextEditingController();
  final TextEditingController familyCount = TextEditingController();
  final TextEditingController educationLevel = TextEditingController();
  final TextEditingController brief = TextEditingController();
  String? image;

  PickedFile? pickedImage;

  bool _isLoading = false;
  late List eduLevels = [
    AppLocalizations.of(context)!.lessThanSecondary,
    AppLocalizations.of(context)!.secondary,
    AppLocalizations.of(context)!.bachlories,
    AppLocalizations.of(context)!.magister,
    AppLocalizations.of(context)!.doctorah,
    AppLocalizations.of(context)!.other,
  ];
  @override
  void initState() {
    Provider.of<ServiceProvider>(context, listen: false)
        .getProfile2(context: context)
        .then((value) {
      setState(() {
        image = value['data']['avatar'].toString();
        userName.text =value['data']['username'] != null ?  value['data']['username'] : value['data']['name'].toString();
        fullName.text = value['data']['name'].toString();
        phoneNumber.text =
            value['data']['phone'].toString();
        email.text = value['data']['email'];
        dob.text = value['data']['date_of_birth'].toString().isEmpty
            ? ''
            : value['data']['date_of_birth'].toString();
        nationalId.text = value['data']['id_number'].toString().isEmpty
            ? ''
            : value['data']['id_number'].toString();
        martialStatus.text = value['data']['social_status'].toString() == '1'
            ? AppLocalizations.of(context)!.single
            : AppLocalizations.of(context)!.married;
        final aI = double.parse(value['data']['annual_income'].toString());
        annualIncome.text = aI < 100000
            ? incomes.first
            : (aI >= 100000 && aI < 1000000)
                ? incomes[1]
                : (aI >= 1000000 && aI < 10000000)
                    ? incomes[2]
                    : incomes[3];
        netSavings.text = aI < 100000
            ? incomes.first
            : (aI >= 100000 && aI < 1000000)
                ? incomes[1]
                : (aI >= 1000000 && aI < 10000000)
                    ? incomes[2]
                    : incomes[3];
        familyCount.text = value['data']['familyMembers'].toString() == '7'
            ? AppLocalizations.of(context)!.higherThan6
            : value['data']['family_members'].toString();
        educationLevel.text = value['data']['educationalLevel'].toString() ==
                '0'
            ? eduLevels[0]
            : value['data']['educationalLevel'].toString() == '1'
                ? eduLevels[1]
                : value['data']['educationalLevel'].toString() == '2'
                    ? eduLevels[2]
                    : value['data']['educationalLevel'].toString() == '3'
                        ? eduLevels[3]
                        : value['data']['educationalLevel'].toString() == '4'
                            ? eduLevels[4]
                            : value['data']['educationalLevel'].toString() ==
                                    '5'
                                ? eduLevels[5]
                                : '6';
        brief.text = value['data']['about_me'].toString();
      });
    });
    super.initState();
  }

  late List incomes = [
    AppLocalizations.of(context)!.lessThan100000,
    AppLocalizations.of(context)!.from100000To1000000,
    AppLocalizations.of(context)!.from1000000To10000000,
    AppLocalizations.of(context)!.higherThan100000,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.updateProfile,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (pickedImage == null)
                  if (image != null)
                    GestureDetector(
                        onTap: () async {
                          pickedImage = await showImagePickerDialog(context);

                          setState(() {});
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipOval(
                                child: SizedBox.fromSize(
                                    size: Size.fromRadius(48),
                                    child: Image.network(
                                      image!,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              'assets/images/default_avatar.png',
                                              height: 100),
                                    ))),
                            Image.asset('assets/icons/pencil.png', width: 30),
                          ],
                        )),
                if (pickedImage != null)
                  GestureDetector(
                      onTap: () async {
                        pickedImage = await showImagePickerDialog(context);

                        setState(() {});
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CircleAvatar(
                              backgroundImage: FileImage(
                                File(pickedImage!.path),
                              ),
                              radius: 60),
                          Image.asset('assets/icons/pencil.png', width: 30),
                        ],
                      )),
                const SizedBox(
                  height: 50,
                ),

                TextFormField(
                  controller: userName,
                  validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color:labelFormFieldColor,
                    ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor
                          )),
                      label: Text(AppLocalizations.of(context)!.userName),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: fullName,
                  //validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState(() {});
                  },

                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color:labelFormFieldColor,
                      ),


                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor
                          )),
                      label: Text(AppLocalizations.of(context)!.fullName),
                      filled: true,
                      enabled: false,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: phoneNumber,
                  // validator: emptyFieldValidator,
                  //enabled: false,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(

                      labelStyle: TextStyle(
                        color:labelFormFieldColor,
                      ),

                      label: Text(AppLocalizations.of(context)!.phoneNumber),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      suffixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        width: 130,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: Color.fromRGBO(240, 240, 240, 1)),
                        child: Row(
                          children: [
                            const Text(
                              '+966',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: kSecondColor),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset('assets/icons/saudi_flag.png',
                                height: 15),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Color.fromRGBO(141, 141, 141, 1))
                          ],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),

                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: email,
                  validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState(() {});
                  },
                  enabled: false,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color:labelFormFieldColor,
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor
                          )),
                      label: Text(AppLocalizations.of(context)!.email),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),
                ),
                const SizedBox(
                  height: 20,
                ),
                //national id widget

                /*
                TextFormField(
                  controller: nationalId,
                  //validator: emptyFieldValidator,
                  enabled: false,
                  onChanged: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.idNumber),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),
                ),
                const SizedBox(
                  height: 20,
                ),
                */

                //date of birth widget

                /*
                TextFormField(
                  //enabled: false,
                  controller: dob,
                  //validator: emptyFieldValidator,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime(1960),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now())
                        .then((value) {
                      dob.text = intl.DateFormat('yyyy-MM-dd').format(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {});
                  },

                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.dob),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: kSecondColor,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                */
                /*
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.socialStatus),
                    filled: true,
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                  ),
                  child: DropdownButton<dynamic>(
                    hint: Text(AppLocalizations.of(context)!.socialStatus),
                    value:
                        martialStatus.text.isEmpty ? null : martialStatus.text,
                    items: [
                      AppLocalizations.of(context)!.single,
                      AppLocalizations.of(context)!.married
                    ]
                        .map((item) => DropdownMenuItem(
                              value: item,
                              onTap: () {
                                setState(() {
                                  martialStatus.text = item;
                                });
                              },
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {});
                    },
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),

                 */
                // all other widgets
                /*
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        // <-- SEE HERE
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          height: 420,
                          child: Column(
                            children: [
                              Container(
                                height: 6,
                                width: 70,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(112, 112, 112, 1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 20, right: 20, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Text(
                                      AppLocalizations.of(context)!
                                          .socialStatus,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: kMainColor),
                                    )),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Card(
                                      child: SizedBox(
                                        width: SizeUtility(context).width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  martialStatus.text =
                                                      AppLocalizations.of(
                                                              context)!
                                                          .single;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .single,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kMainColor),
                                                    ),
                                                    if (martialStatus.text ==
                                                        AppLocalizations.of(
                                                                context)!
                                                            .single)
                                                      const Icon(
                                                        Icons.check,
                                                        color: kMainColor,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  martialStatus.text =
                                                      AppLocalizations.of(
                                                              context)!
                                                          .married;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .married,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kMainColor),
                                                    ),
                                                    if (martialStatus.text ==
                                                        AppLocalizations.of(
                                                                context)!
                                                            .married)
                                                      const Icon(
                                                        Icons.check,
                                                        color: kMainColor,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    CustomButton(
                                      title:
                                          AppLocalizations.of(context)!.apply,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: martialStatus,
                    //validator: emptyFieldValidator,
                    readOnly: true,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.socialStatus),
                        filled: true,
                        fillColor: const Color.fromRGBO(249, 249, 249, 1),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(242, 242, 242, 1))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(242, 242, 242, 1))),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: kSecondColor,
                        )),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),

                // InputDecorator(
                //   decoration: InputDecoration(
                //     label: Text(AppLocalizations.of(context)!.educationLevel),
                //     filled: true,
                //     fillColor: const Color.fromRGBO(249, 249, 249, 1),
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(
                //             color: Color.fromRGBO(242, 242, 242, 1))),
                //     enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(
                //             color: Color.fromRGBO(242, 242, 242, 1))),
                //   ),
                //   child: DropdownButton<dynamic>(
                //     hint: Text(AppLocalizations.of(context)!.educationLevel),
                //     value: educationLevel.text.isEmpty
                //         ? null
                //         : educationLevel.text,
                //     items: eduLevels
                //         .map((item) => DropdownMenuItem(
                //               value: item,
                //               onTap: () {
                //                 setState(() {
                //                   educationLevel.text = item;
                //                 });
                //               },
                //               child: Text(item),
                //             ))
                //         .toList(),
                //     onChanged: (val) {},
                //     isDense: true,
                //     isExpanded: true,
                //     underline: const SizedBox(),
                //     itemHeight: 50,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.familyCount),
                    filled: true,
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                  ),
                  child: DropdownButton<dynamic>(
                    hint: Text(AppLocalizations.of(context)!.familyCount),
                    value: familyCount.text.isEmpty ? null : familyCount.text,
                    items: [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      AppLocalizations.of(context)!.higherThan6,
                    ]
                        .map((item) => DropdownMenuItem(
                              value: item,
                              onTap: () {
                                setState(() {
                                  familyCount.text = item;
                                });
                              },
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.annualIncome),
                    filled: true,
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                  ),
                  child: DropdownButton<dynamic>(
                    hint: Text(AppLocalizations.of(context)!.annualIncome),
                    value: annualIncome.text.isEmpty ? null : annualIncome.text,
                    items: incomes
                        .map((item) => DropdownMenuItem(
                              value: item,
                              onTap: () {
                                setState(() {
                                  annualIncome.text = item;
                                });
                              },
                              child:
                                  Text(item, textDirection: TextDirection.ltr),
                            ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.netSavings),
                    filled: true,
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                  ),
                  child: DropdownButton<dynamic>(
                    hint: Text(AppLocalizations.of(context)!.netSavings),
                    value: netSavings.text.isEmpty ? null : netSavings.text,
                    items: incomes
                        .map((item) => DropdownMenuItem(
                              value: item,
                              onTap: () {
                                setState(() {
                                  netSavings.text = item;
                                });
                              },
                              child:
                                  Text(item, textDirection: TextDirection.ltr),
                            ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                */
                TextFormField(
                  controller: brief,
                  validator: (value) {},
                  onChanged: (value) {
                    setState(() {});
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color:labelFormFieldColor,
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor
                          )),
                      label: Text(AppLocalizations.of(context)!
                          .writeBriefAboutYourself),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)))),
                ),
                const SizedBox(
                  height: 20,
                ),

                /* if(_isLoading)
                  const LoadingIndicator(),*/
                const SizedBox(
                  height: 20,
                ),

                CustomButton(
                  title: AppLocalizations.of(context)!.save,
                  onPressed: userName.text.isEmpty ||
                          phoneNumber.text.isEmpty ||
                          dob.text.isEmpty ||
                          martialStatus.text.isEmpty ||
                          familyCount.text.isEmpty || //ToDo: handle this
                          annualIncome.text.isEmpty ||
                          netSavings.text.isEmpty
                      /*educationLevel
                              .text.isEmpty ||*/ /* brief.text.isEmpty || */
                      /*email.text.isEmpty*/ /* || fullName.text.isEmpty*/
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            await Provider.of<ServiceProvider>(context,
                                    listen: false)
                                .updateProfileData(
                              martialStatus: martialStatus.text ==
                                      AppLocalizations.of(context)!.single
                                  ? '1'
                                  : '2',
                              familyMembers: familyCount.text ==
                                      AppLocalizations.of(context)!.higherThan6
                                  ? '7'
                                  : familyCount.text,
                              annualIncome: annualIncome.text == incomes[0]
                                  ? '100'
                                  : annualIncome.text == incomes[1]
                                      ? '100000'
                                      : annualIncome.text == incomes[2]
                                          ? '1000000'
                                          : '10000000',
                              netSavings: netSavings.text,
                              /* educationalLevel: educationLevel.text ==
                                            eduLevels[0]
                                        ? '0'
                                        : educationLevel.text == eduLevels[1]
                                            ? '1'
                                            : educationLevel.text ==
                                                    eduLevels[2]
                                                ? '2'
                                                : educationLevel.text ==
                                                        eduLevels[3]
                                                    ? '3'
                                                    : educationLevel.text ==
                                                            eduLevels[4]
                                                        ? '4'
                                                        : '5',*/
                              briefYourself: brief.text,
                              birthDate: dob.text,
                              personalNumber: phoneNumber.text,
                              fullName: userName.text,
                              image: pickedImage != null ? pickedImage!.path :null

                            )
                                .then((value) {
                              if (Provider.of<ServiceProvider>(context,
                                      listen: false)
                                  .updatedInformation) {

                                Navigator.of(context).pop();
                                showMessage(
                                    ctx: context,
                                    message: AppLocalizations.of(context)!
                                        .profileUpdated,
                                    title:
                                        AppLocalizations.of(context)!.success,
                                    backgroundColor: Colors.green);
                              } else {
                                showMessage(
                                    ctx: context,
                                    message: value['msg'],
                                    title: AppLocalizations.of(context)!.wrong);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          } else {
                            return;
                          }
                        },
                ),
                // CustomButton(
                //   title: AppLocalizations.of(context)!.save,
                //   onPressed: userName.text.isEmpty ||
                //           martialStatus.text.isEmpty ||
                //           familyCount.text.isEmpty ||
                //           annualIncome.text.isEmpty ||
                //           netSavings.text.isEmpty ||
                //           educationLevel
                //               .text.isEmpty || /* brief.text.isEmpty || */
                //           email.text.isEmpty /* || fullName.text.isEmpty*/
                //       ? null
                //       : () async {
                //           if (_formKey.currentState!.validate()) {
                //             setState(() {
                //               _isLoading = true;
                //             });
                //             await Provider.of<AuthProvider>(context,
                //                     listen: false)
                //                 .updatePersonalInfo(
                //                     image: pickedImage != null
                //                         ? File(pickedImage!.path)
                //                         : null,
                //                     martialStatus: martialStatus.text ==
                //                             AppLocalizations.of(context)!.single
                //                         ? '1'
                //                         : '2',
                //                     familyMembers: familyCount.text ==
                //                             AppLocalizations.of(context)!
                //                                 .higherThan6
                //                         ? '7'
                //                         : familyCount.text,
                //                     annualIncome: annualIncome.text ==
                //                             incomes[0]
                //                         ? '100'
                //                         : annualIncome.text == incomes[1]
                //                             ? '100000'
                //                             : annualIncome.text == incomes[2]
                //                                 ? '1000000'
                //                                 : '10000000',
                //                     netSavings: netSavings.text,
                //                     educationalLevel: educationLevel.text ==
                //                             eduLevels[0]
                //                         ? '0'
                //                         : educationLevel.text == eduLevels[1]
                //                             ? '1'
                //                             : educationLevel.text ==
                //                                     eduLevels[2]
                //                                 ? '2'
                //                                 : educationLevel.text ==
                //                                         eduLevels[3]
                //                                     ? '3'
                //                                     : educationLevel.text ==
                //                                             eduLevels[4]
                //                                         ? '4'
                //                                         : '5',
                //                     briefYourself: brief.text,
                //                     birthDate: dob.text,
                //                     email: email.text,
                //                     personalNumber: phoneNumber.text,
                //                     fullName: fullName.text,
                //                     userName: userName.text)
                //                 .then((value) {
                //               if (value['status']) {
                //                 Navigator.of(context).pop();
                //                 showMessage(
                //                     ctx: context,
                //                     message: AppLocalizations.of(context)!
                //                         .profileUpdated,
                //                     title:
                //                         AppLocalizations.of(context)!.success,
                //                     backgroundColor: Colors.green);
                //               } else {
                //                 showMessage(
                //                     ctx: context,
                //                     message: AppLocalizations.of(context)!
                //                         .tryAgainLater,
                //                     title: AppLocalizations.of(context)!.wrong);
                //               }
                //               setState(() {
                //                 _isLoading = false;
                //               });
                //             });
                //           } else {
                //             return;
                //           }
                //         },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
