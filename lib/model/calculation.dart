import 'dart:math';

class CattleCalculation {
   double InToCm = 0.39370;
   double LbToKg = 2.2046;


  double pixelDistance(double x1, double y1, double x2, double y2) {
    return sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));
  }

  double distance(
      double pixelReference, double distanceReference, double pixel) {
    return (pixel * distanceReference) / pixelReference;
  }

  double calWeight(double bodyLenght,double heartGirth){
  return  (((heartGirth*heartGirth*bodyLenght)*InToCm)/300)/LbToKg;
  }

  double calHeartGirth(double horizontal,double vertical){
    return (pi*(horizontal+vertical))/2;
  }
}
