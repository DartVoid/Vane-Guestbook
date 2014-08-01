import 'dart:html';
import 'dart:async';
import 'dart:convert';

class PostService {
  String serviceUrl;

  PostService({this.serviceUrl}) {
    if(serviceUrl == null) serviceUrl = "";
  }

  /// Get all posts
  Future list() {
    var c = new Completer();

    HttpRequest.request("$serviceUrl/posts/list", method: "GET").then((response) {
      c.complete(response.responseText);
    }).catchError((e) {
      print("Unable to list posts");
      c.complete();
    });

    return c.future;
  }

  /// Add new post
  Future add(String name, String message) {
    var c = new Completer();

    HttpRequest.request("$serviceUrl/posts/add", method: "POST",
      requestHeaders: {"Content-Type": "application/json"},
      sendData: JSON.encode({"name": name, "message": message}))
    .then((response) {
      c.complete(response.responseText);
    }).catchError((e) {
      print("Unable to add post");
      c.complete();
    });

    return c.future;
  }

  /// Remove all posts
  Future remove() {
    var c = new Completer();

    HttpRequest.request("$serviceUrl/posts/remove", method: "DELETE").then((response) {
      c.complete(response.responseText);
    }).catchError((e) {
      print("Unable to delete posts");
      c.complete();
    });

    return c.future;
  }
}

void main() {
  // Form input
  InputElement formName     = querySelector("#form-input-name");
  TextAreaElement formMess  = querySelector("#form-input-message");

  // Form actions
  ButtonElement formSubmit    = querySelector("#form-submit");
  ButtonElement formClearAll  = querySelector("#form-clear-all");

  // Response
  DivElement respWrap = querySelector("#response-wrapper");
  DivElement formResp = querySelector("#response");

  // Init service
  PostService service = new PostService();

  // Get list of posts on load
  service.list().then((response) => addToDom(formResp, response));

  // Catch form submit
  formSubmit.onClick.listen((e) {
    e.preventDefault();
    service.add(formName.value, formMess.value).then((response) {
      print(response);

      // Reload post list
      service.list().then((response) => addToDom(formResp, response));
    });
  });

  // Clear all
  formClearAll.onClick.listen((e) {
    e.preventDefault();

    // Clear response output
    formResp.children.clear();

    // Remove posts
    service.remove().then((response) => print(response));
  });
}

// Add posts to the DOM
void addToDom(DivElement formResp, String response) {
  if(response != "") {
    formResp.children.clear();
    List jsonData = JSON.decode(response);

    jsonData.forEach((post) {
      formResp.appendHtml('''
<div class="content-offset well">
  <p><strong>${post["name"]}</strong></p>
  <p>${post["message"]}</p>
</div>
''');
    });
  }
}

