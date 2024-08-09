import 'package:awesome_dialog/awesome_dialog.dart'; // استيراد مكتبة الحوارات المميزة
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة مصادقة فايربيز
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر لتصميم واجهات Android

import '../costmertextfiled.dart'; // استيراد حقل النص المخصص

// تعريف واجهة تسجيل الدخول
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState(); // إنشاء حالة واجهة تسجيل الدخول
}

// تعريف حالة واجهة تسجيل الدخول
class _loginState extends State<login> {
  TextEditingController email =
      TextEditingController(); // متحكم النص للبريد الإلكتروني
  TextEditingController password =
      TextEditingController(); // متحكم النص لكلمة المرور
  GlobalKey<FormState> formstate =
      GlobalKey(); // مفتاح النموذج للتحقق من صحة الإدخال
  bool isloading = false; // متغير لحالة التحميل

  TextEditingController name =
      TextEditingController(); // متحكم النص للاسم (غير مستخدم هنا)

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
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 7),
              width: 500,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(90)),
              child: isloading
                  ? Center(child: CircularProgressIndicator()) // مؤشر التحميل
                  : ListView(children: [
                      // محتوى النموذج
                      Column(
                        children: [
                          // صورة الترحيب
                          Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.amber,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "images/welcom.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ))
                        ],
                      ),
                      // عنوان النموذج
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Enter your personal information ",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      // حقل إدخال البريد الإلكتروني
                      costmer(
                        iconn: Icons.email,
                        namee: "Enter your Email",
                        title: "Email",
                        mycontroler: email,
                        validator: (val) {
                          if (val == '') {
                            // ignore: avoid_print
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
                      // رابط نسيان كلمة المرور
                      Container(
                        margin: EdgeInsets.only(left: 195, right: 20, top: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.purple[600],
                            borderRadius: BorderRadius.circular(60)),
                        child: InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: "Password Reset",
                              desc:
                                  "A message has been sent to your email to reset your password. Please check it",
                              btnOkOnPress: () async {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                              },
                            )..show();
                          },
                          child: Text(
                            "Forget Password ?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      // رابط التسجيل
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            child: Row(
                              children: [
                                Text(
                                  "Dont Have An Account",
                                  style: TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("register");
                                  },
                                  child: Text(
                                    "Sign in Now",
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // زر تسجيل الدخول
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.purple[600],
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {try {
                                isloading = true;
                                setState(() {});

                                final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
                                isloading = false;setState(() {});

                                if (credential.user!.emailVerified) {Navigator.of(context)
                                      .pushReplacementNamed("homepage");
                                } else {
                                  // حوار تأكيد البريد الإلكتروني
                                  AwesomeDialog(
                                    context: context, dialogType: DialogType.warning, animType: AnimType.rightSlide,
                                    title: "Verify email",
                                    desc: 'A message has been sent to your email. Please go to it and follow the steps to confirm your email',
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              } on FirebaseAuthException catch (e) {
                                isloading = false;setState(() {});

                                if (e.code == 'user-not-found') {print("================");
                                  AwesomeDialog(
                                    context: context, dialogType: DialogType.warning, animType: AnimType.rightSlide,
                                    title: "user not found",
                                    btnOkOnPress: () {},
                                  )..show();
                                } else if (e.code == 'wrong-password') {
                                  print('Wrong password provided for that user.');
                                  AwesomeDialog(
                                    context: context, dialogType: DialogType.warning, animType: AnimType.rightSlide,
                                    title: "The password is incorrect",
                                    btnOkOnPress: () {},
                                  )..show();
                                } else {
                                  AwesomeDialog(
                                    context: context, dialogType: DialogType.warning, animType: AnimType.rightSlide,
                                    title: "Incorrect data",
                                    desc:
                                    "The data you entered is incorrect, please check it",
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                                ;
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ),
                    ]),
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
