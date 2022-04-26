import 'package:flutter/material.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoInfo extends StatelessWidget {
  final Video video;
  const VideoInfo({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            '${video.viewCount} views • ${timeago.format(video.timestamp)}',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
          ),
          const Divider(),
          _ActionsRow(video: video),
          const Divider(),
          _AuthorInfo(user: video.author),
          const Divider(),
          
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Video video;
  const _ActionsRow({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(context, Icons.thumb_up_outlined, video.likes),
        _buildAction(context, Icons.thumb_down_outlined, video.dislikes),
        _buildAction(context, Icons.reply_outlined, 'Share'),
        _buildAction(context, Icons.download_outlined, 'Download'),
        _buildAction(context, Icons.library_add_outlined, 'Save'),
      ],
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final User user;
  const _AuthorInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(user.profileImageUrl),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Flexible(
                  child: Text(
                    '${user.subscribers} Subscribers',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                'SUBSCRIBE',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red,fontSize: 16),
              ))
        ],
      ),
    );
  }
}

_buildAction(BuildContext context, IconData icon, String label) {
  return GestureDetector(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: Colors.white,
              ),
        )
      ],
    ),
  );
}
