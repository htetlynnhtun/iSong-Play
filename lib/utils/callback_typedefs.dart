import 'package:music_app/blocs/library_bloc.dart';

typedef OnDownloadFinished = void Function(String filePath);
typedef OnProgress = void Function(int received, int total);
typedef OnAddPlayListName = Future<SavePlaylistResult> Function();
typedef OnRenamePlayListName = Future<SavePlaylistResult> Function(String oldName);
