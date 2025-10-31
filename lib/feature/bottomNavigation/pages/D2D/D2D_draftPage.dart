import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ------------------------------
/// MODEL
/// ------------------------------
class D2dDraft {
  final String id; // timestamp-based id
  final DateTime createdAt;
  final DateTime updatedAt;

  // Whatever you captured on D2DPage01 so far:
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;

  final String? dropAddress;
  final double? dropLat;
  final double? dropLng;

  final List<Map<String, double>> stops; // [{lat:.., lng:..}, ...]

  final String? serviceType; // instant/scheduled/whatever you track
  final String? notes;

  D2dDraft({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropAddress,
    this.dropLat,
    this.dropLng,
    this.stops = const [],
    this.serviceType,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "pickupAddress": pickupAddress,
        "pickupLat": pickupLat,
        "pickupLng": pickupLng,
        "dropAddress": dropAddress,
        "dropLat": dropLat,
        "dropLng": dropLng,
        "stops": stops,
        "serviceType": serviceType,
        "notes": notes,
      };

  factory D2dDraft.fromJson(Map<String, dynamic> j) => D2dDraft(
        id: j["id"],
        createdAt: DateTime.parse(j["createdAt"]),
        updatedAt: DateTime.parse(j["updatedAt"]),
        pickupAddress: j["pickupAddress"],
        pickupLat: (j["pickupLat"] as num?)?.toDouble(),
        pickupLng: (j["pickupLng"] as num?)?.toDouble(),
        dropAddress: j["dropAddress"],
        dropLat: (j["dropLat"] as num?)?.toDouble(),
        dropLng: (j["dropLng"] as num?)?.toDouble(),
        stops: (j["stops"] as List?)?.cast<Map<String, dynamic>>().map((e) {
              return {
                "lat": (e["lat"] as num).toDouble(),
                "lng": (e["lng"] as num).toDouble()
              };
            }).toList() ??
            [],
        serviceType: j["serviceType"],
        notes: j["notes"],
      );
}

/// ------------------------------
/// LOCAL STORE (SharedPreferences)
/// ------------------------------
class D2dDraftStore {
  static const _boxKey = "d2d_drafts_box";

  static Future<List<D2dDraft>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_boxKey) ?? [];
    return raw.map((s) => D2dDraft.fromJson(jsonDecode(s))).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  static Future<void> _saveAll(List<D2dDraft> drafts) async {
    final sp = await SharedPreferences.getInstance();
    final list = drafts.map((d) => jsonEncode(d.toJson())).toList();
    await sp.setStringList(_boxKey, list);
  }

  static Future<void> addOrUpdate(D2dDraft draft) async {
    final drafts = await getAll();
    final i = drafts.indexWhere((d) => d.id == draft.id);
    if (i >= 0) {
      drafts[i] = draft;
    } else {
      drafts.add(draft);
    }
    await _saveAll(drafts);
  }

  static Future<void> delete(String id) async {
    final drafts = await getAll();
    drafts.removeWhere((d) => d.id == id);
    await _saveAll(drafts);
  }

  static Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_boxKey);
  }

  /// Helper to quickly create & store a draft from partial form data.
  static Future<D2dDraft> saveFromPartial({
    String? pickupAddress,
    double? pickupLat,
    double? pickupLng,
    String? dropAddress,
    double? dropLat,
    double? dropLng,
    List<Map<String, double>> stops = const [],
    String? serviceType,
    String? notes,
    String? id,
  }) async {
    final now = DateTime.now();
    final draft = D2dDraft(
      id: id ?? now.millisecondsSinceEpoch.toString(),
      createdAt: now,
      updatedAt: now,
      pickupAddress: pickupAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropAddress: dropAddress,
      dropLat: dropLat,
      dropLng: dropLng,
      stops: stops,
      serviceType: serviceType,
      notes: notes,
    );
    await addOrUpdate(draft);
    return draft;
  }
}

