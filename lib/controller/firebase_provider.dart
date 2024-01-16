

import 'package:chathub/model/chat_model.dart';
import 'package:chathub/model/user_model.dart';
import 'package:chathub/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  List<UserModel> users = [];
  List<UserModel> searchedusers = [];
  List<Message> messages = [];
  FirebaseAuthServices service = FirebaseAuthServices();
  ScrollController scrollController = ScrollController();

  List<UserModel> getAllUsers() {
    service.firestore.collection('users').snapshots().listen((user) {
      users = user.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      loadUsers();
      notifyListeners();
    });
    return users;
  }

  List<Message> getMessages(String currentuserid, String recieverid) {
    List ids = [currentuserid, recieverid];
    ids.sort();
    String chatroomid = ids.join("_");
    service.firestore
        .collection("chat_room")
        .doc(chatroomid)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots()
        .listen((message) {
      messages =
          message.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();
      scrollDown();
    });
    return messages;
  }

  Future<void> clearChat(String currentuserid, String recieverid) async {
    List ids = [currentuserid, recieverid];
    ids.sort();
    String chatroomid = ids.join("_");
    try {
      var snapshot = await service.firestore
          .collection("chat_room")
          .doc(chatroomid)
          .collection("messages")
          .get();

      var documents = snapshot.docs;
      for (DocumentSnapshot doc in documents) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  loadUsers() {
    searchedusers = users;
  }

  searchUser(String name) async {
    service.firestore
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: name.toLowerCase())
        .snapshots()
        .listen((event) {
      searchedusers =
          event.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      notifyListeners();
    });
    return searchedusers;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
