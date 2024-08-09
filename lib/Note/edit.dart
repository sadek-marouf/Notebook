import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة فايرستور
import 'package:flutter/cupertino.dart'; // استيراد مكتبة كوبرتينو
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر

import '../costmertextfiled.dart'; // استيراد حقل النص المخصص
import 'noteview.dart'; // استيراد عرض الملاحظة

class editNote extends StatefulWidget {
  final String notedocid; // معرف المستند للملاحظة
  final String val; // قيمة الملاحظة
  final String catrgorydocid; // معرف المستند للفئة

  editNote(
      {super.key,
        required this.notedocid,
        required this.catrgorydocid,
        required this.val});

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  @override
  void setState(VoidCallback fn) {
    note.text = widget.val; // تعيين قيمة النص الملاحظة من المعامل
    super.setState(fn);
  }

  TextEditingController note = TextEditingController(); // متحكم النص للملاحظة
  GlobalKey<FormState> formState = GlobalKey<FormState>(); // مفتاح النموذج
  bool isloading = false; // متغير لحالة التحميل

  // دالة تعديل الملاحظة
  editnote() async {
    CollectionReference notee = FirebaseFirestore.instance
        .collection('category')
        .doc(widget.catrgorydocid)
        .collection("note");

    if (formState.currentState!.validate()) {
      try {
        await notee.doc(widget.notedocid).update({"note": note.text});

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => noteview(categoryid: widget.catrgorydocid),
            ),
                (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {});

        print("==========$e=======");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.val; // تعيين النص من المعامل عند التهيئة
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose(); // التخلص من المتحكم عند التخلص من الحالة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Note",
            style:
            TextStyle(color: (light) ? Colors.purple[600] : Colors.white),
          ),
        ),
        body: Stack(
          children: [
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
                  color: (light) ? Colors.white : Colors.grey[500],
                ),
                child: Column(
                  children: [
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: TextFormField(
                        controller: note,
                        minLines: 2, //  عدد الأسطر الدنيا
                        maxLines: 10, //  عدد الأسطر القصوى
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: "edit your note",
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
                            focusColor: Colors.purple[600],
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: BorderRadius.circular(60))),
                      ),
                    ),
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                            (light) ? Colors.purple[600] : Colors.black87,
                            borderRadius: BorderRadius.circular(50)),
                        child: MaterialButton(
                          onPressed: () {
                            editnote(); // استدعاء دالة تعديل الملاحظة
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
