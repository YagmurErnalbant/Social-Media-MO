import Map "mo:base/HashMap"; // for keys and values
import Hash "mo:base/Hash"; // for algorithmic functions
import Nat "mo:base/Nat"; // for integers
import Iter "mo:base/Iter"; // to create and manipulate iterrators
import Text "mo:base/Text"; //  for working with text data and performing operations on text values
import Time "mo:base/Time"; // time-related operations
import Principal "mo:base/Principal"; // manage canister identities and interact with other canisters

actor SocialMedia {
  type Post = {
    author : Principal;
    content : Text;
    timestamp : Time.Time;
  };

  func natHash (n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var posts = Map.HashMap<Nat, Post>(0, Nat.equal, natHash); // HashMap which the post IDs relate to
  var nextId : Nat = 0; // the variable that holds the next post's ID

  // return all posts
  public query func getPosts() : async [(Nat, Post)] {
    // the query func that returns all posts
    Iter.toArray(posts.entries()); // transform each post in HashMap to an array
  };

  // func for adding a new post
  public shared (msg) func addPost(content : Text) : async Text {
    // the func that adds a new post
    let id = nextId; // creating new post ID
    posts.put(id, { author = msg.caller; content = content; timestamp = Time.now() }); // add the post to HashMap
    nextId += 1; // increment the ID of the next post
    "Post added successfully. The post ID: " # Nat.toText(id); // return result text
  };

  // view a certain post
  public query func viewPost(id : Nat) : async ?Post {
    // the func that returns a certain post
    posts.get(id); // returns it with the post ID
  };
// clear all posts
  public func clearPosts() : async () {
    // the func that clears all posts
    for (key : Nat in posts.keys()) {
      // takes all keys within HashMap
      ignore posts.remove(key); // clears posts
    };
  };
 
  // delete a post
  public func deletePost(id : Nat) : async Text {
    switch (posts.get(id)) {
      case (?post) {
          ignore posts.remove(id);
          "Post deleted successfully.";
        };
      case null {
        "Error: Post not found.";
      };
    };
  };
   
  public func editPost(id : Nat, newContent : Text) : async Text {
  switch (posts.get(id)) {
    case (?post) {
      posts.put(id, { author = post.author; content = newContent; timestamp = post.timestamp });
      "Edit successful.";
    };
    case null {
      "Error: Post not found.";
    };
  }
};
};
