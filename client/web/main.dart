import 'dart:html';
import 'dart:async';
import 'dart:convert';

void main() {
  var formInput  = querySelector("#form-input");
  var formSubmit = querySelector("#form-submit");
  var formClearAll  = querySelector("#form-clearall");
  var formText   = querySelector("#form-text");
  var posts      = querySelector("#posts");
  
  // Fetch list of posts
  getPosts().then((response) => addPostsToDOM(posts, response)); 
  
  // Submit data
  formSubmit.onClick.listen((e) {
    e.preventDefault();
    HttpRequest.request("/posts/add", method: "POST", 
      requestHeaders: {"Content-Type": "application/json"},
      sendData: JSON.encode({"name": formInput.value, "message": formText.value}))
    .then((response) {
      logResponse(response.responseText);
      getPosts().then((response) => addPostsToDOM(posts, response));
    }).catchError((e) => logResponse("${e}"));
  });
  
  // Remove all posts
  formClearAll.onClick.listen((e) {
    e.preventDefault();
    deletePosts().then((response) { 
      logResponse(response);
      getPosts().then((response) => addPostsToDOM(posts, response));
    });
  });
}

void logResponse(String response) {
  window.console.log(response);
}

void addPostsToDOM(var posts, String response) {
  var responseList = JSON.decode(response);
  posts.children.clear();
  responseList.forEach((postMap) {
    posts.append(new ParagraphElement()
      ..text = "${postMap["name"]} - ${postMap["message"]}");
  });
}

Future<String> getPosts() {
  var c = new Completer();
  HttpRequest.request("/posts/list", method: "GET").then((response) {
    c.complete(response.responseText); 
  }).catchError((e) {
    logResponse(e);
    c.complete("");
  });
  
  return c.future;
}

Future deletePosts() {
  var c = new Completer();
  HttpRequest.request("/posts/delete", method: "DELETE").then((response) {
    c.complete(response.responseText); 
  }).catchError((e) {
    logResponse(e);
    c.complete("");
  });
    
  return c.future;
}