/// ------------------------------
/// DRAFTS PAGE
/// ------------------------------
class D2dDraftpage extends StatefulWidget {
  const D2dDraftpage({super.key});

  @override
  State<D2dDraftpage> createState() => _D2dDraftpageState();
}

class _D2dDraftpageState extends State<D2dDraftpage> {
  List<D2dDraft> _drafts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _drafts = await D2dDraftStore.getAll();
    setState(() => _loading = false);
  }

  String _routeLine(D2dDraft d) {
    final p = d.pickupAddress?.trim();
    final q = d.dropAddress?.trim();
    final stopsTxt = d.stops.isEmpty
        ? ""
        : " • ${d.stops.length} stop${d.stops.length == 1 ? "" : "s"}";
    if ((p ?? "").isEmpty && (q ?? "").isEmpty)
      return "Incomplete route$stopsTxt";
    if ((p ?? "").isEmpty) return "… → ${q!}$stopsTxt";
    if ((q ?? "").isEmpty) return "${p!} → …$stopsTxt";
    return "$p → $q$stopsTxt";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F7),
      appBar: AppBar(
        title: const Text("Drafts"),
        actions: [
          if (_drafts.isNotEmpty)
            IconButton(
              tooltip: "Clear all drafts",
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Clear all drafts?"),
                    content:
                        const Text("This will permanently delete all drafts."),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel")),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Clear all")),
                    ],
                  ),
                );
                if (ok == true) {
                  await D2dDraftStore.clearAll();
                  await _load();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All drafts cleared")),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2.6))
          : _drafts.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.doc_text,
                            size: 64, color: Colors.black26),
                        const SizedBox(height: 12),
                        const Text(
                          "No drafts yet",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Start a D2D order and back out—\nit’ll be saved here automatically.",
                          style: TextStyle(
                              color: Colors.black54, fontSize: width * 0.035),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.04, 10, width * 0.04, 24),
                    itemCount: _drafts.length,
                    itemBuilder: (context, i) {
                      final d = _drafts[i];
                      return Dismissible(
                        key: ValueKey("draft_${d.id}"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red.withOpacity(0.1),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.red),
                        ),
                        confirmDismiss: (_) async {
                          await D2dDraftStore.delete(d.id);
                          await _load();
                          return true;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE9ECF2)),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Color(0x14000000),
                                  offset: Offset(0, 4))
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              // Navigate back to your D2DPage01 with this draft.
                              // Adjust route/arguments to your app’s navigation.
                              final resumed = await Navigator.pushNamed(
                                context,
                                "/d2d/page01",
                                arguments: d.toJson(), // or pass the object
                              );
                              // After returning, refresh list (in case draft was completed/deleted there).
                              await _load();
                              if (resumed == true && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Draft loaded")),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF6FF),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                            Icons.local_shipping_outlined),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _routeLine(d),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _chip(
                                          "Service: ${d.serviceType ?? "N/A"}"),
                                      const SizedBox(width: 8),
                                      _chip(
                                          "${d.stops.length} stop${d.stops.length == 1 ? "" : "s"}"),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Updated ${_friendlyTime(d.updatedAt)}",
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () async {
                                              await D2dDraftStore.delete(d.id);
                                              await _load();
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Draft deleted")),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.delete_outline),
                                            label: const Text("Delete"),
                                          ),
                                          const SizedBox(width: 6),
                                          FilledButton.icon(
                                            onPressed: () async {
                                              final resumed =
                                                  await Navigator.pushNamed(
                                                context,
                                                "/d2d/page01",
                                                arguments: d.toJson(),
                                              );
                                              await _load();
                                              if (resumed == true && mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text("Draft loaded")),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.play_arrow_rounded),
                                            label: const Text("Resume"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  // Small helper view bits (kept inline to honor "no helpers" preference; tiny + readable)
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }

  String _friendlyTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} h ago";
    return "${t.year}-${_two(t.month)}-${_two(t.day)} ${_two(t.hour)}:${_two(t.minute)}";
    // You can plug intl if you want localized formatting.
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
