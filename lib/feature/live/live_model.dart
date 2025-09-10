class LiveResponse {
  final List<LiveData>? data;
  final int? total;
  final int? page;
  final int? limit;

  LiveResponse({
    this.data,
    this.total,
    this.page,
    this.limit,
  });

  factory LiveResponse.fromJson(Map<String, dynamic> json) {
    return LiveResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LiveData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

class LiveData {
  final int? id;
  final String? title;
  final String? description;
  final String? channelName;
  final int? doctorId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  LiveData({
    this.id,
    this.title,
    this.description,
    this.channelName,
    this.doctorId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory LiveData.fromJson(Map<String, dynamic> json) {
    return LiveData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      channelName: json['channelName'] as String?,
      doctorId: json['doctorId'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'channelName': channelName,
      'doctorId': doctorId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
