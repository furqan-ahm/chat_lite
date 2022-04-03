import 'package:chat_lite/constants.dart';
import 'package:chat_lite/models/user.dart';
import 'package:chat_lite/services/auth_service.dart';
import 'package:chat_lite/services/database_service.dart';
import 'package:chat_lite/services/local_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  var _pass;
  var _email;
  String error='';
  Size? size;
  final _formKey=GlobalKey<FormState>();

  AuthService _auth=AuthService();
  DatabaseService _db=DatabaseService();

  bool _visiblePassword=false;
  bool isLoading=false;


  signIn()async{
    if(_formKey.currentState!.validate()){

      setState(() {
        isLoading=true;
      });

      _db.getUserByEmail(_email).then((val){
        LocalPref.setUsernamePref(val.docs[0].get('name') as String);
        LocalPref.setEmailPref(_email);
      });

      dynamic result =await _auth.signInWithEmailAndPassword(_email, _pass);

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
      body: isLoading?LoadingCircle():SingleChildScrollView(
        child: SizedBox(
          width: size!.width,
          height: size!.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 4),
              Flexible(
                flex: 2,
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
                flex: 7,
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.mail, color: Colors.white,),
                                hintText: "Email"),
                            style: simpleTextStyle,
                            validator: (val)=>val!.isEmpty?"Enter your email":null,
                            onChanged: (val)=>_email=val,
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                            validator: (val)=>val!.isEmpty?"Enter your password":null,
                            onChanged: (val)=>_pass=val,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                              child: Text("Forgot password?", style: simpleTextStyle)
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [
                                  Colors.blue,
                                  Colors.indigo
                                ]),
                            ),
                            child: TextButton(
                              child: Text("Sign In", style: mediumTextStyle,),
                              onPressed: signIn,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                minimumSize: Size(size!.width*0.8,0)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            child: TextButton(
                              child: Text("Sign In with Google", style: mediumTextStyle.copyWith(color: Colors.black87),),
                              onPressed: (){},
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 18),
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
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.white,fontSize: 14),
                              ),
                              GestureDetector(
                                child: Text(
                                  "Register now!",
                                  style: TextStyle(color:Colors.white,fontSize: 14,decoration: TextDecoration.underline),
                                ),
                                onTap: (){widget.toggleView();},
                              ),
                            ],
                          ),
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
