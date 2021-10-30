import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu.dart';
import 'package:priima_lounas_flutter/model/user_saved_vote.dart';
import 'package:priima_lounas_flutter/services/local_data_service.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';

class LikeDislikeIcons extends StatefulWidget {
  const LikeDislikeIcons({Key? key, required this.courseId}) : super(key: key);

  final int courseId;

  @override
  _LikeDislikeIconsState createState() => _LikeDislikeIconsState(courseId);
}

class _LikeDislikeIconsState extends State<LikeDislikeIcons> {
  bool liked = false;
  bool disliked = false;
  bool disableVoting = false;

  int requestCount = 0;

  int courseId;

  UserSavedVotesService service = UserSavedVotesService();

  _LikeDislikeIconsState(this.courseId);

  @override
  void initState() {
    super.initState();
    checkSavedUserVote();
  }

  void checkSavedUserVote() async {
    var vote = await service.readFromFile(this.courseId);
    if (vote is UserSavedVote) {
      setState(() {
        this.liked = vote.liked;
        this.disliked = vote.disliked;
      });
    }
  }

  Icon getIcon(bool like) {
    IconData data;
    Color color;

    if (like) {
      color = Colors.green;
      if (liked) {
        data = Icons.thumb_up;
      } else {
        data = Icons.thumb_up_outlined;
      }
    } else {
      color = Colors.red;
      if (disliked) {
        data = Icons.thumb_down;
      } else {
        data = Icons.thumb_down_outlined;
      }
    }

    return Icon(data, color: color);
  }

  double getOpacity() {
    return liked || disliked ? 0.5 : 1;
  }

  void likePressed() {
    if (disableVoting) {
      return;
    }
    bool bLiked = liked;
    bool bDisliked = disliked;
    setState(() {
      liked = !liked;
      disliked = false;
    });
    tryVote(bLiked, bDisliked);
  }

  void dislikePressed() {
    if (disableVoting) {
      return;
    }
    bool bLiked = liked;
    bool bDisliked = disliked;
    setState(() {
      disliked = !disliked;
      liked = false;
    });
    tryVote(bLiked, bDisliked);
  }

  void tryVote(bool bLiked, bool bDisliked) async {
    setState(() {
      disableVoting = true;
    });

    if (requestCount < 0) {
      requestCount = 0;
    }

    String snackText = "";
    Color snackColor = Colors.black;
    Color textColor = Colors.white;

    if (requestCount >= 2) {
      snackText = "⚠ Odota hetki ennenkuin yrität uudelleen ⚠";
      snackColor = Colors.yellow.shade500;
      textColor = Colors.black;

      SnackBar snackBar = new SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          snackText,
          style: TextStyle(color: textColor, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: snackColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        liked = bLiked;
        disliked = bDisliked;
      });

      await Future.delayed(Duration(seconds: 5));
      requestCount--;
    } else {
      int likes = 0;
      int dislikes = 0;

      if (liked && !bLiked) {
        likes++;
        if (!disliked && bDisliked) {
          dislikes--;
        }
      } else if (!liked && bLiked && !disliked && !bDisliked) {
        likes--;
      }
      if (disliked && !bDisliked) {
        dislikes++;
        if (!liked && bLiked) {
          likes--;
        }
      } else if (!disliked && bDisliked && !liked && !bLiked) {
        dislikes--;
      }

      CourseVote courseVote = new CourseVote(id: courseId, likes: likes, dislikes: dislikes, votes: 0, ranked: 0);
      var localResult = await service.addToFile(
        new UserSavedVote(id: this.courseId, liked: this.liked, disliked: this.disliked),
      );

      bool failed = false;

      // succesfully saved to device
      if (localResult) {
        var backendResult = await vote(courseVote);
        // succesfully saved to backend
        if (backendResult is List<CourseVote>) {
          snackText = "✅ Kiitos äänestä ✅";
          snackColor = Colors.green.shade500;
          requestCount++;
        }
        // backend save failed so revert device save
        else {
          await service.addToFile(
            new UserSavedVote(id: this.courseId, liked: bLiked, disliked: bDisliked),
          );
          failed = true;
        }
      } else {
        failed = true;
      }
      if (failed) {
        snackText = "🆘 Äänestäminen epäonnistui 🆘";
        snackColor = Colors.red.shade600;
        setState(() {
          liked = bLiked;
          disliked = bDisliked;
        });
      }
      SnackBar snackBar = new SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          snackText,
          style: TextStyle(color: textColor, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: snackColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      disableVoting = false;
    });

    await Future.delayed(Duration(seconds: 5));
    requestCount--;
  }

  dynamic vote(CourseVote vote) async {
    List<CourseVote> votes = [];
    votes.add(vote);
    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.postToApi(RestApiType.vote, votes);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1, //getOpacity(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 36,
            height: 36,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: likePressed,
              icon: getIcon(true),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: dislikePressed,
              icon: getIcon(false),
            ),
          ),
        ],
      ),
    );
  }
}
