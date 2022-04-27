import 'package:final_project_flutter/model/Income.dart';
import 'package:flutter/cupertino.dart';

import '../services/IncomeService.dart';

class DashBordViewModel extends ChangeNotifier {

  getListIncome()
  async {
    await IncomeService.get();
    notifyListeners();
  }
 addIncome(Income income) async {
   var x = await IncomeService.insert(income: income);
   notifyListeners();
   return x;
 }

  addRemove(Income income) async {
    await IncomeService.insert(income: income);
    notifyListeners();
  }

}