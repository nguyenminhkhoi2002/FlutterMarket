import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class PersonalUser{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  String? id;
  String? photoUrl;
  String? name;
  String email;
  String password;
  List<int> cart = [];


  PersonalUser( this.email,this.password);

 
  String? get getName => name;
  String get getEmail => email;
  get getPassword => password;
  set setName(String name) => this.name = name;
  set setEmail(String email) => this.email = email;
  
  Future<int> registerUser(String name)async {
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: this.email, password: this.password);
      var user = userCredential.user;
      this.id = user!.uid ;
      await user.updateDisplayName(name);
      List<int> cart1 = [-1];
      await ref.child('users').update({
        '$id': cart1,
      });
      return 0;
    }
    on FirebaseAuthException catch(e){
      if (e.code =='weak-password'){
        return 1;
        
    } else if(e.code=='email-already-in-use'){
      return 2;
    }
   
    }
    catch(e){
      print(e);
      return 3;
    }
  
  return 3;
  }
  Future<int> signIn() async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: this.email, password: this.password);
      var user = userCredential.user;
      this.id = user!.uid ;
      this.name = user.displayName;
      DataSnapshot snapshot = await ref.child('users/$id').get();
      this.cart=List.from(snapshot.value as List<dynamic>);
      
     

      return 0;
    }

    on FirebaseAuthException catch(e){
      if (e.code =='user-not-found'){
        return 1;
        
    } else if(e.code=='wrong-password'){
      return 2;
    }
   
    }
    catch(e){
      print(e);
      return 3;
    }
    return 3;
  }
  Future<void> addToCart(int value) async{
     DatabaseReference refupdata = FirebaseDatabase.instance.ref("users");
     this.cart.add(value);
      await refupdata.update({
        '$id':this.cart
      });
  }
  Future<void> removeFromCart(int value) async{
     DatabaseReference refupdata = FirebaseDatabase.instance.ref("users");
     this.cart.remove(value);
      await refupdata.update({
        '$id':this.cart
      });
  }
}
