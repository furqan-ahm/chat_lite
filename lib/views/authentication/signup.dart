import 'package:chat_lite/loading.dart';
import 'package:chat_lite/models/user.dart';
import 'package:chat_lite/services/auth_service.dart';
import 'package:chat_lite/services/database_service.dart';
import 'package:chat_lite/services/local_pref.dart';
import 'package:chat_lite/views/home/chatrooms_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp({required this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

var heightSpace=const SizedBox(height: 10,);

class _SignUpState extends State<SignUp> {

  AuthService _auth=AuthService();
  DatabaseService _db=DatabaseService();

  Size? size;
  final _formKey=GlobalKey<FormState>();
  var _uname;
  var _pass;
  var _email;

  String error='';
  bool _visiblePassword=false;
  bool isLoading=false;


  signUp() async{

    if(_formKey.currentState!.validate()){

      setState(() {
        isLoading=true;
      });

      Map<String,String>userDataMap={
        "name":_uname,
        "email":_email
      };

      LocalPref.setUsernamePref(_uname);
      LocalPref.setEmailPref(_email);


      dynamic result =await _auth.signUpWithEmailAndPassword(_email, _pass).then((value) {
        _db.uploadUserInfo(userDataMap);
      });

      if(result is! chatUser){
        setState(() {

          error=result is String?result:'Unknown Error';
          isLoading=false;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Text(result, style: TextStyle(color: Colors.redAccent),textAlign: TextAlign.center,),
          ));
        });
      }

    }
  }


  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: isLoading?const LoadingCircle():SingleChildScrollView(
        child: SizedBox(
          width: size!.width,
          height: size!.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 4),
              const Flexible(
                flex: 1,
                child: Align(
                    alignment: AlignmentDirectional.center,
                    child: Image(image: AssetImage('assets/chatlogo.png'))
                ),
              ),
              Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: size!.width*0.5,
                    child: Divider(
                      height: size!.height*0.03,
                      color: Colors.white,
                    ),
                  )
              ),
              Flexible(
                  flex: 9,
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                prefixIcon: const Icon(Icons.person, color: Colors.white,),
                                hintText: "Username"),
                            style: simpleTextStyle,
                            validator: (val)=>val!.isEmpty?"Enter valid username":null,
                            onChanged: (val)=>_uname=val,
                          ),
                          heightSpace,
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                prefixIcon: const Icon(Icons.mail, color: Colors.white,),
                                hintText: "Email"),
                            style: simpleTextStyle,
                            validator: (val)=>RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)?null:"Enter valid email",
                            onChanged: (val)=>_email=val,
                          ),
                          heightSpace,
                          TextFormField(
                            obscureText: !_visiblePassword,
                            decoration: textInputDecoration.copyWith(
                                prefixIcon: const Icon(Icons.lock, color: Colors.white,),
                                hintText: "Password",
                                suffixIcon: GestureDetector(
                                    child: !_visiblePassword?const Icon(Icons.visibility_off, color: Colors.white,):const Icon(Icons.visibility, color: Colors.white,),
                                    onTap: (){
                                      setState(() {
                                      _visiblePassword=!_visiblePassword;
                                    });},
                                ),
                            ),
                            style: simpleTextStyle,
                            validator: (val)=>val!.length<6?"Enter a 6+ char Password":null,
                            onChanged: (val)=>_pass=val,
                          ),
                          heightSpace,
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                child: Text("Forgot password?", style: simpleTextStyle)
                            ),
                          ),
                          heightSpace,
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.indigo
                                  ]),
                            ),
                            child: TextButton(
                              child: Text("Sign Up", style: mediumTextStyle,),
                              onPressed: signUp,
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: Size(size!.width*0.8,0)
                              ),
                            ),
                          ),
                          heightSpace,
                          DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white
                            ),
                            child: TextButton(
                              child: Text("Sign Up with Google", style: mediumTextStyle.copyWith(color: Colors.black87),),
                              onPressed: (){

                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: Size(size!.width*0.8,0)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.white,fontSize: 14),
                              ),
                              GestureDetector(
                                child: Text(
                                  "Sign in now!",
                                  style: TextStyle(color:Colors.white,fontSize: 14,decoration: TextDecoration.underline),
                                ),
                                onTap: (){widget.toggleView();},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
