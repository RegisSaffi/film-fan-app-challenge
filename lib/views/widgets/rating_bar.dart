import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class RatingBar extends StatefulWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final bool small;

  RatingBar({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color,this.small=false});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  
  late double rating;

  @override
  void initState() {
    setState(() {
      rating=widget.rating;
    });
    super.initState();
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Colors.amber,
        size: widget.small?null:50,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.small?null:50,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.small?null:50,
      );
    }

    return new InkResponse(
      radius: widget.small?20:25,
      onTap:widget.onRatingChanged == null ? null : () {
        setState(() {
          rating=index+1.0;
        });
        widget.onRatingChanged!(index + 1.0);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(widget.starCount, (index) => buildStar(context, index)));
  }
}