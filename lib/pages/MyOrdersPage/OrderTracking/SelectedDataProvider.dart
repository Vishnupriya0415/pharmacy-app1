// ignore_for_file: file_names

import 'package:flutter/material.dart';


class Medicine {
  final String name;
  final double price;
  int quantity;
  final String pharmacyName;


  Medicine({required this.name, required this.price,required this.pharmacyName, this.quantity = 1});



 // set pharmacyName(String pharmacyName) {}
}

class MedicalShop {
  final String name;
  final List<Medicine> medicines;

  MedicalShop({required this.name, required this.medicines});
}

class SelectedDataProvider extends ChangeNotifier {
  List<MedicalShop> selectedMedicalShops = [];
  String? selectedMedicineName;

  get medicineName => selectedMedicineName;

  
 void setSelectedMedicineName(String? medicineName) {
    selectedMedicineName = medicineName;
    notifyListeners();
  }
  //get medicineName =>  widget.selectedData.medicineName;

  void addMedicalShop(MedicalShop medicalShop) {
    selectedMedicalShops.add(medicalShop);
    notifyListeners();
  }

  void removeMedicalShop(int index) {
    selectedMedicalShops.removeAt(index);
    notifyListeners();
  }
  
 
  
  // Other methods and logic for managing data can be added here
}
