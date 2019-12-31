import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/util/NavigatorUtil.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://img.zcool.cn/community/01b635585254b5a8012060c8286ca0.jpg@1280w_1l_2o_100sh.jpg',
    'https://img.zcool.cn/community/0118cf5837d75ea801219c77f35e67.jpg',
    'https://img.zcool.cn/community/0122d8560893be6ac7251df815afc9.jpg@1280w_1l_2o_100sh.png'
  ];
  List<CommonModel> localNavList = []; //local导航
  List<CommonModel> bannerList = []; //轮播图列表
  List<CommonModel> subNavList = []; //轮播图列表
  SalesBoxModel salesBoxModel;
  GridNavModel gridNav; //网格卡片
  double appBarAlpha = 0;
  String resultString = "";
  bool _loading = true; //页面加载状态
  String city = '广州市';

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        bannerList = model.bannerList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _loading,
            child: Stack(
              children: <Widget>[
                MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: NotificationListener(
                        // ignore: missing_return
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            //滚动且是ListView滚动的时候
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                        },
                        child: ListView(
                          children: <Widget>[
                            Container(
                              height: 190,
                              child: Swiper(
                                itemCount: bannerList.length,
                                autoplay: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.network(
                                    bannerList[index].icon,
                                    fit: BoxFit.fill,
                                  );
                                },
                                pagination: SwiperPagination(),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                                child: LocalNav(
                                  localNavList: localNavList,
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                              child: GridNav(gridNavModel: gridNav),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                              child: SubNav(subNavList: subNavList),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                              child: SaleBox(salesBoxModel: salesBoxModel),
                            ),
                            Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  '--- 我是有底线的 ---',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                      ),
                    )),
                _appBar
              ],
            )));
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            height: 80,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: _jumpToCity,
              city: city,
              hideLeft: true,
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if(0 <= alpha && alpha <= 1){
      setState(() {
        appBarAlpha = alpha;
      });
    }

    //print(appBarAlpha);
  }

  //跳转到城市列表
  void _jumpToCity() async {
    /* String result = await NavigatorUtil.push(context, CityPage());
    if (result != null) {
      setState(() {
        city = result;
      });
    }*/
  }

  //跳转搜索页面
  void _jumpToSearch() {
      NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  //跳转语音识别页面
  void _jumpToSpeak() {
    //NavigatorUtil.push(context, SpeakPage());
  }
}
