
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
const APPBAR_SCROLL_OFFSET = 100;
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
  String resultString ="";
  @override
  void initState() {
    super.initState();
    loadData();
  }
  loadData() async{
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        bannerList = model.bannerList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
      });
    }catch(e){
     print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
          removeTop: true,
          context: context,
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
                  height: 180,
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
                Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                child:  LocalNav(localNavList: localNavList,)
                ),
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
                  height: 40,
                  child: Text('--- 我是有底线的 ---',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)
                )
              ],
            ),
          ),
        ),
        Opacity(
          opacity: appBarAlpha,
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 35),
                child: Text('首页',style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  _onScroll(offset) {
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if(alpha<0){
      alpha = 0;
    }else if(alpha>1){
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);

  }


}
