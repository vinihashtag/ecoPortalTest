class JsonMocks {
  JsonMocks._();

  static Map<String, dynamic> get getAllMovies {
    return {
      "allMovies": {
        "edges": [
          {
            "node": {
              "id": "70351289-8756-4101-bf9a-37fc8c7a82cd",
              "imgUrl": "https://upload.wikimedia.org/wikipedia/en/d/d4/Rogue_One%2C_A_Star_Wars_Story_poster.png",
              "title": "Rogue One: A Star Wars Story",
              "nodeId": "WyJtb3ZpZXMiLCI3MDM1MTI4OS04NzU2LTQxMDEtYmY5YS0zN2ZjOGM3YTgyY2QiXQ==",
              "releaseDate": "2016-12-16"
            }
          },
          {
            "node": {
              "id": "b8d93229-e02a-4060-9370-3e073ada86c3",
              "imgUrl": "https://images-na.ssl-images-amazon.com/images/I/81aA7hEEykL.jpg",
              "title": "Star Wars: A New Hope",
              "nodeId": "WyJtb3ZpZXMiLCJiOGQ5MzIyOS1lMDJhLTQwNjAtOTM3MC0zZTA3M2FkYTg2YzMiXQ==",
              "releaseDate": "1977-05-25"
            }
          }
        ]
      }
    };
  }

  static Map<String, dynamic> get getAllReviews {
    return {
      "allMovieReviews": {
        "nodes": [
          {
            "id": "335f0ff2-7f96-413f-8d26-6224039356c4",
            "rating": 4,
            "title": "Best Action Movie",
            "body":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "userReviewerId": "65549e6a-2389-42c5-909a-4475fdbb3e69"
          }
        ]
      }
    };
  }

  static Map<String, dynamic> get createdReview {
    return {
      "createMovieReview": {
        "movieReview": {
          "id": "335f0ff2-7f96-413f-8d26-6224039356c4",
          "rating": 4,
          "title": "Best Action Movie",
          "body":
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          "userReviewerId": "65549e6a-2389-42c5-909a-4475fdbb3e69",
          "movieId": "65549e6a-2389-42c5-909a-65549e6a",
          "nodeId": "4475fdbb3e69-2389-42c5-909a-4475fdbb3e69"
        }
      }
    };
  }
}
