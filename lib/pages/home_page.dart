import 'package:crud_operation2/pages/add_post.dart';
import 'package:crud_operation2/pages/login_page.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Student');          // take reference (table name)
  final searchFilter = TextEditingController();             //search controller
  final editController = TextEditingController();             //edit controller


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ref.onValue.listen((event) { });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,       //back arrow
        centerTitle: true,
        backgroundColor: Colors.black26,
        title: Text('Home', style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){
            
            auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return LoginPage();
              }));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });

          }, icon: Icon(Icons.logout_outlined), 
          ),
          // SizedBox(width: 10,),
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 20,),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchFilter,                // search controller
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  
                });
              },
            ),
          ),

          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                
          //       if(!snapshot.hasData){
          //         return CircularProgressIndicator();
          //       }
          //       else{
          //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //           return ListTile(
          //             title: Text(list[index]['name']),
          //             subtitle: Text(list[index]['id']),
          //           );
          //           },
          //         );
          //       }
                
          //     },
          //   )
          // ),

          SizedBox(
            height: 20,
          ),

          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Text('Loading... please wait') ,
              query: ref, 
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('name').value.toString();

                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child('name').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    
                    trailing: PopupMenuButton(                // popup menu
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {                   // new window           
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          )
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text('Detete'),
                          )
                        ),
                      ],
                    ),

                  );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toString())){      //search filter
                  return ListTile(
                    title: Text(snapshot.child('name').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
                else{
                  return Container();
                }
              }
            ),
          ),          
        ],
      ),

      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddPostScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),


    );

  }
  
  Future<void> showMyDialog(String title, String id)async{
    editController.text = title;
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Edit'
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel')),
            
            TextButton(onPressed: (){
              Navigator.pop(context);
              ref.child(id).update({
                'name': editController.text.toLowerCase()
              }).then((value){
                Utils().toastMessage('Post Updated');
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            }, child: Text('Update')),

          ],
        );
      },
      
    );
  }
}