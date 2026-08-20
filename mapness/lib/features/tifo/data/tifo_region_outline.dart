/// Static outline of the Riyadh region the TIFO season covers, as
/// `(latitude, longitude)` pairs in ring order.
///
/// Hardcoded on purpose: the cluster LOD ([_TifoLod.cluster] in
/// `tifo_buildings_map_layer.dart`) paints THIS single polygon instead of
/// waiting on `GET /districts` and tinting all ~413 district polygons one
/// color. At that zoom the district borders aren't legible anyway, so the
/// region silhouette carries the same information for one polygon's worth of
/// bridge traffic and no geometry request at all.
///
/// Source: the season's region GeoJSON (EPSG:4326). The GeoJSON's repeated
/// closing vertex is dropped — the map bridge closes contours itself, and a
/// duplicate point renders as a zero-length edge.
const List<(double, double)> kTifoRegionOutline = [
  (25.218989012912772, 46.249842326689105),
  (25.116097332535688, 46.01127614907925),
  (25.033945669964808, 46.33429472531972),
  (24.9026772213211, 46.21495288740804),
  (24.55787088534268, 46.267700412666514),
  (24.515277598497292, 46.24572300466623),
  (24.422217583141062, 46.16163553161914),
  (24.391762473904407, 46.28585566232794),
  (24.402205053112056, 46.46167492401646),
  (23.858749395482647, 47.173726234095916),
  (23.76433555457035, 47.20525903566123),
  (23.7477186155578, 47.334256863907385),
  (24.154656371264835, 47.70787281991998),
  (24.309755977614103, 47.65245153790794),
  (24.69879231292964, 48.012601722421756),
  (25.04627080300307, 47.69441333562709),
  (25.053388323060688, 47.37033256487934),
  (25.304016238704932, 47.260341516093405),
  (25.362599277389577, 46.58075395605493),
  (25.270786632598004, 46.347817400080956),
  (25.22072652947341, 46.25253748433498),
];
