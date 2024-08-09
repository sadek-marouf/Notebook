import 'package:awesome_dialog/awesome_dialog.dart'; // استيراد مكتبة للحوارات الجميلة
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة فايرستور
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة مصادقة فايربيس
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر
import 'package:nnoteboke/update.dart'; // استيراد ملف التحديث
import 'package:nnoteboke/add.dart'; // استيراد ملف الإضافة

import 'Note/noteview.dart'; // استيراد ملف عرض الملاحظات
import 'costmertextfiled.dart'; // استيراد ملف حقل النص المخصص

// تعريف واجهة الصفحة الرئيسية
class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() =>
      _HomepageState(); // إنشاء حالة واجهة الصفحة الرئيسية
}

// تعريف حالة واجهة الصفحة الرئيسية
class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = []; // قائمة لتخزين البيانات
  bool loading = false; // متغير لتحميل الحالة

  // دالة لجلب البيانات من فايرستور
  getDate() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('category')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs); // إضافة المستندات المسترجعة إلى القائمة
    loading = false; // تعيين حالة التحميل إلى false
    setState(() {}); // تحديث حالة الواجهة
  }

  @override
  void initState() {
    getDate(); // استدعاء دالة جلب البيانات عند تهيئة الواجهة
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // زر عائم لإضافة ملاحظة جديدة
      floatingActionButton: Container(
          decoration: BoxDecoration(
              color: (light) ? Colors.purple[600] : Colors.black87,
              borderRadius: BorderRadius.circular(60)),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => add())); // الانتقال إلى واجهة الإضافة
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          )),
      // القائمة الجانبية
      endDrawer: Drawer(
        child: Container(
          color: (light) ? Colors.white : Colors.grey[700],
          padding: EdgeInsets.only(left: 10, right: 10, top: 50),
          child: Column(
            children: [
              // صورة في القائمة الجانبية
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
              // زر تغيير وضع الليل والنهار
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ),
                  Text(
                    "Night mode",
                    style: TextStyle(
                        fontSize: 20,
                        color: (light) ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
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
                        FirebaseAuth.instance.signOut(); // تسجيل الخروج
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            "login",
                            (route) =>
                                false); // الانتقال إلى واجهة تسجيل الدخول
                      } catch (e) {
                        print("=================$e================");
                      }
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
      // شريط التطبيق العلوي
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                " Home",
                style: TextStyle(
                    fontSize: 30,
                    color: (light) ? Colors.purple : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.home,
                size: 30,
                color: (light) ? Colors.purple[600] : Colors.white,
              )
            ],
          ),
        ),
      ),
      // جسم التطبيق
      body: loading == true
          ? Center(
              child:
                  CircularProgressIndicator()) // عرض مؤشر التحميل إذا كانت البيانات قيد التحميل
          : Container(
              color: (light) ? Colors.purple[200] : Colors.grey[700],
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  GridView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: data.length, itemBuilder: (context, i) {
                        return InkWell(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => noteview(categoryid: data[i]
                            .id))); // الانتقال إلى واجهة عرض الملاحظة
                          },
                          onLongPress: () {
                            // حوار للاختيار بين التعديل والحذف
                            AwesomeDialog(context: context, dialogType: DialogType.question, animType: AnimType.rightSlide, title: "Choose what you want", btnCancelText: "Delete",
                              btnOkText: "Edit", btnOkOnPress: () {Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => editcategory(oldname: data[i]['name'], doce: data[i].id))); // الانتقال إلى واجهة التعديل
                              },
                              btnCancelOnPress: () {
                                FirebaseFirestore.instance
                                    .collection('category')
                                    .doc(data[i].id)
                                    .delete(); // حذف الفئة
                                Navigator.of(context).pushReplacementNamed(
                                    'homepage'); // إعادة تحميل الصفحة الرئيسية
                              },
                            ).show();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: (light)
                                    ? Colors.purple[200]
                                    : Colors.grey[700],
                                borderRadius: BorderRadius.circular(60)),
                            child: Card(
                              color: (light) ? Colors.white : Colors.grey[850],
                              child: Column(
                                children: [
                                  // صورة الفئة
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 120,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: Image.asset(
                                        'images/file.jpg',
                                        fit: BoxFit.cover,),),),
                                  // اسم الفئة
                                  Text(
                                    data[i]["name"], style: TextStyle(color: (light)
                                            ? Colors.black87
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 200))
                ],
              ),
            ),
    );
  }
}
