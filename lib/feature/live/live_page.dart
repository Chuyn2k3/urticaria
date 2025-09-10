import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urticaria/feature/live/live_cubit.dart';

import '../../router/go_router_name_enum.dart';
import 'live_model.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  LiveResponse? _response;
  bool _isLoading = false;
  String? _error;
  final api = LiveApi();

  @override
  void initState() {
    super.initState();
    _fetchLive();
  }

  Future<void> _fetchLive() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await api.getLive();

      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _response?.data ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Live Sessions")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : list.isEmpty
                  ? const Center(child: Text("No live sessions found"))
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return ListTile(
                          title: Text(item.title ?? "No Title"),
                          subtitle: Text("Channel: ${item.channelName ?? ""}"),
                          trailing: Text(item.status ?? ""),
                          onTap: () async {
                            final res = await api.joinLive(
                                item.id!, item.doctorId!, item.channelName!);
                            GoRouter.of(context)
                                .push(GoRouterName.liveDetail.routePath, extra: res);
                          },
                        );
                      },
                    ),
    );
  }
}
