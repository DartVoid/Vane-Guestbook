part of server;

String collectionName = "posts";

class Posts extends Vane {
  /// Find all posts in collection "posts"
  @Route("/posts", method: GET)
  Future list() {
    log.info("Guestbook : Posts.list()");

    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.find().toList().then((data) {
        log.info("Got ${data.length} post(s)");
        log.info("${data}");
        close(data);
      }).catchError((e) {
        log.warning("Unable to get post(s): ${e}");
        close(new List());
      });
    }).catchError((e) {
      log.warning("Unable to get post(s): ${e}");
      close(new List());
    });

   return end;
  }

  /// Add post to collection "posts"
  @Route("/posts", method: POST)
  Future add() {
    log.info("Guestbook : Posts.add()");

    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.insert({"name": json["name"], "message": json["message"]}).then((data) {
        log.info("Added post: $json");
        log.info("${data}");
        close("Added post: $json");
      }).catchError((e) {
        log.warning("Unable to save post: ${e}");
        close("Unable to save post");
      });
    }).catchError((e) {
      log.warning("Unable to save post: ${e}");
      close("Unable to save post");
    });

    return end;
  }

  /// Delete all posts in collection "posts"
  @Route("/posts", method: DELETE)
  Future delete() {
    log.info("Guestbook : Posts.delete()");

    mongodb.then((mongodb) {
      var coll = mongodb.collection(collectionName);
      coll.remove().then((data) {
        log.info("Removed ${data["n"]} posts");
        log.info("${data}");
        close("Removed ${data["n"]} posts");
      }).catchError((e) {
        log.warning("Unable to delete posts: ${e}");
        close("Unable to delete posts");
      });
    }).catchError((e) {
      log.warning("Unable to delete posts: ${e}");
      close("Unable to delete posts");
    });

    return end;
  }
}

