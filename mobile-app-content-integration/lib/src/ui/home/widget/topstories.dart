import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/src/model/topstories/topstories.dart';
import 'package:flutter_news_app/src/ui/home/screen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopStoriesWidget extends StatefulWidget {
  final TopStories data;
  final String name;
  
  const TopStoriesWidget({ Key key, this.data, this.name }): super(key: key);

  @override
  _TopStoriesWidgetState createState() => _TopStoriesWidgetState();
}

class _TopStoriesWidgetState extends State<TopStoriesWidget> {
  WebViewController _controller;
  List<ContentResource> _linkContentResources;
  List<ContentResource> _companyContentResources;

  @override
  Widget build(BuildContext context) {
    final attributes = widget.data.attributes;
    var body = attributes.body;
    final name = widget.name;
    var newsImage = 'https://i.pinimg.com/originals/b8/8e/59/b88e5919775afd0de88efa8ebcaf1250.png';
    var newsImageSize = 280.0;
    
    // Content Resources is where all the news live
    _companyContentResources = attributes.contentResources
      .where((content) => content.type.toLowerCase() == 'company')
      .toList();
    if (name != 'all' && name != 'add') {
      body = filterArticlesByName(body, name);
      body = body.where((element) => element != null).toList();
    } else {
      body = cleanAttributesInBody(body);
    }
    
    // There exist articles, images and links in content resources
    _linkContentResources = attributes.contentResources
      .where((content) => content.type.toLowerCase() == 'link')
      .toList();
    final contentImages = attributes.contentResources
      .where((content) => content.type.toLowerCase() == 'image')
      .toList();
    
    // There may exist 0 or more images for the current content resources
    if (contentImages != null && contentImages.isNotEmpty) {
      newsImage = contentImages[0]?.properties?.location ?? newsImage;
      newsImageSize = 260.0; 
    }

    var mediaQuery = MediaQuery.of(context);
    
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: body.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Color(0xFFF8F8F8),
            thickness: 1.0,
          );
        },
        itemBuilder: (context, index) {
          final itemArticle = body[index];
          final link = getArticleLink(itemArticle);
          final articleText = itemArticle.content?.map((element) {
              if (element == null || element.text == null) {
                return '';
              }
              return element.text.trim();
            })?.join(' ') ?? '';

          if (index == 0) {
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(link)) {
                      scaffoldState.currentState.showBottomSheet((context) => 
                        WebView(
                          initialUrl: 'uri',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController webViewController) async {
                            _controller = webViewController;
                            await _controller.loadUrl(link);
                          },
                          gestureNavigationEnabled: true,
                          gestureRecognizers: Set()
                            ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                        )
                      );
                    } else {
                      scaffoldState.currentState.showBottomSheet((context) => 
                        Html(
                          data: """
                            <div style="background-color:'gray'">
                              <p style="font-family:'Simplon'">$articleText</p>
                            </div>
                          """
                        )
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          newsImage,
                          width: mediaQuery.size.width,
                          height: newsImageSize,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Latest News',
                          style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            color: Color(0xFFFFFFFF),
                            fontSize: 8.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        height: 260.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                articleText,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'SimplonNorm-Medium',
                                  fontSize: 14.0,
                                  color: Color(0xFFFFFFFF),
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'WSJ',
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 8.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () async {
                if (await canLaunch(link)) {
                  // await launch(link);
                  scaffoldState.currentState.showBottomSheet((context) => 
                    WebView(
                      initialUrl: 'uri',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) async {
                        _controller = webViewController;
                        await _controller.loadUrl(link);
                      }
                    )
                  );
                } else {
                  scaffoldState.currentState.showBottomSheet((context) => 
                    Html(
                      data: """
                        <div>
                          <p style="font-family:'Simplon'">$articleText</p>
                        </div>
                      """
                    )
                  );
                }
              },
              child: Container(
                width: mediaQuery.size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 72.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                articleText,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  fontSize: 12.0,
                                  color: Color(0xFF39485A),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 16.0),
                              child: Text(
                                'WSJ',
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  color: Color(0xFF007EA8),
                                  fontSize: 8.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: getCurrImage(itemArticle),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<AttributesBody> filterArticlesByName(body, name) {
    final companyRef = _companyContentResources
      .singleWhere((element) => 
        element.name?.toLowerCase()?.contains(name),
        orElse: () => null);
    if (companyRef == null || companyRef?.name == null) {
      return <AttributesBody>[];
    }  
    
    var filterArticles = <AttributesBody>[];
    body.forEach((itemArticle) {
      itemArticle?.content?.forEach((element) {
        if (companyRef.id.toLowerCase().trim() == 
          element?.ref.toString().toLowerCase().trim()) {
          filterArticles.add(itemArticle);
        }
      });
    });

    return filterArticles;
  }

  List<AttributesBody> cleanAttributesInBody(body) {
    var filterArticles = <AttributesBody>[];
      body.forEach((itemArticle) {
        var isText = false;
        itemArticle?.content?.forEach((element) {
          if (element?.text != null) {
            isText = true;
          }
        });
        if (isText) {
          filterArticles.add(itemArticle); 
        }
      }
    );

    filterArticles.removeLast();
    return filterArticles;
  }

  String getArticleLink(itemArticle) {
    var id = '';
    itemArticle.content?.forEach((element) {
      final currElement = element?.type?.toString()?.toLowerCase();
      if (currElement == 'contenttype.link') {
        id = element.ref;
      }
    });
    if (id != '') {
      var resource = _linkContentResources
        .singleWhere((element) => element.id == id,
          orElse: () => null);
      return resource?.uri;
    }

    return id;
  }

  Widget getCurrImage(itemArticle) {
    if (itemArticle.ref != null) {
      return ClipRRect(
        child: Image.network(
          itemArticle.ref,
          width: 72.0,
          height: 72.0,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      );
    }

    return null;
  }
}
