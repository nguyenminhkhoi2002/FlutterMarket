import 'package:flutter/material.dart';
import 'dart:core';
import 'PersonalUser.dart';
import 'ProductView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Data.dart';
import 'CartPage.dart';

Future<void> main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyHome());

}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Data data = Data();
  static final emailControler = TextEditingController();
  static final passwordControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Login Screen '),
          ),
          // 2 hộp để đăng nhập gồm user và password
          body: Center(
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: TextField(
                    controller: emailControler,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: ' Email ',
                      
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child:  TextField(
                    controller: passwordControler,
                    decoration: const  InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password ',
                    ),
                  ),
                ),
                // 1 nút để đăng nhập

                ElevatedButton(
                  onPressed: () async {
                    PersonalUser user=PersonalUser(emailControler.text, passwordControler.text);
                    int check=await user.signIn();
                    if (check==1){
                      showDialog(context: context, builder: ((context) => 
                      AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('User is not exist'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                      ));
                    }
                    else if(check==2){
                      showDialog(context: context, builder: ((context) => 
                      AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('Wrong password'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                      ));
                    }
                    else if(check==3){
                        showDialog(context: context, builder: ((context) => 
                      AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('uknown error'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                      ));
                    }
                    else {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  MainScreen(user: user,)),
                              );
                      
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 15))),
                  child: const Text('Login'),
                ),
                 TextButton(
                    onPressed: () {
                      data.getData();
                    },
                    child: Text(
                      'Quên mật khẩu ',
                      style: TextStyle(color: Colors.blue),
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: const Text(
                      '________Hoặc________'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  RegisterPage()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10))),
                    child: const Text(
                      'Tạo tài khoản mới',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            )
          )),
    );
  }
}

class MainScreen extends StatelessWidget {
  PersonalUser user;
  MainScreen({Key? key, required this.user }) : super(key: key);


  @override
  Widget build(BuildContext context) {
      return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.blue,
                  Colors.purple,
                ],
              ),
            ),
            accountName:  Text(user.name??'unknown'),
            accountEmail: Text(user.email),
            currentAccountPicture: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalPage()),
                );
              },
              child: const CircleAvatar(
                child: FlutterLogo(size: 42.0),
              ),
            )
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartPage(ps: user,context: context,)));
              
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body:ListView(
        children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Center( child: Text('Danh sach san pham', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),)
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ProductView(context: context,ps: user,)
            ),

          ],
      )
    );
  }
}

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
             Text('Personal Page'),
          ],
        ),
      ),
    );
  }
}
class RegisterPage extends StatelessWidget{
   RegisterPage({super.key});
  final emailControler = TextEditingController();
  final fullNameControler = TextEditingController();
  final passwordControler = TextEditingController();
  final repeatpasswordControler = TextEditingController();
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // 3 hộp để đăng kí gồm user,password và nhập lại password
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: TextField(
                controller: emailControler,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Phonenumber or email ',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: TextField(
                controller: fullNameControler,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Full Name',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextField(
                controller: passwordControler,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password ',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextField(
                controller: repeatpasswordControler,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Repeat Password',
                ),
              ),
            ),
            
            // 1 nút để đăng kí
            ElevatedButton(
              onPressed: () async {
                if (passwordControler.text != repeatpasswordControler.text) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Mật khẩu không khớp'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                }
                //thông báo đăng kí thành công và thoát khỏi màn hình đăng kí và chuyển sang màn hình đăng nhập
                else {
                  PersonalUser user=PersonalUser(emailControler.text, passwordControler.text);
                  int check=await user.registerUser(fullNameControler.text);
                  if(check==1){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text('Thong bao'),
                        content: const Text('mat khau qua yeu'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('OK'))
                        ],
                      );
                    });
                  }
                  else if(check==2){
                     showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text('Thong bao'),
                        content: const Text('email already exist'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('OK'))
                        ],
                      );
                    });

                  }
                  else if (check ==3){
                     showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Register failed, unknown error'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('OK'))
                        ],
                      );
                    });
                  }
                  else{
                     showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Đăng kí thành công '),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }, child: const Text('OK'))
                        ],
                      );
                    });
                  }

                      
                }
                
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 15))),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

}
