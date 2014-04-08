import 'dart:async';
import 'package:vane/vane.dart';

String collectionName = "posts";

class GetAllPosts extends Vane {
  Future main() {
    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.find().toList().then((data) {
        log.info(data.toString());
        close(data);
      }).catchError((e) {
        log.warning(e.toString());
        close(new List());
      });
    }).catchError((e) {
      log.warning(e.toString());
      close(new List());
    });
    
   return end;
  }
}

class SavePost extends Vane {
  Future main() {
    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.insert({"name": json["name"], "message": json["message"]}).then((data) {
        log.info(data.toString());
        close("Added post: $json");
      }).catchError((e) {
        log.warning(e.toString());
        close("Unable to save post");
      });
    }).catchError((e) {
      log.warning(e.toString());
      close("Unable to save post");
    });
    
    return end;
  }
}

class DeletePosts extends Vane {
  Future main() {
    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.remove().then((data) {
        log.info(data.toString());
        close("Removed ${data["n"]} posts");
      }).catchError((e) {
        log.warning(e.toString());
        close("Unable to delete posts");
      });
    }).catchError((e) {
      log.warning(e.toString());
      close("Unable to delete posts");
    });
    
    return end;
  }
}

