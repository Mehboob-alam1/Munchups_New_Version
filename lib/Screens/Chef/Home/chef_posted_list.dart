import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Chef/Home/home_detail.dart';
import 'package:munchups_app/Screens/Chef/Home/home_model.dart';

class ChefsPostedListPage extends StatefulWidget {
  List<OcCategoryOrderArr> list;
  ChefsPostedListPage({super.key, required this.list});

  @override
  State<ChefsPostedListPage> createState() => _ChefsPostedListPageState();
}

class _ChefsPostedListPageState extends State<ChefsPostedListPage> {
  List<OcCategoryOrderArr> list = [];

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: list.length,
          itemBuilder: (context, index) {
            OcCategoryOrderArr data = list[index];
            return InkWell(
              onTap: () {
                PageNavigateScreen()
                    .push(context, HomeOrderDetailPage(data: data));
              },
              child: Card(
                color: DynamicColor.boxColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 4, left: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: SizeConfig.getSizeHeightBy(
                                context: context, by: 0.1),
                            color: DynamicColor.black.withOpacity(0.3),
                            child: CustomNetworkImage(
                              url: data.image,
                              fit: BoxFit.contain,
                            )),
                      ),
                    )),
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(data.occasionCategoryName,
                                        style: white17Bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 3),
                                    Text('No of People: ${data.noOfPeople}',
                                        style: white14w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 3),
                                    Text('$currencySymbol${data.budget}',
                                        style: greenColor15bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: DynamicColor.secondryColor,
                                size: 28,
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
