import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';
import 'package:flutter_youtube_ui/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;
  int _selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    Scaffold(
      body: Center(child: Text('Explore')),
    ),
    Scaffold(
      body: Center(child: Text('Add')),
    ),
    Scaffold(
      body: Center(child: Text('Subscription')),
    ),
    Scaffold(
      body: Center(child: Text('Library')),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: "Subscriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: "Library",
          ),
        ],
      ),
      body: Consumer(
        builder: ((context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniplayerController =
              watch(miniPlayerControllerProvider).state;
          return Stack(
            //Our goal is to render all the screen but show only the selected one
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      /* This means if the child screen is not the selected screen
                    then it should be offstaged from the stack.
                    It will be available in the stack but will be hidden.*/
                      offstage: _selectedIndex != i,
                      child: screen,
                    )))
                .values
                .toList()
              ..add(
                Offstage(
                  // if it's true then don't show
                  // Else show the miniplayer
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                    
                    controller: miniplayerController,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    minHeight: _playerMinHeight,
                    maxHeight: MediaQuery.of(context).size.height,
                    builder: (height, percentage) {
                      if (selectedVideo == null) {
                        return const SizedBox.shrink();
                      }
                      if (height < _playerMinHeight + 50) {
                        return Container(
                          child: Column(
                            children: [
                              Row(children: [
                                Image.network(
                                  selectedVideo.thumbnailUrl,
                                  height: _playerMinHeight - 4,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedVideo.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Flexible(
                                        child: Text(
                                          selectedVideo.author.username,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.play_arrow)),
                                IconButton(
                                  onPressed: () {
                                    context.read(selectedVideoProvider).state =
                                        null;
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                              ]),
                              const LinearProgressIndicator(
                                value: 0.3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              )
                            ],
                          ),
                        );
                      } else {
                        return VideoScreen();
                      }
                    },
                  ),
                ),
              ),
          );
        }),
      ),
    );
  }
}
