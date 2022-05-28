import 'dart:math';

/// Returns the slope of the line of best fit.
double calculateOpacitySlope({required double maxOpacity}) {
  // The opacity is the y axis with the range [0, 1]
  // The domain is [0, maxOpacity]
  // Opacity needs to go from 0 to 1 when x goes from 0 to maxOpacity.

  double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
  int numPoints = 0;
  for (double i = 0; i <= 1; i += 0.1) {
    double x = maxOpacity * i;
    sumX += x;
    sumY += i;
    sumXY += x * i;
    sumXX += x * x;
    numPoints++;
  }

  double slope = (numPoints * sumXY - sumX * sumY) / (numPoints * sumXX - pow(sumX, 2));

  // if you ever need the b value for the equation, uncomment this:
  // double b = (sumY - slope * sumX) / n;

  return slope;
}
