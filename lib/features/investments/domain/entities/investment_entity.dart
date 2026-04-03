import 'package:equatable/equatable.dart';

enum InvestmentType { stock, etf, mutualFund, crypto, bond, other }

class InvestmentEntity extends Equatable {
  const InvestmentEntity({
    required this.id,
    required this.name,
    required this.type,
    this.ticker,
    required this.units,
    required this.costBasis,
    required this.currentPrice,
    required this.currencyCode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final InvestmentType type;
  final String? ticker;
  final double units;
  final double costBasis;
  final double currentPrice;
  final String currencyCode;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get currentValue => units * currentPrice;
  double get gainLoss => currentValue - costBasis;
  double get gainLossPercent =>
      costBasis > 0 ? (gainLoss / costBasis * 100) : 0;

  InvestmentEntity copyWith({
    String? id,
    String? name,
    InvestmentType? type,
    String? ticker,
    double? units,
    double? costBasis,
    double? currentPrice,
    String? currencyCode,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvestmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      ticker: ticker ?? this.ticker,
      units: units ?? this.units,
      costBasis: costBasis ?? this.costBasis,
      currentPrice: currentPrice ?? this.currentPrice,
      currencyCode: currencyCode ?? this.currencyCode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static InvestmentType typeFromString(String value) {
    switch (value) {
      case 'stock':
        return InvestmentType.stock;
      case 'etf':
        return InvestmentType.etf;
      case 'mutual_fund':
        return InvestmentType.mutualFund;
      case 'crypto':
        return InvestmentType.crypto;
      case 'bond':
        return InvestmentType.bond;
      default:
        return InvestmentType.other;
    }
  }

  static String typeToString(InvestmentType type) {
    switch (type) {
      case InvestmentType.stock:
        return 'stock';
      case InvestmentType.etf:
        return 'etf';
      case InvestmentType.mutualFund:
        return 'mutual_fund';
      case InvestmentType.crypto:
        return 'crypto';
      case InvestmentType.bond:
        return 'bond';
      case InvestmentType.other:
        return 'other';
    }
  }

  static String typeDisplayName(InvestmentType type) {
    switch (type) {
      case InvestmentType.stock:
        return 'Stock';
      case InvestmentType.etf:
        return 'ETF';
      case InvestmentType.mutualFund:
        return 'Mutual Fund';
      case InvestmentType.crypto:
        return 'Crypto';
      case InvestmentType.bond:
        return 'Bond';
      case InvestmentType.other:
        return 'Other';
    }
  }

  @override
  List<Object?> get props => [
        id, name, type, ticker, units, costBasis, currentPrice,
        currencyCode, notes, createdAt, updatedAt,
      ];
}
