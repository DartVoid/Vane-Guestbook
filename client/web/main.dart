import 'dart:html';
import 'dart:async';
import 'dart:convert';

void main() {
  InputElement formName     = querySelector("#form-input-name");
  TextAreaElement formMess  = querySelector("#form-input-message");
  
  ButtonElement formSubmit    = querySelector("#form-submit");
  ButtonElement formClearAll  = querySelector("#form-clear-all");
  
  DivElement respWrap = querySelector("#response-wrapper");
  DivElement formResp = querySelector("#response");
  
  // Fetch list of posts
  getPosts().then((response) => addPostsToDOM(formResp, response)); 
  
  // Submit data
  formSubmit.onClick.listen((e) {
    e.preventDefault();
    HttpRequest.request("/posts/add", method: "POST", 
      requestHeaders: {"Content-Type": "application/json"},
      sendData: JSON.encode({"name": formName.value, "message": formMess.value}))
    .then((response) {
      getPosts().then((response) => addPostsToDOM(formResp, response));
    }).catchError((e) {
      print("Unable to add post");
    });
  });
  
  // Remove all posts
  formClearAll.onClick.listen((e) {
    e.preventDefault();
    formResp.children.clear();
    
    deletePosts().then((response) { 
      print(response);
      getPosts().then((response) => addPostsToDOM(formResp, response));
    });
  });
}

void addPostsToDOM(DivElement posts, String response) {
  if(response != "") {
    List responseList = JSON.decode(response);
    posts.children.clear();
    responseList.forEach((Map post) {
      
      DivElement postDiv = new DivElement()
        ..classes = ["content-offset", "well"]
        ..children.addAll(
        [
          new ParagraphElement()
            ..classes.add("text-bold")
            ..text = "${post["name"]}",
            
          new ParagraphElement()
            ..text = "${post["message"]}"
        ]
      );
      
      posts.append(postDiv);
      
    });
  }
}

Future<String> getPosts() {
  var c = new Completer();
  HttpRequest.request("/posts/list", method: "GET").then((response) {
    c.complete(response.responseText); 
  }).catchError((e) {
    print("Unable to get posts");
    c.complete("");
  });
  
  return c.future;
}

Future deletePosts() {
  var c = new Completer();
  HttpRequest.request("/posts/delete", method: "DELETE").then((response) {
    c.complete(response.responseText); 
  }).catchError((e) {
    print("Unable to delete posts");
    c.complete("");
  });
    
  return c.future;
}

