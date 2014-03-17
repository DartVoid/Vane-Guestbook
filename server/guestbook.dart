import 'dart:async';
import 'package:vane/vane.dart';
import 'package:mongo_dart/mongo_dart.dart';

String collectionName = "posts";

class GetAllPosts extends Vane {
  Future main() {
    mongodb.open().then((c) {
      DbCollection coll = mongodb.collection(collectionName);
      coll.find().toList().then((data) {
        log.info(data);
        close(data);
      }).catchError((e) {
        log.warning(e);
        close(new List());
      });
    }).catchError((e) {
      log.warning(e);
      close(new List());
    });
    
   return end;
  }
}

class SavePost extends Vane {
  Future main() {
    mongodb.open().then((c) {
      DbCollection coll = mongodb.collection(collectionName);
      coll.insert({"name": json["name"], "message": json["message"]}).then((data) {
        log.info(data);
        close("Added post: $json");
      }).catchError((e) {
        log.warning(e);
        close("Unable to save post");
      });
    }).catchError((e) {
      log.warning(e);
      close("Unable to save post");
    });
    
    return end;
  }
}

class DeletePosts extends Vane {
  Future main() {
    mongodb.open().then((c) {
      DbCollection coll = mongodb.collection(collectionName);
      coll.remove().then((data) {
        log.info(data);
        close("Removed ${data["n"]} posts");
      }).catchError((e) {
        log.warning(e);
        close("Unable to delete posts");
      });
    }).catchError((e) {
      log.warning(e);
      close("Unable to delete posts");
    });
    
    return end;
  }
}
