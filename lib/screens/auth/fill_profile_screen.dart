import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:e2ee_chat/constants/colors.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/resources/image_paths.dart';
import 'package:e2ee_chat/theme.dart';
import 'package:e2ee_chat/utils/utils.dart';
import 'package:e2ee_chat/utils/validation.dart';
import 'package:e2ee_chat/widgets/custom_button.dart';
import 'package:e2ee_chat/widgets/custom_textfield.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/max_sized_container.dart';
import '../../widgets/custom_back_button.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({Key? key, required this.credentials})
      : super(key: key);

  final UserCredential credentials;

  @override
  _FillProfileScreenState createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? imgPath;

  final _formKey=GlobalKey<FormState>();


  DateTime? dob;


  @override
  void initState() {
    emailController.text = widget.credentials.user!.email!;
    nameController.text=widget.credentials.user?.displayName??'';
    phoneController.text=widget.credentials.user?.phoneNumber??'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: MaxSizedContainer(
      safePadding: MediaQuery.of(context).padding,
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                const CustomBackButton(),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  'Fill Your Profile',
                  style: theme.textTheme.headlineMedium,
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Utils.showImagePickerSheet(context).then((value) => setState(
                      () => imgPath = value,
                    ));
              },
              child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 65,
                  backgroundImage: imgPath == null
                      ? const NetworkImage(AppImagePaths.defaultProfilePicture)
                      : Image.file(File(imgPath!)).image),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomFormField(
                labelText: 'Full Name',
                isPassword: false,
                controller: nameController,
                validatorFunction: (val) => val==null?'Field required':null,
                primaryColor: primaryColor,
                textColor: bodyTextColor,
                textFieldBgColor: theme.scaffoldBackgroundColor,
                isLabelCenter: false),
            const SizedBox(
              height: 15,
            ),
            CustomFormField(
                labelText: 'Nickname',
                isPassword: false,
                controller: nickNameController,
                primaryColor: primaryColor,
                validatorFunction: (val) => val==null?'Field required':null,
                textColor: bodyTextColor,
                textFieldBgColor: theme.scaffoldBackgroundColor,
                isLabelCenter: false),
            const SizedBox(
              height: 15,
            ),
            CustomFormField(
                labelText: 'Date of Birth',
                enabled: false,
                controller: dobController,
                isPassword: false,
                suffixWidget: GestureDetector(
                    onTap: () {
                      showCalendarDatePicker2Dialog(
                          context: context,
                          config: CalendarDatePicker2WithActionButtonsConfig(),
                          dialogSize: const Size(300, 400)).then((value){
                            if(value!=null){ 
                              dob=value.first;
                              if(dob!=null)dobController.text='${dob!.day}/${dob!.month}/${dob!.year}';
                            }
                          });
                    },
                    child: const Icon(
                      IconsaxOutline.calendar,
                    )),
                validatorFunction: (val) => dob==null?'Date of Birth required':null,
                primaryColor: primaryColor,
                textColor: bodyTextColor,
                textFieldBgColor: theme.scaffoldBackgroundColor,
                isLabelCenter: false),
            const SizedBox(
              height: 15,
            ),
            CustomFormField(
                labelText: 'Email',
                isPassword: false,
                enabled: false,
                controller: emailController,
                suffixWidget: const Icon(
                  Icons.mail,
                ),
                validatorFunction: (val) => null,
                primaryColor: primaryColor,
                textColor: bodyTextColor,
                textFieldBgColor: theme.scaffoldBackgroundColor,
                isLabelCenter: false),
            const SizedBox(
              height: 15,
            ),
            CustomFormField(
                labelText: 'Phone Number',
                prefixWidget: const Padding(
                      padding: EdgeInsets.all(14), child: Text('+92')),
                isPassword: false,
                validatorFunction: ValidationUtils.validateMobile,
                controller: phoneController,
                primaryColor: primaryColor,
                textColor: bodyTextColor,
                textFieldBgColor: theme.scaffoldBackgroundColor,
                isLabelCenter: false),
            const SizedBox(
              height: 15,
            ),  
            const Spacer(),
            CustomButton(
              fullWidth: true,
              buttonText: 'Continue',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Provider.of<MyAuthProvider>(context, listen: false).fillUserProfile(
                      context: context,
                      credentials: widget.credentials,
                      nickname: nickNameController.text,
                      dob: dob!,
                      name: nameController.text,
                      imgPath: imgPath,
                      email: emailController.text,
                      phoneNumber: phoneController.text);
                }
              },
            )
          ],
        ),
      ),
    ))));
  }
}
