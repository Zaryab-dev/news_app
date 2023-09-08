import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/view_model/categories_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryViewModel categoryViewModel = CategoryViewModel();
  String categoryName = 'general';

  List<String> categoriesList = [
    'general',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.07,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    customBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.01,
                        decoration: BoxDecoration(
                            color: categoryName == categoriesList[index]
                                ? Colors.blue
                                : CupertinoColors.systemGrey2,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(
                            child: Text(
                              categoriesList[index],
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder<NewsCategoriesModel>(
                future: categoryViewModel.fetchCategoriesAPi(categoryName),
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
                                width: size.width * 0.6,
                                height: size.height * 0.18,
                                // color : Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(snapshot.data!.articles![index].title.toString(),
                                      style: GoogleFonts.poppins(fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 4,),
                                    // Spacer(),
                                    // SizedBox(height: 50,),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        children: [
                                          Row(
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
          ),
        ],
      ),
    );
  }
}
