class Voucher {
  final String name;
  final String description;
  final String minterName;
  final String minterAddress;
  final String contractChain;
  final String contractAddress;
  final String mintingDate;
  final String image;

  Voucher({
    required this.name,
    required this.description,
    required this.minterName,
    required this.minterAddress,
    required this.contractChain,
    required this.contractAddress,
    required this.mintingDate,
    required this.image,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      name: json['name'],
      description: json['description'],
      minterName: json['minter_name'],
      minterAddress: json['minter_address'],
      contractChain: json['contract_chain'],
      contractAddress: json['contract_address'],
      mintingDate: json['minting_date'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'minter_name': minterName,
      'minter_address': minterAddress,
      'contract_chain': contractChain,
      'contract_address': contractAddress,
      'minting_date': mintingDate,
      'image': image,
    };
  }
}
