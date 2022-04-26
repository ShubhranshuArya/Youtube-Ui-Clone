import 'package:flutter/material.dart';
import 'package:flutter_youtube_ui/data.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                ((context, index) {
                  final video = videos[index];
                  return VideoCard(video: video);
                }),
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
