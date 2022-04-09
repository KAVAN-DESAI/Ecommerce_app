import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user.dart';

class DatabaseMethods {
  addProduct(productMap, String documentId) async {
    Firestore.instance
        .collection("products")
        .document(documentId)
        .setData(productMap); //add(groupMap);
  }
  getUserbyUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }
  getProductbySearchKey(String searchKey) async {
    return await Firestore.instance
        .collection("products")
        .where("searchKey", arrayContains: searchKey)
        .getDocuments();
  }

  getUserbyUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }


  static uploadUserInfo(userMap,String Name) {
    Firestore.instance.collection("users").document(Name).setData(userMap).catchError((e) {
      print(e.toString());
    });
  }
  getProduct()  {
    return Firestore.instance
        .collection("products")
        .snapshots();
  }
  getUserInfo(String userEmail)async{
    return await Firestore.instance
        .collection("users").where("email", isEqualTo: userEmail)
        .getDocuments();
  }
  getUserInfoSnapshot(String userEmail){
    Firestore.instance
        .collection("users").where("email", isEqualTo: userEmail)
        .snapshots();
  }

  updateCart(productMap,String title,List cartList,String name)async{
    var doc_ref = await Firestore.instance.collection("users").where("name" ,isEqualTo: name).getDocuments();
    doc_ref.documents.forEach((result) {
        Firestore.instance.collection("users").document(result.documentID).collection("cart").add(productMap);
      });
    Firestore.instance.collection("products").document(title).updateData({"cartList": cartList});
  }

  getUser(){
    return Firestore.instance.collection("users").getDocuments();
  }

  addProductInfo(String documentId, eventMap) {
    Firestore.instance.collection("products").document(documentId).setData(eventMap).catchError((e) {
      print(e.toString());
    });
  }
}
