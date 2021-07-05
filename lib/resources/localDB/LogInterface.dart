
import 'package:myteams/models/log.dart';

abstract class LogInterface {
  openDb(dbName);

  addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}