import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/news_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../view_model/categories_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  enum FilterList {bbcNews, news ,independent, reuters, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  CategoryViewModel categoryViewModel = CategoryViewModel();
  FilterList? selectedValue;
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/category_screen'),
          child: const Icon(
            Icons.category_outlined,
            size: 30,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            icon: const Icon(Icons.more_vert),
              initialValue: selectedValue,
              onSelected: (FilterList item) {
              if(FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if(FilterList.cnn.name == item.name) {
                name = 'cnn';
              }
              if(FilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              setState(() {
                selectedValue = item;
              });
              },
              itemBuilder: (context) =>
          <PopupMenuEntry<FilterList>>[
            const PopupMenuItem<FilterList>(
              value: FilterList.bbcNews,
              child: Text("BBC NEWS"),
            ),
            const PopupMenuItem<FilterList>(
              value: FilterList.cnn,
              child: Text("CNN NEWS"),
            ),
            const PopupMenuItem<FilterList>(
              value: FilterList.alJazeera,
              child: Text("AL-JAZEERA NEWS"),
            )
          ])
        ],
        title: Text(
          'NEWS',
          style:
          GoogleFonts.poppins(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.55,
            width: size.width * 1,
            child: FutureBuilder<NewsHeadlinesModel>(
              future: newsViewModel.fetchHeadlinesAPI(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(
                    color: Colors.amber,
                    size: 60.sp,
                  );
                }
                if(snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SpinKitFadingCircle(
                          color: Colors.red,
                          size: 100,
                        ),
                        SizedBox(height: 30.h,),
                        const Text('No Internet'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!
                            .articles![index].publishedAt.toString());
                        return Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * .04,
                                    vertical: size.height * .02),
                                height: size.height * .6,
                                width: size.width * .85,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return SpinKitFadingCircle(
                                        color: Colors.red,
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return SpinKitFadingCircle(
                                        color: Colors.red,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: size.height * .22,
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * .02,
                                                  vertical: size.height * 0.01),
                                              width: size.width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(), maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,),)),
                                          Spacer(),
                                          Container(
                                            width: size.width * 0.64,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  width: size.width * 0.34,
                                                  // color: Colors.red,
                                                  child: Text(snapshot.data!
                                                      .articles![index].source!
                                                      .name.toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors.blue),overflow: TextOverflow.ellipsis,),
                                                ),
                                                Container(
                                                  width: size.width * 0.30,
                                                  // color: Colors.green,
                                                  child: Text(DateFormat()
                                                      .add_yMMMMd()
                                                      .format(dateTime),overflow: TextOverflow.ellipsis,),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      });
              },
            ),
          ),
          FutureBuilder<NewsCategoriesModel>(
                future: categoryViewModel.fetchCategoriesAPi('General'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitFadingCircle(
                        size: 60,
                        color: Colors.red,
                      ),
                    );
                  }else{
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!
                          .articles![index].publishedAt.toString());
                      return Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    height: size.height * 0.18,
                                    width: size.width * 0.3,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return const SpinKitFadingCircle(
                                        color: Colors.green,
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error_outline,size: 50,color: Colors.red,);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.57,
                                height: size.height * 0.18,
                                // color : Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(snapshot.data!.articles![index].title.toString(),
                                      style: GoogleFonts.poppins(fontSize: 14.sp,fontWeight: FontWeight.w500),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                    // Spacer(),
                                    // SizedBox(height: 50,),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: size.width * 0.6,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  // color: Colors.green,
                                                  width: size.width * 0.25,
                                                  child: Text(snapshot.data!
                                                      .articles![index].source!
                                                      .name.toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors.blue,),softWrap: true,overflow: TextOverflow.ellipsis,),
                                                ),
                                                Container(
                                                  width: size.width * 0.3,
                                                  // color: Colors.red,
                                                  child: Center(
                                                    child: Text(DateFormat()
                                                        .add_yMMMMd()
                                                        .format(dateTime),softWrap: true,overflow: TextOverflow.ellipsis,),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 1,
                              width: size.width *1,
                              color: CupertinoColors.systemGrey4,
                            ),
                          )
                        ],
                      );
                    });
                  }
                }),
        ],
      ),
    );
  }
}
