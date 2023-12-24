import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/image_picker_dialog.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfile extends StatefulWidget {
  dynamic profileData;
   UpdateProfile({super.key,required this.profileData});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
  late List eduLevels = [AppLocalizations.of(context)!.lessThanSecondary,AppLocalizations.of(context)!.secondary,AppLocalizations.of(context)!.bachlories,AppLocalizations.of(context)!.magister,AppLocalizations.of(context)!.doctorah,AppLocalizations.of(context)!.other,];
  @override
  void initState() {
    Provider.of<ServiceProvider>(context,listen: false).gerPersonalInfo().then((value) {
      setState(() {
        image = value['data']['image'].toString();
        userName.text  = value['data']['userName'].toString();
        fullName.text  = value['data']['fullName'].toString();
        phoneNumber.text  = value['data']['countryCode'].toString() + value['data']['personalNumber'].toString();
        email.text  = value['data']['email'];
        dob.text  = value['data']['birthDate'].toString().isEmpty ? '' : value['data']['birthDate'].toString();
        nationalId.text  = value['data']['nationalId'].toString().isEmpty? '' : value['data']['nationalId'].toString();
        martialStatus.text  = value['data']['martialStatus'].toString() == '1' ? AppLocalizations.of(context)!.single : AppLocalizations.of(context)!.married;
        final aI  = double.parse(value['data']['annualIncome'].toString());
        annualIncome.text  =  aI < 100000 ? incomes.first : (aI >= 100000 && aI <1000000) ? incomes[1]: (aI >= 1000000 && aI <10000000)? incomes[2] : incomes[3] ;
        netSavings.text  =  aI < 100000 ? incomes.first : (aI >= 100000 && aI <1000000) ? incomes[1]: (aI >= 1000000 && aI <10000000)? incomes[2] : incomes[3] ;
        familyCount.text  = value['data']['familyMembers'].toString() == '7'? AppLocalizations.of(context)!.higherThan6 : value['data']['familyMembers'].toString();
        educationLevel.text  = value['data']['educationalLevel'].toString() == '0'? eduLevels[0] : value['data']['educationalLevel'].toString() == '1'? eduLevels[1] : value['data']['educationalLevel'].toString() == '2'? eduLevels[2] : value['data']['educationalLevel'].toString() == '3'? eduLevels[3]: value['data']['educationalLevel'].toString() == '4'? eduLevels[4]  : value['data']['educationalLevel'].toString() == '5'? eduLevels[5] : '6';
        brief.text  = value['data']['briefYourself'].toString();
      });
    });
    super.initState();
  }

  late List incomes = [AppLocalizations.of(context)!.lessThan100000,AppLocalizations.of(context)!.from100000To1000000,AppLocalizations.of(context)!.from1000000To10000000,AppLocalizations.of(context)!.higherThan100000,];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.updateProfile,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if(pickedImage == null)
                if(image != null)
                GestureDetector(onTap: ()async{
                  pickedImage =await showImagePickerDialog(context);

                  setState(() {

                  });
                },child: Stack(
                  alignment: Alignment.topRight,
                  children: [

                    ClipOval(child: SizedBox.fromSize(size: Size.fromRadius(48),child: Image.network(image!,height: 100,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) =>  Image.asset('assets/images/user.png',height: 100),))),
                    Image.asset('assets/icons/pencil.png',width: 30),
                  ],
                )),

                if(pickedImage != null)
                  GestureDetector(onTap: ()async{
                    pickedImage =await showImagePickerDialog(context);

                    setState(() {

                    });
                  },child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                       CircleAvatar(backgroundImage: FileImage(File(pickedImage!.path),),radius: 60),
                      Image.asset('assets/icons/pencil.png',width: 30),
                    ],
                  )),
                const SizedBox(height: 50,),
                TextFormField(
                  controller: userName,
                  validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState((){});
                  },

                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.userName) ,
                      filled: true,

                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),

                TextFormField(
                  controller: fullName,
                  //validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState((){});
                  },

                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.fullName) ,
                      filled: true,
                      enabled: false,

                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),

                TextFormField(
                  controller: phoneNumber,
                 // validator: emptyFieldValidator,
                  enabled: false,
                  onChanged: (value) {
                    setState((){

                    });
                  },
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.phoneNumber),
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      suffixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        width: 130,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10) ),
                            color: Color.fromRGBO(240, 240, 240, 1)
                        ),
                        child: Row(
                          children: [
                            const Text('+966',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: kSecondColor),),
                            const SizedBox(width: 10,),
                            Image.asset('assets/icons/saudi_flag.png',height: 15),
                            const SizedBox(width: 10,),
                            const Icon(Icons.keyboard_arrow_down,color: Color.fromRGBO(141, 141, 141, 1))
                          ],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: email,
                  validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState((){});
                  },

                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.email) ,
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: nationalId,
                  //validator: emptyFieldValidator,
                  enabled: false,
                  onChanged: (value) {
                    setState((){});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.idNumber) ,
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),

                TextFormField(
                  enabled: false,
                  controller: dob,
                  //validator: emptyFieldValidator,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(context: context, initialDate: DateTime(1960), firstDate: DateTime(1960), lastDate: DateTime.now()).then((value) {
                      dob.text = intl.DateFormat('yyyy-MM-dd').format(value!);
                    });
                  },
                  onChanged: (value) {
                    setState((){});
                  },

                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.dob) ,

                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      suffixIcon: const Icon(Icons.arrow_drop_down_outlined,color: kSecondColor,)

                  ),
                ),
                const SizedBox(height: 20,),

                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.socialStatus) ,

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
                    hint:  Text(AppLocalizations.of(context)!.socialStatus),
                    value: martialStatus.text.isEmpty ? null : martialStatus.text,
                    items: [AppLocalizations.of(context)!.single,AppLocalizations.of(context)!.married]
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
                      setState(() {

                      });
                    },
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),

                const SizedBox(height: 20,),

                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.educationLevel) ,

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
                    hint: Text(AppLocalizations.of(context)!.educationLevel),
                    value:educationLevel.text.isEmpty? null : educationLevel.text,
                    items: eduLevels
                        .map((item) => DropdownMenuItem(
                      value: item,
                      onTap: () {
                        setState(() {
                          educationLevel.text = item;
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

                const SizedBox(height: 20,),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.familyCount) ,
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
                    hint:  Text(AppLocalizations.of(context)!.familyCount),
                   value:familyCount.text.isEmpty? null : familyCount.text,
                    items: ['1','2','3','4','5','6',AppLocalizations.of(context)!.higherThan6,]
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
                const SizedBox(height: 20,),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.annualIncome) ,

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
                    hint:  Text(AppLocalizations.of(context)!.annualIncome),
                    value:annualIncome.text.isEmpty? null : annualIncome.text,
                    items: incomes
                        .map((item) => DropdownMenuItem(
                      value: item,
                      onTap: () {
                        setState(() {
                          annualIncome.text = item;
                        });
                      },
                      child: Text(item,textDirection: TextDirection.ltr),
                    ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(height: 20,),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.netSavings) ,
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
                    hint:  Text(AppLocalizations.of(context)!.netSavings),
                    value:netSavings.text.isEmpty? null : netSavings.text,
                    items: incomes
                        .map((item) => DropdownMenuItem(
                      value: item,
                      onTap: () {
                        setState(() {
                          netSavings.text = item;
                        });
                      },
                      child: Text(item,textDirection: TextDirection.ltr),
                    ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(height: 20,),

                TextFormField(
                  controller: brief,
                  validator: (value) {

                  },
                  onChanged: (value) {
                    setState((){});
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.writeBriefAboutYourself) ,
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))
                  ),
                ),
                const SizedBox(height: 20,),

               /* if(_isLoading)
                  const LoadingIndicator(),*/
                const SizedBox(height: 20,),
                CustomButton(title: AppLocalizations.of(context)!.save,
                  onPressed:userName.text.isEmpty ||martialStatus.text.isEmpty ||  familyCount.text.isEmpty || annualIncome.text.isEmpty  ||netSavings.text.isEmpty ||  educationLevel.text.isEmpty ||/* brief.text.isEmpty || */email.text.isEmpty  /* || fullName.text.isEmpty*/ ? null :  () async{
                  if(_formKey.currentState!.validate()){

                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<AuthProvider>(context,listen: false).updatePersonalInfo(image: pickedImage != null ? File(pickedImage!.path) : null ,martialStatus: martialStatus.text== AppLocalizations.of(context)!.single ? '1' : '2', familyMembers: familyCount.text == AppLocalizations.of(context)!.higherThan6 ? '7':  familyCount.text, annualIncome: annualIncome.text == incomes[0] ? '100' : annualIncome.text == incomes[1] ? '100000': annualIncome.text == incomes[2] ?'1000000'  :'10000000', netSavings: netSavings.text, educationalLevel: educationLevel.text == eduLevels[0] ? '0': educationLevel.text == eduLevels[1] ? '1' : educationLevel.text == eduLevels[2] ? '2':educationLevel.text == eduLevels[3] ? '3' : educationLevel.text == eduLevels[4] ? '4' : '5', briefYourself: brief.text, birthDate: dob.text, email: email.text, personalNumber: phoneNumber.text, fullName: fullName.text,userName: userName.text).then((value) {
                      if(value['status']){
                        Navigator.of(context).pop();
                        showMessage(ctx: context, message: AppLocalizations.of(context)!.profileUpdated, title: AppLocalizations.of(context)!.success,backgroundColor: Colors.green);
                      }else{
                        showMessage(ctx: context, message: AppLocalizations.of(context)!.tryAgainLater, title: AppLocalizations.of(context)!.wrong);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  }else{
                    return ;
                  }
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
