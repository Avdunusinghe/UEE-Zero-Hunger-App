class ResponseModel {
  final String? message;
  final bool? isSuccess;

  ResponseModel({
    this.message,
    this.isSuccess,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'],
      isSuccess: json['isSuccess'],
    );
  }
}
