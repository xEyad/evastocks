import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/image_picker_dialog.dart';
import 'package:nosooh/screens/personal_profile/finance_data.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';

class CompleteYourRequest extends StatefulWidget {
  const CompleteYourRequest({super.key});

  @override
  State<CompleteYourRequest> createState() => _CompleteYourRequestState();
}

class _CompleteYourRequestState extends State<CompleteYourRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  PickedFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.profile,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.yalla,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.weNeedSomeInfo,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kSecondColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.enterTheFieldCorrectly;
                    }
                    return null;
                  },
                  onChanged: (value) {

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
                      hintText: AppLocalizations.of(context)!.name,
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

                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.enterTheFieldCorrectly;
                    }
                    return null;
                  },
                  controller: _nationalityController,
                  onTap: ()  {

                  },
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
                      hintText: AppLocalizations.of(context)!.nationality,
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
                TextField(
                  onTap: () async{
                    pickedImage = await showImagePickerDialog(context);
                    setState(() {

                    });
                  },
                  controller: TextEditingController(text: pickedImage!= null ? AppLocalizations.of(context)!.imageAttached : ''),
                  readOnly: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(
                              color: activeFormFieldBorderColor
                          )),
                      label: Text(AppLocalizations.of(context)!.attachPassport),
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
                      suffixIcon: pickedImage != null ? IconButton(onPressed: (){
                        setState(() {
                          pickedImage = null;
                        });
                      }, icon: Icon(Icons.close,color: kMainColor,) ): Icon(
                        Icons.attachment,
                        color: kSecondColor,
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
                if(pickedImage!= null)
                Image.file(File(pickedImage!.path)),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  title: AppLocalizations.of(context)!.send,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await Provider.of<ServiceProvider>(context, listen: false)
                          .addKYC2(
                          name: _nameController.text, nationality: _nationalityController.text,passportImage: pickedImage != null ? pickedImage!.path : null )
                          .then((value) {
                        if (value['status']) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FinanceData(),
                          ));
                        } else {
                          showMessage(
                              ctx: context,
                              message: value['message'],
                              title: AppLocalizations.of(context)!.wrong);
                        }
                      });
                    } else {
                      return;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
