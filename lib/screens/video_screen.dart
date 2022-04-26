import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/nav_screen.dart';
import 'package:flutter_youtube_ui/widgets/widgets.dart';
import 'package:miniplayer/miniplayer.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          controller: _scrollController,
          shrinkWrap: true,
          slivers: [
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, watch, _) {
                  final selectedvideo = watch(selectedVideoProvider).state;
                  return SafeArea(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              selectedvideo!.thumbnailUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.black45,
                                child: Center(
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () => context
                                        .read(miniPlayerControllerProvider)
                                        .state
                                        .animateToHeight(state: PanelState.MIN),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const LinearProgressIndicator(
                          value: 0.3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        VideoInfo(video: selectedvideo),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final suggestedVideo = suggestedVideos[index];
                return VideoCard(
                  video: suggestedVideo,
                  hasPadding: true,
                  onTap: () => _scrollController!.animateTo(
                    0,
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeIn,
                  ),
                );
              }, childCount: suggestedVideos.length),
            ),
          ],
        ),
      ),
    );
  }
}
