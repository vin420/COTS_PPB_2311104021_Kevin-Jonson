import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import '../models/task_model.dart';

class TaskService {
  final headers = {
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'Content-Type': 'application/json',
  };

  Future<List<Task>> getTasks({String? status}) async {
    final url = status == null
        ? '${SupabaseConfig.baseUrl}/rest/v1/tasks?select=*'
        : '${SupabaseConfig.baseUrl}/rest/v1/tasks?select=*&status=eq.$status';

    final response = await http.get(Uri.parse(url), headers: headers);
    final data = json.decode(response.body) as List;

    return data.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> addTask(Map<String, dynamic> body) async {
    await http.post(
      Uri.parse('${SupabaseConfig.baseUrl}/rest/v1/tasks'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<void> updateTask(int id, Map<String, dynamic> body) async {
    await http.patch(
      Uri.parse(
          '${SupabaseConfig.baseUrl}/rest/v1/tasks?id=eq.$id'),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
