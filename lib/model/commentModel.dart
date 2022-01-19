class Comment {
  String authorName;
  String authorImageUrl;
  String text;

  Comment({
    required this.authorName,
    required this.authorImageUrl,
    required this.text,
  });
}

final List<Comment> comments = [
  Comment(
    authorName: 'Joe Biden',
    authorImageUrl: 'assets/images/user2.jpg',
    text: 'Loving this photo!!',
  ),
  Comment(
    authorName: 'Jeff Bezos',
    authorImageUrl: 'assets/images/user3.jpg',
    text: 'One of the best photos I have ever seen...',
  ),
  Comment(
    authorName: 'Elon Musk',
    authorImageUrl: 'assets/images/user4.jpg',
    text: 'Can\'t wait for you to post more!',
  ),
  Comment(
    authorName: 'Bill Gates',
    authorImageUrl: 'assets/images/user1.jpg',
    text: 'That is a stunning view!',
  ),
  Comment(
    authorName: 'Rao Yuchen',
    authorImageUrl: 'assets/images/user0.jpg',
    text: 'Thanks everyone :)',
  ),
];
