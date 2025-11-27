class Token {
  final String id;
  final String userId;
  final String fmcToken;
  final String createdToken;
  final String? lastToken;

  Token({
    required this.id,
    required this.userId,
    required this.fmcToken,
    required this.createdToken,
    required this.lastToken,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'fmcToken': fmcToken,
    'createdToken': createdToken,
    'lastToken': lastToken,
  };

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    id: json['id'] as String,
    userId: json['userId'] as String,
    fmcToken: json['fmcToken'] as String,
    createdToken: json['createdToken'] as String,
    lastToken: json['lastToken'] as String?,
  );
Token copyWith(
    {String? id,
    String? userId,
    String? fmcToken,
    String? createdToken,
    String? lastToken,}
  )  {
    
    return Token(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    fmcToken: fmcToken ?? this.userId,
    createdToken: createdToken ?? this.userId,
    lastToken: lastToken ?? this.userId,
  );}
  
}
