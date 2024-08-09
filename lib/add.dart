import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة فايرستور
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة مصادقة فايربيس
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر

import 'costmertextfiled.dart'; // استيراد ملف حقل النص المخصص

// تعريف واجهة إضافة فئة جديدة
class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState(); // إنشاء حالة واجهة إضافة فئة جديدة
}

// تعريف حالة واجهة إضافة فئة جديدة
class _addState extends State<add> {
  TextEditingController name = TextEditingController(); // متحكم نصي لاسم الفئة
  CollectionReference category = FirebaseFirestore.instance
      .collection('category'); // مرجع مجموعة الفئات في فايرستور

  GlobalKey<FormState> formState =
      GlobalKey<FormState>(); // مفتاح النموذج للتحقق من صحة النموذج
  bool isloading = false; // متغير لتحميل الحالة

  // دالة لإضافة فئة جديدة
  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        // إضافة الفئة إلى فايرستور
        DocumentReference response = await category.add(
            {"name": name.text, 'id': FirebaseAuth.instance.currentUser!.uid});

        // الانتقال إلى واجهة الصفحة الرئيسية
        Navigator.of(context)
            .pushNamedAndRemoveUntil('homepage', (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {});

        print(e); // طباعة الخطأ في وحدة التحكم
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Category",
            style:
                TextStyle(color: (light) ? Colors.purple[600] : Colors.white),
          ),
        ),
        body: Stack(
          children: [
            // خلفية الصفحة
            Container(
              color: (light) ? Colors.purple[600] : Colors.grey[850],
              width: 1000,
              height: 1000,
            ),
            Form(
              key: formState,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: (light) ? Colors.white : Colors.grey[500]),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            hintText: "Enter the name of category",
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60)),
                                borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 197, 103, 97),
                                  width: 5,
                                )),
                            focusColor:
                                (light) ? Colors.purple[600] : Colors.grey[850],
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: BorderRadius.circular(60))),
                      ),
                    ),
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                (light) ? Colors.purple[600] : Colors.grey[850],
                            borderRadius: BorderRadius.circular(50)),
                        child: MaterialButton(
                          onPressed: () {
                            addCategory(); // استدعاء دالة إضافة الفئة عند الضغط على الزر
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
