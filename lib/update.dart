import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة فايرستور
import 'package:flutter/cupertino.dart'; // استيراد مكتبة كوبرتينو
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر
import 'package:flutter/widgets.dart'; // استيراد مكتبة الويجتس

import 'costmertextfiled.dart'; // استيراد حقل النص المخصص

// واجهة تعديل الفئة
class editcategory extends StatefulWidget {
  final String doce; // معرف المستند للفئة
  final String oldname; // الاسم القديم للفئة

  const editcategory({super.key, required this.oldname, required this.doce});

  @override
  State<editcategory> createState() => _editcategoryState();
}

// حالة واجهة تعديل الفئة
class _editcategoryState extends State<editcategory> {
  TextEditingController name = TextEditingController(); // متحكم النص للاسم
  CollectionReference category =
      FirebaseFirestore.instance.collection('category'); // مرجع مجموعة الفئات

  GlobalKey<FormState> formState = GlobalKey<FormState>(); // مفتاح النموذج
  bool isloading = false; // متغير لحالة التحميل

  // دالة تحديث الفئة
  updateGategory() async {
    if (formState.currentState!.validate()) {
      try {
        await category
            .doc(widget.doce)
            .update({'name': name.text}); // تحديث الفئة في فايرستور

        Navigator.of(context).pushNamedAndRemoveUntil(
            'homepage', (route) => false); // الانتقال إلى الصفحة الرئيسية
      } catch (e) {
        isloading = false;
        setState(() {});

        print(e); // طباعة الخطأ في وحدة التحكم
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldname; // تعيين النص من المعامل عند التهيئة
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit category",
            style: TextStyle(
                color: (light)
                    ? Colors.purple[600]
                    : Colors.white), // تغيير لون النص بناءً على حالة الضوء
          ),
        ),
        body: Stack(
          children: [
            // خلفية الشاشة
            Container(
              color: (light) ? Colors.purple[600] : Colors.grey[850],
              width: 1000,
              height: 1000,
            ),
            // نموذج تحديث الفئة
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
                    // حقل إدخال النص
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            hintText: "Update the name of category",
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
                    // زر تعديل الفئة
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                (light) ? Colors.purple[600] : Colors.grey[850],
                            borderRadius: BorderRadius.circular(50)),
                        child: MaterialButton(
                          onPressed: () {
                            updateGategory(); // استدعاء دالة تحديث الفئة عند الضغط على الزر
                          },
                          child: Text(
                            "Edit",
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
