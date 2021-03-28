import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/viewmodels/player_view_model.dart';
import '../../core/viewmodels/track_list_model.dart';
import '../../core/enums_and_variables/info_state.dart';
import '../../core/models/tracks.dart';
import '../../locator.dart';
import '../../ui/utils.dart';

class TrackSearchList extends StatefulWidget {
  @override
  _TrackSearchListState createState() => _TrackSearchListState();
}

class _TrackSearchListState extends State<TrackSearchList> {
  ScrollController _scrollController;

  @override
  void initState() {
    print("Executing init state ");
    locator<TrackListModel>().getOnlineTracks();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        locator<TrackListModel>().getOnlineTracks();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("Executing dispose state ");
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrackListModel>.value(
      value: locator<TrackListModel>(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            print("Home TAP gesture detected");
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              /** Search Track Field */
              SearchField(),
              SizedBox(height: screenAwareSize(10.0, context)),

              /** List All Tracks */
              Expanded(
                child: Consumer<TrackListModel>(
                  builder: (context, model, child) {
                    List<Track> tracks = model.getOnlineTracksList;
                    bool showListLoadingIndicator =
                        !model.isGetTracksLenghtZero;

                    if (tracks.length == 0) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          radius: screenAwareSize(20, context),
                        ),
                      );
                    }

                    /** List view  */
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          tracks.length + (showListLoadingIndicator ? 1 : 0),
                      itemBuilder: (context, index) {
                        /** To show  loading indicator at bottom of the listview */
                        if (index == tracks.length &&
                            showListLoadingIndicator) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CupertinoActivityIndicator(
                              radius: screenAwareSize(10, context),
                            ),
                          );
                        }

                        return Container(
                          // container for bottom margin
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          child: RaisedButton(
                            color: Theme.of(context).canvasColor,
                            splashColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              tracks[index].play();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  /** Left Icon  */
                                  Container(
                                      height: screenAwareSize(35, context),
                                      width: screenAwareSize(35, context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40)),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.music_note,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: screenAwareSize(20, context),
                                          ),
                                        ),
                                      )),

                                  /** Title text  */
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        tracks[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize:
                                                screenAwareSize(11, context)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchController;

  List<Track> suggestion = [];
  OverlayEntry _overlayEntry;

  bool apiCalled;
  ViewState state;

  @override
  void initState() {
    apiCalled = false;
    state = ViewState.Idle;

    suggestion = locator<TrackListModel>().getOnlineTrackSuggestionList;
    print("Suggestion Init : $suggestion");

    _searchController = TextEditingController();

    /** To Manipulate Icons in Search text field  */
    _searchController.addListener(() async {
      if (_searchController.text.isNotEmpty && state == ViewState.Idle) {
        /** To serialize the api calls not calling api calls for every event from controller */
        if (!apiCalled) {
          String searchQuery = _searchController.text;

          apiCalled = true;
          print("WHile executing ");
          await locator<TrackListModel>()
              .getOnlineTracksSuggestion(searchQuery);
          apiCalled = false;
          print(
              "query before start : $searchQuery query after stopped : ${_searchController.text}");
          if (searchQuery != _searchController.text) {
            searchQuery = _searchController.text;
            apiCalled = true;
            await locator<TrackListModel>()
                .getOnlineTracksSuggestion(_searchController.text);
            apiCalled = false;
          } else {
            print(
                "when search : $searchQuery after search : ${_searchController.text}");
          }

          if (locator<TrackListModel>().isOnlineSuggestionEmpty) {
            print("Remove is working nice");
            if (_overlayEntry != null) {
              this._overlayEntry.remove();
              this._overlayEntry = null;
            }
          } else {
            this._overlayEntry = this._createOverlayEntry();
            Overlay.of(context).insert(this._overlayEntry);
          }
        } else {
          print("Api call skipped because its already fetching");
        }
      } else {
        print(" Listener Omitted Calling API");
        print(
            "Listener Values isEmpty : ${_searchController.text.isEmpty} state : $state");
        // if(_searchController.text.isEmpty && _overlayEntry != null){
        if (_searchController.text.isEmpty) {
          locator<TrackListModel>().clearOnlineSuggestion();
        }
        // }

      }
    });

    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        opaque: false,
        builder: (context) => ChangeNotifierProvider<TrackListModel>.value(
              value: locator<TrackListModel>(),
              child: Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 5.0,
                width: size.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0.0,
                    // minWidth: 50.0,
                    maxHeight: screenAwareSize(150.0, context),
                    // maxWidth: 200.0,
                  ),
                  child: Consumer<TrackListModel>(
                    builder: (context, model, child) {
                      suggestion = model.getOnlineTrackSuggestionList;
                      List<Widget> ap = [];
                      for (Track t in suggestion) {
                        ap.add(GestureDetector(
                          onTap: () async {
                            _searchController.clear();
                            model.clearOnlineSuggestion();
                            t.play();
                            FocusScope.of(context).unfocus();
                          },
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              /** Left Icon  */
                              Container(
                                  height: screenAwareSize(25, context),
                                  width: screenAwareSize(25, context),
                                  child: Center(
                                    child: Icon(
                                      Icons.music_note,
                                      color: Theme.of(context).accentColor,
                                      size: screenAwareSize(20, context),
                                    ),
                                  )),

                              /** Title text  */
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    t.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: screenAwareSize(11, context)),
                                  ),
                                ),
                              )
                            ]),
                          )),
                        ));
                      }

                      return Material(
                        elevation: 4.0,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: ap,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    print("Search Dispose Called");
    _searchController.dispose();
    locator<TrackListModel>().clearOnlineSuggestion();
    if (_overlayEntry != null) {
      this._overlayEntry.remove();
      this._overlayEntry = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrackListModel>.value(
      value: locator<TrackListModel>(),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            locator<PlayerViewModel>().hidePlayerControls();
          } else {
            locator<PlayerViewModel>().showPlayerControls();
          }
        },
        child: TextField(
            style: TextStyle(fontSize: screenAwareSize(14, context)),
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search),
              suffixIcon: suffixIcon(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              hintText: 'Search Track',
            )),
      ),
    );
  }

  Widget suffixIcon() {
    return Consumer<TrackListModel>(
      builder: (context, model, child) {
        state = model.getState;
        if (state == ViewState.Busy) {
          return CupertinoActivityIndicator();
        }

        if (state == ViewState.Idle && _searchController.text.isNotEmpty) {
          return GestureDetector(
              onTap: () {
                model.clearOnlineSuggestion();
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
              child: Icon(Icons.close));
        }

        return Text("");
      },
    );
  }
}
