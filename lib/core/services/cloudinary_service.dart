import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const cloudName = 'dj5ztsbyl';
  static const uploadPreset = 'dom_vmeste';
  static Future<String?> uploadImage(File file) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    print('Uploading to: $url'); // ← добавь
    print('File exists: ${file.existsSync()}'); // ← добавь
    print('File size: ${file.lengthSync()} bytes'); // ← добавь

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    print('Status code: ${response.statusCode}'); // ← добавь

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      print('Secure URL: ${data['secure_url']}'); // ← добавь
      return data['secure_url'];
    } else {
      final res = await http.Response.fromStream(response);
      print('Cloudinary error: ${response.statusCode}');
      print('Cloudinary body: ${res.body}'); // ← это покажет причину
      return null;
    }
  }
}
