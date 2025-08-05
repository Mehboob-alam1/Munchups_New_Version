import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/proposal_list_model.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/demand_food_detail.dart';

class ProposalFoodListPage extends StatefulWidget {
  dynamic buyerID;
  dynamic foodID;
  ProposalFoodListPage({
    super.key,
    required this.buyerID,
    required this.foodID,
  });

  @override
  State<ProposalFoodListPage> createState() => _ProposalFoodListPageState();
}

class _ProposalFoodListPageState extends State<ProposalFoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'List Of Proposals')),
      body: FutureBuilder<ProposalListModel>(
          future: GetApiServer().getProposalOrderApi(
              widget.buyerID.toString(), widget.foodID.toString()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('No Proposal available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(child: Text('No Proposal available'));
                } else if (snapshot.data!.ocCategoryOrderArr == 'NA') {
                  return const Center(child: Text('No Proposal available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.ocCategoryOrderArr.length,
                        itemBuilder: (context, index) {
                          ProposalOcCategoryOrderArr data =
                              snapshot.data!.ocCategoryOrderArr[index];
                          return InkWell(
                            onTap: () {
                              PageNavigateScreen().push(context,
                                  DemandFoodOrderDetailPage(data: data));
                            },
                            child: Card(
                              color: DynamicColor.boxColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        height: SizeConfig.getSizeHeightBy(
                                            context: context, by: 0.1),
                                        color:
                                            DynamicColor.black.withOpacity(0.3),
                                        child: CustomNetworkImage(
                                          url: data.image,
                                          fit: BoxFit.contain,
                                        )),
                                  )),
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      '${data.firstName} ${data.lastName}',
                                                      style: white17Bold,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                      data.occasionCategoryName,
                                                      style: white14w5,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                      '$currencySymbol${data.budget}',
                                                      style: greenColor15bold,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
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
          }),
    );
  }
}
