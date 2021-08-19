import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raro_academy_budget/modules/transactions/widgets/transaction_card_widget.dart';
import 'package:raro_academy_budget/shared/controllers/transaction_controller.dart';
import 'package:raro_academy_budget/shared/models/transaction_model.dart';
import 'package:raro_academy_budget/shared/widgets/drawer_widget.dart';
import 'package:raro_academy_budget/util/constants/app_colors.dart';
import 'package:raro_academy_budget/util/constants/app_text_styles.dart';

class InOutTransactionsPage extends StatefulWidget {
  const InOutTransactionsPage({Key? key}) : super(key: key);
  @override
  _InOutTransactionsPageState createState() => _InOutTransactionsPageState();
}

class _InOutTransactionsPageState extends State<InOutTransactionsPage> {
  String dropdownValue = 'Agosto';
   TransactionController controller = TransactionController();
  final pageController = PageController(initialPage: 0);
  double totalValueOut = 0;
  double totalValueIn = 0;
  double balanceTransaction = 0.0;
  var list = [];

  var inTextStyle =
      AppTextStyles.kInputTextMedium.copyWith(color: Colors.white);
  var outTextStyle = AppTextStyles.kInputTextMedium
      .copyWith(color: Color.fromRGBO(255, 255, 255, 0.6));
  var allTextStyle = AppTextStyles.kInputTextMedium
      .copyWith(color: Color.fromRGBO(255, 255, 255, 0.6));
  @override
  Widget build(BuildContext ctx) {
    print('tela reinicia');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      drawerEnableOpenDragGesture: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(189),
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.kblueGradientAppBar),
          child: Column(
            children: [
              SizedBox(height: 49),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer()),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    height: 26,
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                    child: DropdownButton<String>(
                      menuMaxHeight: size.height * 0.3,
                      elevation: 8,
                      dropdownColor: AppColors.kPurple,
                      value: dropdownValue,
                      underline: Container(
                        height: 0,
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.expand_more_outlined,
                            color: Colors.white),
                      ),
                      iconSize: 18,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Janeiro',
                        'Fevereiro',
                        'Março',
                        'Abril',
                        'Maio',
                        'Junho',
                        'Julho',
                        'Agosto',
                        'Setembro',
                        'Outubro',
                        'Novembro',
                        'Dezembro',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.kNextButtonMedium,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              StreamBuilder<List<TransactionModel>>(
                stream: controller.getTransaction(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child:CircularProgressIndicator());
                  } else if(snapshot.hasError){
                    return Text("Erro ao buscar os dados");
                  } else if(snapshot.hasData){
                    list = snapshot.data ?? [];
                     balanceTransaction = 0;
                     totalValueOut = 0;
                     totalValueIn = 0;
                     list.forEach((transaction) async {
                          if (transaction.type == 'out') {
                            totalValueOut += transaction.value ?? 0;
                          } else if (transaction.type == 'in') {
                            totalValueIn += transaction.value ?? 0;
                          }
                          balanceTransaction = totalValueIn - totalValueOut;
                     });
                    return Padding(
                    padding: const EdgeInsets.only(top: 27, bottom: 11),
                    child: Text(
                      "R\$ ${balanceTransaction.toStringAsFixed(2).replaceAll(".", ",")}",
                      style: AppTextStyles.kTextTrasanctionHeader,
                    ),
                  );
                  } else {
                    return Container();
                  }
                  
                }
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        pageController.jumpToPage(0);
                      },
                      child: Text(
                        "Entradas",
                        style: inTextStyle,
                      ),
                    ),
                    Container(
                      height: 20,
                      child: VerticalDivider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        pageController.jumpToPage(1);
                      },
                      child: Text(
                        "Saídas",
                        style: outTextStyle,
                      ),
                    ),
                    Container(
                      height: 20,
                      child: VerticalDivider(
                        thickness: 1,
                        // width: 2,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        pageController.jumpToPage(2);
                      },
                      child: Text(
                        "Todos",
                        style: allTextStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          TransactionsCardWidget(
            context: context,
            type: 0,
          ),
          TransactionsCardWidget(
            context: context,
            type: 1,
          ),
          TransactionsCardWidget(
            context: context,
            type: 2,
          ),
        ],
        onPageChanged: (num) {
          if (num == 0) {
            inTextStyle = inTextStyle.copyWith(color: Colors.white);
            outTextStyle = outTextStyle.copyWith(
                color: Color.fromRGBO(255, 255, 255, 0.6));
            allTextStyle = allTextStyle.copyWith(
                color: Color.fromRGBO(255, 255, 255, 0.6));
          } else if (num == 1) {
            inTextStyle =
                inTextStyle.copyWith(color: Color.fromRGBO(255, 255, 255, 0.6));
            outTextStyle = outTextStyle.copyWith(color: Colors.white);
            allTextStyle = allTextStyle.copyWith(
                color: Color.fromRGBO(255, 255, 255, 0.6));
          } else {
            inTextStyle =
                inTextStyle.copyWith(color: Color.fromRGBO(255, 255, 255, 0.6));
            outTextStyle = outTextStyle.copyWith(
                color: Color.fromRGBO(255, 255, 255, 0.6));
            allTextStyle = allTextStyle.copyWith(color: Colors.white);
          }
          setState(() {});
        },
      ),
    );
  }
}
