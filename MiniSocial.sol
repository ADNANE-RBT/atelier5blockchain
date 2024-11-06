// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {
    // 1. Structure Post contenant un message et l'adresse de l'auteur
    struct Post {
        string message;
        address author;
        // likes and timestamps "mimicking snaps"
        uint likes;
        uint timestamp;
    }
        // Structure for Comments
    struct Comment {
        string text;
        address commenter;
        uint timestamp;
    }

    // 2. Tableau dynamique pour stocker les posts
    Post[] public posts;
    mapping(uint => Comment[]) public postComments; // Mapping post index to array of comments
    mapping(uint => mapping(address => bool)) public hasLiked; // Prevents double likes per user per post


    // 3. Fonction pour publier un message
    // Publish a new post with 24-hour timer
    function publishPost(string memory _message) public {
        posts.push(Post({
            message: _message,
            author: msg.sender,
            likes: 0,
            timestamp: block.timestamp // Current block timestamp
        }));
    }
     // Like a post
    function likePost(uint index) public {
        require(index < posts.length, "Invalid index");
        require(!hasLiked[index][msg.sender], "You have already liked this post");

        Post storage post = posts[index];
        require(block.timestamp < post.timestamp + 1 days, "Post has expired"); // Ensure post is within 24 hours

        post.likes += 1;
        hasLiked[index][msg.sender] = true;
    }

    // Add a comment to a post
    function addComment(uint index, string memory _comment) public {
        require(index < posts.length, "Invalid index");

        Post memory post = posts[index];
        require(block.timestamp < post.timestamp + 1 days, "Post has expired"); // Ensure post is within 24 hours

        postComments[index].push(Comment({
            text: _comment,
            commenter: msg.sender,
            timestamp: block.timestamp
        }));
    }

    // 4. Fonction pour consulter un post spécifique par index
    // Get post data along with likes, author, and comments if post is within 24 hours
    function getPost(uint index) public view returns (string memory, address, uint, uint) {
        require(index < posts.length, "Invalid index");

        Post memory post = posts[index];
        if (block.timestamp > post.timestamp + 1 days) {
            return ("", address(0), 0, 0); // Post has expired, return empty values
        }

        return (post.message, post.author, post.likes, post.timestamp);
    }


    // 5. Fonction pour récupérer le nombre total de messages
    // Get the number of comments on a post
    function getCommentCount(uint index) public view returns (uint) {
        require(index < posts.length, "Invalid index");
        return postComments[index].length;
    }

    // Get a specific comment on a post
    function getComment(uint postIndex, uint commentIndex) public view returns (string memory, address, uint) {
        require(postIndex < posts.length, "Invalid post index");
        require(commentIndex < postComments[postIndex].length, "Invalid comment index");

        Comment memory comment = postComments[postIndex][commentIndex];
        return (comment.text, comment.commenter, comment.timestamp);
    }
    

    // Get detailed information of a specific post, including comments
    function getPostDetails(uint index) public view returns (
        string memory message,
        address author,
        uint likes,
        uint commentCount,
        string[] memory comments,
        address[] memory commenters
    ) {
        require(index < posts.length, "Invalid index");

        Post memory post = posts[index];

        // Get comment count
        uint count = postComments[index].length;
        
        // Initialize arrays to store comment details
        string[] memory commentTexts = new string[](count);
        address[] memory commentersAddresses = new address[](count);

        // Populate arrays with comment texts and commenters
        for (uint i = 0; i < count; i++) {
            Comment memory comment = postComments[index][i];
            commentTexts[i] = comment.text;
            commentersAddresses[i] = comment.commenter;
        }

        // Return the post's details, including comments
        return (post.message, post.author, post.likes, count, commentTexts, commentersAddresses);
    }

    // Get total number of posts (only active posts if desired)
    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }
}
