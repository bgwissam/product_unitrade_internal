import 'package:Products/shared/strings.dart';

class Division {
  int id;
  String divisionName;

  Division(this.id, this.divisionName);

  static List<Division> getDivision() {
    return <Division>[
      Division(1, TAB_PAINT_TEXT),
      Division(2, TAB_WOOD_TEXT),
      Division(3, TAB_SS_TEXT),
      Division(4, TAB_LIGHT_TEXT),
      Division(5, TAB_ACCESSORIES_TEXT)
    ];
  }
}

class Category {
  int id;
  String categoryName;
  String divisionName;

  Category(this.id, this.categoryName, this.divisionName);

  static List<Category> getCategory() {
    return <Category>[
      Category(1, PU_BUTTON, TAB_PAINT_TEXT),
      Category(2, NC_BUTTON, TAB_PAINT_TEXT),
      Category(3, AC_BUTTON, TAB_PAINT_TEXT),
      Category(4, GLUE_BUTTON, TAB_PAINT_TEXT),
      Category(5, EXT_BUTTON, TAB_PAINT_TEXT),
      Category(6, MDF_BUTTON, TAB_WOOD_TEXT),
      Category(7, SOLID_BUTTON, TAB_WOOD_TEXT),
      Category(8, CHIP_BUTTON, TAB_WOOD_TEXT),
      Category(9, FIRE_BUTTON, TAB_WOOD_TEXT),
      Category(10, COR_BUTTON, TAB_SS_TEXT),
      Category(11, MON_BUTTON, TAB_SS_TEXT),
      Category(12, HAFELE_BUTTON, TAB_LIGHT_TEXT),
      Category(13, SALICE_BUTTON, TAB_ACCESSORIES_TEXT),
    ];
  }
}

class Type {
  static List<String> typeList() {
    return [
      TAB_PAINT_TEXT,
      TAB_WOOD_TEXT,
      TAB_SS_TEXT,
      TAB_ACCESSORIES_TEXT,
      TAB_LIGHT_TEXT
    ];
  }
}

class CategoryList {
  static List<String> categoryList() {
    return [
      PU_BUTTON,
      NC_BUTTON,
      AC_BUTTON,
      GLUE_BUTTON,
      EXT_BUTTON,
      SPECIAL_PRODUCT,
      THINNER,
      MDF_BUTTON,
      SOLID_BUTTON,
      FIRE_BUTTON,
      CHIP_BUTTON,
      COR_BUTTON,
      MON_BUTTON,
      HAFELE_BUTTON,
      SALICE_BUTTON
    ];
  }
}

class PaintImagesList {
  static List<List<String>> paintImagesList() {
    return [
      ['assets/images/paint_images/EVI_25L.jpg', 'EVI', '25 Litres'],
      ['assets/images/paint_images/EVI_USG.jpg', 'EVI', 'USG'],
      ['assets/images/paint_images/EVI_12L.jpg', 'EVI', '12.5 Litres'],
      ['assets/images/paint_images/SAY_25L.jpg', 'Sayerlack', '25 Litres'],
      ['assets/images/paint_images/SAY_12L.jpg', 'Sayerlack', '12.5 Litres'],
      ['assets/images/paint_images/SAY_6L.jpg', 'Sayerlack', '6 Litres'],
      ['assets/images/paint_images/SAY_1L.jpg', 'Sayerlack', '1 Litre']
    ];
  }
}

//drop down list for cities in Saudi Arabia
class CitiesSaudiArabia {
  static List<String> cities() {
    return ['Jeddah', 'Riyadh', 'Dammam'];
  }
}

class BusinessType {
  static List<String> sector() {
    return ['Factory', 'Carpentry', 'Retail', 'Contractor',];
  }
}
