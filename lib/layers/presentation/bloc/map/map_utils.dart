import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/palette.dart';

enum Zoom {
  ground(1),
  building(2),
  block(3),
  street(4),
  district(5),
  neighbor(6),
  city(7),
  ;

  const Zoom(this.level);

  final int level;
}

String getDefaultMarkerInnerText(int type, Rating rating) {
  String image = type == ToiletType.building.index ? '🏢' : '☕️';
  double avgRating = Rating.getAverageRating(rating);
  String ratingValue = avgRating == 0 ? '?' : avgRating.toStringAsFixed(0);

  String chipStyle = 'outline:none;'
      'display:inline-flex;'
      'align-items:center;'
      'padding:2px 8px;'
      'gap:4px;'
      'border-radius:20px;'
      'border:1px solid ${Palette.coolGrey12.toHexColor()};'
      'background-color:${Palette.coolGrey11.toHexColor()};'
      'box-shadow:none;'
      'box-sizing:border-box;'
      'font-family:Pretendard Variable;'
      'line-height:26px; color:#F2F3F5;';

  String chipIconStyle = 'font-size:14px;';

  String chipRatingStyle = 'opacity:0.9;'
      'font-size:16px;'
      'font-weight:500;'
      'font-family:Pretendard Variable;';

  String innerText = "<div class='chip' style='$chipStyle'>"
      "<span class='chip-icon' style='$chipIconStyle'>$image</span>"
      "<span class='chip-rating' style='$chipRatingStyle'>$ratingValue</span>"
      "</div>";

  return innerText;
}

String getStartMarkerInnerText() {
  String chipContainerStyle =
      'border-radius: 20px; background-color: rgba(41, 141, 255, 0.2); padding: 4px;';

  String chipStyle = 'outline: none;'
      'display:inline-flex;'
      'align-items:center;'
      'padding:2px 8px;'
      'gap:4px;'
      'border-radius:20px;'
      'border:4px solid ${Palette.skyblue01.toHexColor()};'
      'background-color:${Palette.skyblue01.toHexColor()};'
      'box-sizing:border-box;'
      'font-family:Pretendard Variable;'
      'line-height:26px;'
      'color:${Palette.skyblue01.toHexColor()};';

  String iconStyle = 'font-size:14px;';

  String innerText = '<div class="chip-container" style="$chipContainerStyle">'
      '<div class="chip" style="$chipStyle">'
      '<span class="chip-icon" style="$iconStyle">🏃</span>'
      '</div>'
      '<div>';

  return innerText;
}

String getEndMarkerInnerText(int type) {
  String image = type == ToiletType.building.index ? '🏢' : '☕️';

  String chipContainerStyle =
      'border-radius: 20px; background-color: rgba(32, 35, 40, 0.2); padding: 4px;';

  String chipStyle = 'outline: none;'
      'display:inline-flex;'
      'align-items:center;'
      'padding:2px 8px;'
      'gap:4px;'
      'border-radius:20px;'
      'border:4px solid ${Palette.coolGrey13.toHexColor()};'
      'background-color: ${Palette.coolGrey13.toHexColor()};'
      'box-sizing:border-box;'
      'font-family:Pretendard Variable;'
      'line-height:26px;'
      'color: ${Palette.coolGrey13.toHexColor()};';

  String iconStyle = 'font-size:14px;';

  String innerText = '<div class="chip-container" style="$chipContainerStyle">'
      '<div class="chip" style="$chipStyle">'
      '<span class="chip-icon" style="$iconStyle">$image</span>'
      '</div>'
      '<div>';

  return innerText;
}

String _getWebViewPreventInteraction() {
  return '''
   document.documentElement.style.webkitTapHighlightColor = 'transparent';
   document.documentElement.style.webkitUserSelect='none';
   document.documentElement.style.webkitTouchCallout='none';
  ''';
}

String _loadFont() {
  return 'var link = document.createElement("link");'
      'link.rel = "stylesheet";'
      'link.as = "style";'
      'link.crossOrigin = "anonymous";'
      'link.href = "https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css";'
      'document.head.appendChild(link);';
}

String getAddCustomMarkersClusterScripts() {
  return '''${_getWebViewPreventInteraction()}
  ${_loadFont()}
function addCustomMarkersCluster(customMarkers) {
  clearMarkerClusterer();

  const markerList = customMarkers.map(function (customMarker) {
    const { id, latLng, content, isClickable, xAnchor, yAnchor, zIndex } = customMarker;
    const position = new kakao.maps.LatLng(latLng.latitude, latLng.longitude);

    const element = document.createElement('div');
    element.innerHTML = content;
    element.style.webkitTapHighlightColor = 'transparent';

    element.addEventListener('click', () => {
       addCustomOverlayListener(id, latLng.latitude, latLng.longitude);
    });

    const marker = new kakao.maps.CustomOverlay({
      clickable: true,
      position: position,
      content: element,
      xAnchor: xAnchor,
      yAnchor: yAnchor,
      zIndex: zIndex,
    });
    return marker;
  })

  // 클러스터 생성
  clusterer = new kakao.maps.MarkerClusterer({
    map: map,
    gridSize: 35,
    averageCenter: true,
    minLevel: 2,
    disableClickZoom: false,
    styles: [{
      width: '24px',
      height: '24px',
      opacity: '0px',
      fontFamily: 'Pretendard Variable',
      fontSize: '18px',
      fontWeight: '600',
      textAlign: 'center',
      color: '${Palette.coolGrey01.toHexColor()}',
      background: '${Palette.coolGrey11.toHexColor()}',
      padding: '8px',
      gap: '4px',
      borderRadius: '16px',
      border: '4px',
    }]
  });
        
  // 클러스터에 추가
  clusterer.addMarkers(markerList);

  // kakao.maps.event.addListener(clusterer, 'clusterclick', function (cluster) {
  //   let latLng = cluster.getCenter();
  //   const clickLatLng = {
  //     latitude: latLng.getLat(),
  //     longitude: latLng.getLng(),
  //     zoomLevel: map.getLevel(),
  //   }
  //   onMarkerClustererTap.postMessage(JSON.stringify(clickLatLng))
  // });
}
''';
}
