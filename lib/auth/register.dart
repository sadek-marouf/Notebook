import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة مصادقة فايربيز
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر لتصميم واجهات Android
import 'package:google_sign_in/google_sign_in.dart'; // استيراد مكتبة تسجيل الدخول باستخدام جوجل

import '../costmertextfiled.dart'; // استيراد حقل النص المخصص

// تعريف واجهة التسجيل
class regiser extends StatefulWidget {
  const regiser({super.key});

  @override
  State<regiser> createState() => _regiserState(); // إنشاء حالة واجهة التسجيل
}

// تعريف حالة واجهة التسجيل
class _regiserState extends State<regiser> {
  GlobalKey<FormState> formstate =
      GlobalKey(); // مفتاح النموذج للتحقق من صحة الإدخال

  TextEditingController email =
      TextEditingController(); // متحكم النص للبريد الإلكتروني
  TextEditingController password =
      TextEditingController(); // متحكم النص لكلمة المرور
  TextEditingController name = TextEditingController(); // متحكم النص للاسم

  //////////// تسجيل الدخول باستخدام جوجل ////////////
  Future signInWithGoogle() async {
    // بدء عملية المصادقة
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // الحصول على تفاصيل المصادقة من الطلب
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // إنشاء بيانات الاعتماد الجديدة
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // بعد تسجيل الدخول، إعادة UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil(
        'homepage', (route) => false); // الانتقال إلى الصفحة الرئيسية
  }

  /////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstate,
        child: Stack(
          children: [
            // خلفية الشاشة
            Container(
                height: 1000,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                )),
            // حاوية محتوى النموذج
            Container(
              height: 1000,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
              padding: const EdgeInsets.only(top: 80),
              width: 500,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(90)),
              child: ListView(
                children: [
                  // عنوان النموذج
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // حقول الإدخال
                  Container(
                      child: Column(
                    children: [
                      // حقل إدخال البريد الإلكتروني
                      costmer(
                        iconn: Icons.email,
                        namee: "Enter your Email",
                        title: "Email",
                        mycontroler: email,
                        validator: (val) {
                          if (val == '') {
                            return "Cant be empty";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // حقل إدخال كلمة المرور
                      costmer(
                        iconn: Icons.password,
                        namee: "Enter your password",
                        title: "Password",
                        mycontroler: password,
                        validator: (val) {
                          if (val == '') {
                            return "Cant be empty";
                          }
                        },
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  // زر التسجيل
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.purple,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          Navigator.of(context).pushReplacementNamed("login"); // الانتقال إلى واجهة تسجيل الدخول
                          FirebaseAuth.instance.currentUser!.sendEmailVerification(); // إرسال بريد التحقق
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "weak password",
                              desc:
                                  "Weak password. Use letters and numbers together",
                              btnOkOnPress: () {},
                            )..show();
                            ;
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              desc:
                                  "The account already exists for that email.",
                              btnOkOnPress: () {},
                            )..show();
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                  ),
                  // زر تسجيل الدخول باستخدام جوجل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: 250,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.red,
                        ),
                        child: InkWell(
                            onTap: () {
                              signInWithGoogle();
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "images/go.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  // رابط تسجيل الدخول للمستخدمين الحاليين
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    child: Row(
                      children: [
                        Text(
                          "Have Account?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          child: Container(
                            width: 80,
                            alignment: Alignment.center,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60)),
                            child: Text(
                              "Login now",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[600]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // صورة إضافية في أعلى الشاشة
            Container(
                height: 140,
                margin: EdgeInsets.symmetric(horizontal: 110),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60)),
                  color: Colors.purple[600],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    "images/welcom.jpg",
                    fit: BoxFit.cover,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
