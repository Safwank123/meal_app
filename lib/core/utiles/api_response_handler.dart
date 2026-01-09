class ApiResponse<T> {
  final bool success;
  final T? data;
  final String error;

  const ApiResponse({this.success = false, this.data, this.error = ''});

  factory ApiResponse.parse(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
    bool user = false,
  }) => ApiResponse(
    error: json['error'] ?? '',
    success: json['success'] ?? false,
    data: fromJsonT == null ? json['data'] : fromJsonT(!user ? json['data'] : json['data']['user']),
  );

  factory ApiResponse.error({String error = ""}) =>
      ApiResponse(success: false, data: null, error: error);
}

class ApiListResponse<T> {
  final bool success;
  final List<T> data;
  final int count;
  final String error;
  final int? limit;
  final int? offset;

  const ApiListResponse({
    this.success = false,
    this.data = const [],
    this.count = 0,
    this.limit,
    this.offset,
    this.error = '',
  });

  factory ApiListResponse.parse(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
    int? limit,
    int? offset,
  }) {
    if (json['data'] == null) {
      return ApiListResponse(success: false, data: [], count: json['count']);
    }
    final list = json['data'] is List<dynamic> ? json['data'] : json['data']['rows'];
    return ApiListResponse(
      success: json['success'] ?? false,
      data: fromJsonT == null ? List<T>.from(list) : List<T>.from((list).map((x) => fromJsonT(x))),
      count: json['data'] is List<dynamic> ? 0 : json['data']['count'] ?? 0,
      limit: limit,
      offset: offset,
      error: json['error'] ?? '',
    );
  }

  factory ApiListResponse.error() => ApiListResponse(success: false, data: [], count: 0, error: "");
}