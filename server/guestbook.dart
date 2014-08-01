part of server;

class Posts extends Vane {
  // Register the application pipeline
  var pipeline = [Log, This];

  // Set the collection name
  String collectionName = "posts";

  /// List all from collection "posts"
  @Route("/posts/list", method: "GET")
  Future list() {
    mongodb.then((mongodb) {
      var postColl = mongodb.collection(collectionName);

      // Find all posts but exclude _id from the results
      postColl.find(where.excludeFields(["_id"])).toList().then((data) {
        log.info("Got ${data.length} post(s)");
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
  @Route("/posts/add", method: POST)
  Future add() {
    mongodb.then((mongodb) {
      var postColl = mongodb.collection(collectionName);

      // Insert new post with data from the pre-processed json body
      postColl.insert({"name": json["name"], "message": json["message"]}).then((data) {
        log.info("Added post: $json");
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

  /// Remove all posts in collection "posts"
  @Route("/posts/remove", method: DELETE)
  Future remove() {
    mongodb.then((mongodb) {
      var postColl = mongodb.collection(collectionName);

      // Remove all posts
      postColl.remove().then((data) {
        log.info("Removed ${data["n"]} posts");
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

