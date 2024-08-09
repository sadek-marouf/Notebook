import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore من Firebase
import 'package:flutter/material.dart'; // استيراد مكتبة واجهات المستخدم من Flutter

import '../costmertextfiled.dart'; // استيراد مكونات إضافية (لم تُستخدم في هذا المثال)
import 'noteview.dart'; // استيراد صفحة عرض الملاحظات

// تعريف واجهة StatefulWidget لإضافة ملاحظة جديدة
class addNote extends StatefulWidget {
  final String docid; // تعريف معرف الوثيقة

  const addNote(
      {super.key, required this.docid}); // مُنشئ للواجهة مع المعرف المطلوب

  @override
  State<addNote> createState() =>
      _addNoteState(); // إنشاء الحالة المقترنة بالواجهة
}

class _addNoteState extends State<addNote> {
  TextEditingController note =
      TextEditingController(); // متحكم لحقل النص لإدخال الملاحظة

  GlobalKey<FormState> formState =
      GlobalKey<FormState>(); // مفتاح للنموذج للتحقق من صحته
  bool isloading = false; // متغير لتحميل الحالة

  // دالة لإضافة الملاحظة إلى الفئة
  addGategory() async {
    CollectionReference Note = FirebaseFirestore.instance
        .collection('category') // الوصول إلى مجموعة الفئات
        .doc(widget.docid) // تحديد الوثيقة باستخدام المعرف
        .collection("note"); // الوصول إلى مجموعة الملاحظات داخل الفئة

    if (formState.currentState!.validate()) {
      // التحقق من صحة النموذج
      try {
        DocumentReference response =
            await Note.add({"note": note.text}); // إضافة الملاحظة إلى Firestore

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => noteview(
                  categoryid: widget.docid), // الانتقال إلى صفحة عرض الملاحظات
            ),
            (route) => false); // إزالة جميع الصفحات السابقة من المكدس
      } catch (e) {
        isloading = false; // تعيين حالة التحميل إلى false في حالة حدوث خطأ
        setState(() {}); // تحديث واجهة المستخدم

        print(e); // طباعة الخطأ في وحدة التحكم
      }
    }
  }

  @override
  void dispose() {
    // تدمير المتحكم عند التخلص من الواجهة
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Note", // عنوان التطبيق
            style: TextStyle(
                color: (light)
                    ? Colors.purple[600]
                    : Colors.white), // تغيير اللون بناءً على الحالة
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: (light) ? Colors.purple[600] : Colors.grey[850],
              // تغيير لون الخلفية بناءً على الحالة
              width: 1000,
              height: 1000,
            ),
            Form(
              key: formState, // ربط النموذج بالمفتاح
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                // تحديد الهوامش
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                // تحديد الحشوة
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60), // تدوير الزوايا
                    color: (light) ? Colors.white : Colors.grey[500]),
                // تغيير اللون بناءً على الحالة
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      // حشوة داخلية للحقل النصي
                      child: TextFormField(
                        controller: note, // ربط المتحكم بالحقل النصي
                        decoration: InputDecoration(
                            hintText: " Enter your Note",
                            // نص الإرشادي للحقل النصي
                            fillColor: Colors.grey[300],
                            // لون الخلفية للحقل النصي
                            filled: true,
                            // تحديد أن الحقل النصي مملوء
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60)),
                                // تدوير الزوايا
                                borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 197, 103, 97),
                                  // لون الحدود
                                  width: 5,
                                )),
                            focusColor: Colors.purple[600],
                            // لون التركيز
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                // لون الحدود عند التركيز
                                borderRadius: BorderRadius.circular(
                                    60))), // تدوير الزوايا عند التركيز
                      ),
                    ),
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                (light) ? Colors.purple[600] : Colors.grey[850],
                            // تغيير لون الزر بناءً على الحالة
                            borderRadius: BorderRadius.circular(50)),
                        // تدوير الزوايا للزر
                        child: MaterialButton(
                          onPressed: () {
                            addGategory(); // استدعاء دالة إضافة الفئة عند الضغط على الزر
                          },
                          child: Text(
                            "Add", // نص الزر
                            style: TextStyle(
                                color: Colors.white), // لون النص داخل الزر
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
