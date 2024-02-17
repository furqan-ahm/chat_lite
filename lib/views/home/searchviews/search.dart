
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/constants.dart';
import 'package:e2ee_chat/services/database_service.dart';
import 'package:flutter/material.dart';
import 'search_tile.dart';


class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {

  final DatabaseService _db=DatabaseService();

  QuerySnapshot? searchSnapshot;

  String uname='';
  Size? size;

  Widget searchList(context){
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, int index){
        return SearchTile(
            userName: searchSnapshot!.docs[index].get('name'),
            email: searchSnapshot!.docs[index].get('email'),
            context: context,
        );
      },
    );
  }

  ///calling search
  initiateSearch( ){
    _db.getUserByUsername(uname).then(

          (val){setState(() {
            searchSnapshot=val;
          });}
    );

  }

  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text('Looking for Someone?',style: simpleTextStyle,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10,0,10,8),
              child: TextField(
                style: simpleTextStyle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:Colors.white12,
                  hintText: 'Search by username',
                  hintStyle: const TextStyle(
                      color: Colors.white
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white, width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black12, width: 2)
                  ),
                  suffixIcon: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white12),
                    ),
                    child: Icon(Icons.search_rounded, color: Colors.white,),
                    onPressed: initiateSearch,
                  )
                ),
              onChanged: (val)=>uname=val,
              onSubmitted: (val){initiateSearch();},
              ),
            ),
            searchSnapshot==null?SizedBox():searchList(context)
          ],
        ),
      ),
    );
  }
}


