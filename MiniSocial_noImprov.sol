// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {
    // 1. Structure Post contenant un message et l'adresse de l'auteur
    struct Post {
        string message;
        address author;
    }

    // 2. Tableau dynamique pour stocker les posts
    Post[] public posts;

    // 3. Fonction pour publier un message
    function publishPost(string memory _message) public {
        // Créer un nouveau Post et l'ajouter au tableau posts
        Post memory newPost = Post({
            message: _message,
            author: msg.sender
        });
        posts.push(newPost);
    }

    // 4. Fonction pour consulter un post spécifique par index
    function getPost(uint index) public view returns (string memory, address) {
        require(index < posts.length, "Index invalide"); // Vérifie que l'index est valide
        Post memory post = posts[index];
        return (post.message, post.author);
    }

    // 5. Fonction pour récupérer le nombre total de messages
    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }
}
