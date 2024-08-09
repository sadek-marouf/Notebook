import 'package:awesome_dialog/awesome_dialog.dart'; // استيراد مكتبة الحوارات
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة فايرستور
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة توثيق فايربيز
import 'package:share/share.dart'; // استيراد مكتبة المشاركة

import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر

import '../auth/login.dart'; // استيراد شاشة تسجيل الدخول
import '../costmertextfiled.dart'; // استيراد حقل النص المخصص
import 'addnote.dart'; // استيراد شاشة إضافة ملاحظة
import 'edit.dart'; // استيراد شاشة تعديل ملاحظة

// واجهة عرض الملاحظات
class noteview extends StatefulWidget {
  final String categoryid; // معرف الفئة

  noteview({super.key, required this.categoryid});

  @override
  State<noteview> createState() => _noteviewState();
}

// حالة واجهة عرض الملاحظات
class _noteviewState extends State<noteview> {
  List<QueryDocumentSnapshot> data = []; // قائمة لتخزين الملاحظات
  bool loading = true; // حالة التحميل

  // دالة لجلب البيانات من فايرستور
  getDate() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryid)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getDate(); // جلب البيانات عند التهيئة
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // زر إضافة ملاحظة
        floatingActionButton: Container(
            decoration: BoxDecoration(
                color: (light) ? Colors.purple[600] : Colors.black87,
                borderRadius: BorderRadius.circular(60)),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            addNote(docid: widget.categoryid)),
                        (route) => false);
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
            )),
        // الدرج الجانبي
        endDrawer: Drawer(
          child: Container(
            color: (light) ? Colors.white : Colors.grey[700],
            padding: EdgeInsets.only(left: 10, right: 10, top: 50),
            child: Column(
              children: [



                Container(
                    margin: EdgeInsets.all(20),
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "images/welcom.jpg",
                        fit: BoxFit.cover,
                      ),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      alignment: Alignment.topLeft,
                      child: Switch(
                        value: light,
                        onChanged: (value) {
                          setState(() {
                            light = value;
                          });
                        },
                        activeThumbImage: AssetImage("images/light.jpg"),
                        inactiveThumbImage: AssetImage("images/dark.jpg"),
                      ),
                    ), Text("Night mode" ,style: TextStyle( fontSize: 20,color: (light) ? Colors.black87:Colors.white,fontWeight: FontWeight.bold ),),
                  ],
                ),


                // زر تسجيل الخروج
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red, borderRadius: BorderRadius.circular(60)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  margin: EdgeInsets.only(top: 90),
                  height: 40,
                  child: InkWell(
                      onTap: () {
                        try {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
                        } catch (e) {print("=================$e================");}
                      },
                      child: Row(
                        children: [
                          Text(
                            "Log out ",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.logout),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  " Note",
                  style: TextStyle(
                      fontSize: 30,
                      color: (light) ? Colors.purple : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        // جسم الشاشة
        body: WillPopScope(
          child: loading == true
              ? Center(child: CircularProgressIndicator()) // مؤشر التحميل
              : Container(
            color: (light) ? Colors.purple[200] : Colors.grey[700],
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        width: 200,
                        decoration: BoxDecoration(
                            color: (light) ? Colors.purple[200] : Colors.grey[700],
                            borderRadius: BorderRadius.circular(60)),
                        child: Card(
                          child: Column(
                            children: [
                              // زر القائمة المنبثقة
                              Container(alignment: Alignment.centerLeft,
                                child: PopupMenuButton(itemBuilder: (context) => [
                                  PopupMenuItem(child: MaterialButton(onPressed: (){
                                    Share.share(data[i]['note']);
                                  },child: Icon(Icons.share),))
                                ]),
                              ),

                              // عرض الملاحظة
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => editNote(
                                          notedocid: data[i].id,
                                          catrgorydocid: widget.categoryid,
                                          val: data[i]['note'])));
                                },
                                onLongPress: () {
                                  // حوار التأكيد على الحذف
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.rightSlide,
                                    title: "Delete This Note ?",
                                    desc: 'delete',
                                    btnOkOnPress: () async {
                                      await FirebaseFirestore.instance
                                          .collection('category')
                                          .doc(widget.categoryid)
                                          .collection("note")
                                          .doc(data[i].id)
                                          .delete();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => noteview(
                                                  categoryid: widget.categoryid)),
                                              (route) => false);
                                    },
                                  ).show();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(
                                        data[i]["note"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, mainAxisExtent: 200))
              ],
            ),
          ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("homepage", (route) => false);
            return Future(() => false);
          },
        ));
  }
}
