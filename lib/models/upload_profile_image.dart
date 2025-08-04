class UploadProfileImageResponse {
  final FileData? data;
  final String? error;
  final bool success;

  UploadProfileImageResponse({
    required this.success,
    this.data,
    this.error,
  });
}

class FileData {
  final String file;
  final String url;
  final String type;
  final FileInfo fileInfo;

  FileData({
    required this.file,
    required this.url,
    required this.type,
    required this.fileInfo,
  });
}

class FileInfo {
  final String basename;
  final String name;
  final String originalName;
  final String ext;
  final String type;
  final int size;
  final String sizeFormat;

  FileInfo({
    required this.basename,
    required this.name,
    required this.originalName,
    required this.ext,
    required this.type,
    required this.size,
    required this.sizeFormat,
  });
}

class ResizeImageResponse {
  final ImageData? image;
  final String? errorCode;
  final String? errorMessage;
  final int? statusCode;
  final bool success;

  ResizeImageResponse({
    this.image,
    this.errorCode,
    this.errorMessage,
    this.statusCode,
    required this.success,
  });

  factory ResizeImageResponse.fromJson(Map<String, dynamic> json) {
    // Check for error response first
    if (json.containsKey('code')) {
      return ResizeImageResponse(
        errorCode: json['code'],
        errorMessage: json['message'],
        statusCode: json['data']['status'],
        success: false,
      );
    }

    // Handle success response
    return ResizeImageResponse(
      image: ImageData.fromJson(json['image']),
      success: true,
    );
  }
}

class ImageData {
  final String sourceUrl;
  final String sourcePath;
  final String filename;

  ImageData({
    required this.sourceUrl,
    required this.sourcePath,
    required this.filename,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      sourceUrl: json['source_url'],
      sourcePath: json['source_path'],
      filename: json['filename'],
    );
  }
}