class Emissions {
  final double annualIncrease;
  final double uncertainty;
  final String year;

  Emissions({
    required this.annualIncrease,
    required this.uncertainty,
    required this.year,
  });

  factory Emissions.fromJson(Map<String, dynamic> json) {
    return Emissions(
      annualIncrease: json['Annual Increase'],
      uncertainty: json['Uncertainty'],
      year: json['Year'],
    );
  }
}
