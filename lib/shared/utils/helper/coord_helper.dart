// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:pookabu/layers/data/models/coord/coord.dart';

class CoordConv {
  late double m_dx = 0;
  late double m_dy = 0;
  late double m_dz = 0;
  late double m_omega = 0;
  late double m_phi = 0;
  late double m_kappa = 0;
  late double m_ds = 0;
  late int m_imode = 0;
  late double x = 0;
  late double y = 0;

  static double A = atan(1) / 45;
  static const double BASE_TM_X = 127;
  static const double BASE_TM_Y = 38;
  static const double BASE_KTM_X = 128;
  static const double BASE_KTM_Y = 38;
  static const double BASE_UTM_X = 129;
  static const double BASE_UTM_Y = 0;
  static const double BASE_NON_X = -1;
  static const double BASE_NON_Y = -1;
  static const int COORD_TM = 0;
  static const int COORD_WTM = 1;
  static const int COORD_CONGNAMUL = 2;
  static const int COORD_WCONGNAMUL = 3;
  static const int COORD_KTM = 4;
  static const int COORD_WKTM = 5;
  static const int COORD_UTM = 6;
  static const int COORD_WGS84 = 7;
  static const int COORD_BESSEL = 8;

  static Map<int, Map<String, dynamic>> COORD_BASE = {
    0: {
      'name': 'TM',
      'code': COORD_TM,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    },
    1: {
      'name': 'WTM',
      'code': COORD_WTM,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    },
    2: {
      'name': 'CONGNAMUL',
      'code': COORD_CONGNAMUL,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    },
    3: {
      'name': 'WCONGNAMUL',
      'code': COORD_WCONGNAMUL,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    },
    4: {
      'name': 'KTM',
      'code': COORD_KTM,
      'base': {'x': BASE_KTM_X, 'y': BASE_KTM_Y}
    },
    5: {
      'name': 'WKTM',
      'code': COORD_WKTM,
      'base': {'x': BASE_KTM_X, 'y': BASE_KTM_Y}
    },
    6: {
      'name': 'UTM',
      'code': COORD_UTM,
      'base': {'x': BASE_UTM_X, 'y': BASE_UTM_Y}
    },
    7: {
      'name': 'WGS84',
      'code': COORD_WGS84,
      'base': {'x': BASE_NON_X, 'y': BASE_NON_Y}
    },
    8: {
      'name': 'BESSEL',
      'code': COORD_BESSEL,
      'base': {'x': BASE_NON_X, 'y': BASE_NON_Y}
    },
  };

  Document getTransCoord(double x, double y, int fromType, int toType) {
    if (fromType == toType) return Document(x: x, y: y);
    init(x, y);

    if (fromType < 0 || fromType >= COORD_BASE.length) {
      return Document(x: x, y: y);
    }

    if (toType < 0 || toType >= COORD_BASE.length) return Document(x: x, y: y);

    convertCoord(fromType, toType);
    return Document(x: this.x, y: this.y);
  }

  void convertCoord(int fromType, int toType) {
    from2bassel(fromType);

    bassel2to(toType);
  }

  void from2bassel(int fromType) {
    double frombx = COORD_BASE[fromType]!['base']['x'];
    double fromby = COORD_BASE[fromType]!['base']['y'];
    if (fromType == COORD_TM) {
      convertTM2BESSEL(frombx, fromby);
    } else if (fromType == COORD_KTM) {
      convertKTM2BESSEL();
    } else if (fromType == COORD_UTM) {
      convertUTM2WGS(frombx, fromby);
      convertWGS2BESSEL();
    } else if (fromType == COORD_CONGNAMUL) {
      convertCONG2BESSEL();
    } else if (fromType == COORD_WGS84) {
      convertWGS2BESSEL();
    } else if (fromType == COORD_BESSEL) {
    } else if (fromType == COORD_WTM) {
      convertWTM2WGS(frombx, fromby);
      convertWGS2BESSEL();
    } else if (fromType == COORD_WKTM) {
      convertWKTM2WGS();
      convertWGS2BESSEL();
    } else if (fromType == COORD_WCONGNAMUL) {
      convertWCONG2WGS();
      convertWGS2BESSEL();
    }
  }

  void bassel2to(int toType) {
    double tobx = COORD_BASE[toType]!['base']['x'];
    double toby = COORD_BASE[toType]!['base']['y'];

    if (toType == COORD_TM) {
      convertBESSEL2TM(tobx, toby);
    } else if (toType == COORD_KTM) {
      convertBESSEL2KTM();
    } else if (toType == COORD_UTM) {
      convertBESSEL2WGS();
      convertWGS2UTM(tobx, toby);
    } else if (toType == COORD_CONGNAMUL) {
      convertBESSEL2CONG();
    } else if (toType == COORD_WGS84) {
      convertBESSEL2WGS();
    } else if (toType == COORD_BESSEL) {
    } else if (toType == COORD_WTM) {
      convertBESSEL2WGS();
      convertWGS2WTM(tobx, toby);
    } else if (toType == COORD_WKTM) {
      convertBESSEL2WGS();
      convertWGS2WKTM();
    } else if (toType == COORD_WCONGNAMUL) {
      convertBESSEL2WGS();
      convertWGS2WCONG();
    }
  }

  void init(double x, double y) {
    m_imode = 0;
    m_ds = 0;
    m_kappa = 0;
    m_phi = 0;
    m_omega = 0;
    m_dz = 0;
    m_dy = 0;
    m_dx = 0;
    COORD_BASE[COORD_TM] = {
      'name': 'TM',
      'code': COORD_TM,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    };

    COORD_BASE[COORD_WTM] = {
      'name': 'WTM',
      'code': COORD_WTM,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    };
    COORD_BASE[COORD_CONGNAMUL] = {
      'name': 'CONGNAMUL',
      'code': COORD_CONGNAMUL,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    };
    COORD_BASE[COORD_WCONGNAMUL] = {
      'name': 'WCONGNAMUL',
      'code': COORD_WCONGNAMUL,
      'base': {'x': BASE_TM_X, 'y': BASE_TM_Y}
    };
    COORD_BASE[COORD_KTM] = {
      'name': 'KTM',
      'code': COORD_KTM,
      'base': {'x': BASE_KTM_X, 'y': BASE_KTM_Y}
    };
    COORD_BASE[COORD_WKTM] = {
      'name': 'WKTM',
      'code': COORD_WKTM,
      'base': {'x': BASE_KTM_X, 'y': BASE_KTM_Y}
    };
    COORD_BASE[COORD_UTM] = {
      'name': 'UTM',
      'code': COORD_UTM,
      'base': {'x': BASE_UTM_X, 'y': BASE_UTM_Y}
    };
    COORD_BASE[COORD_WGS84] = {
      'name': 'WGS84',
      'code': COORD_WGS84,
      'base': {'x': BASE_NON_X, 'y': BASE_NON_Y}
    };
    COORD_BASE[COORD_BESSEL] = {
      'name': 'BESSEL',
      'code': COORD_BESSEL,
      'base': {'x': BASE_NON_X, 'y': BASE_NON_Y}
    };
    this.x = x;
    this.y = y;
  }

  void convertBESSEL2KTM() {
    GP2TM(6377397.155, 0.0033427731799399794, 600000, 400000, 0.9999, 38, 128);
  }

  void convertBESSEL2CONG() {
    GP2TM(6377397.155, 0.0033427731799399794, 500000, 200000, 1, 38,
        127.00289027777778);
    shiftIsland(true);
  }

  void convertBESSEL2WGS() {
    setParameter(115.8, -474.99, -674.11, 1.16, -2.31, -1.63, -6.43, 1);
    var rtn = GP2WGP(y, x, 0, 6377397.155, 0.0033427731799399794);
    x = rtn[1];
    y = rtn[0];
  }

  void convertKTM2BESSEL() {
    TM2GP(6377397.155, 0.0033427731799399794, 600000, 400000, 0.9999, 38, 128);
  }

  void convertBESSEL2TM(double d, double e) {
    GP2TM(6377397.155, 0.0033427731799399794, 500000, 200000, 1, e,
        d + 0.0028902777777777776);
  }

  void convertTM2BESSEL(double d, double e) {
    TM2GP(6377397.155, 0.0033427731799399794, 500000, 200000, 1, e,
        d + 0.0028902777777777776);
  }

  void convertWGS2UTM(double d, double e) {
    setParameter(115.8, -474.99, -674.11, 1.16, -2.31, -1.63, -6.43, 1);
    GP2TM(6378137, 0.0033528106647474805, 0, 500000, 0.9996, e, d);
  }

  void convertWGS2WTM(double d, double e) {
    GP2TM(6378137, 0.0033528106647474805, 500000, 200000, 1, e, d);
  }

  void convertWGS2WKTM() {
    GP2TM(6378137, 0.0033528106647474805, 600000, 400000, 0.9999, 38, 128);
  }

  void convertWGS2WCONG() {
    GP2TM(6378137, 0.0033528106647474805, 500000, 200000, 1, 38, 127);
    x = (x * 2.5).round().toDouble();
    y = (y * 2.5).round().toDouble();
  }

  void convertUTM2WGS(double d, double e) {
    setParameter(115.8, -474.99, -674.11, 1.16, -2.31, -1.63, -6.43, 1);
    TM2GP(6378137, 0.0033528106647474805, 0, 500000, 0.9996, e, d);
  }

  void convertWGS2BESSEL() {
    setParameter(115.8, -474.99, -674.11, 1.16, -2.31, -1.63, -6.43, 1);
    var rtn = WGP2GP(y, x, 0, 6377397.155, 0.0033427731799399794);
    x = rtn[1];
    y = rtn[0];
  }

  void convertCONG2BESSEL() {
    shiftIsland(false);
    TM2GP(6377397.155, 0.0033427731799399794, 500000, 200000, 1, 38,
        127.00289027777778);
  }

  void convertWTM2WGS(double d, double e) {
    TM2GP(6378137, 0.0033528106647474805, 500000, 200000, 1, e, d);
  }

  void convertWKTM2WGS() {
    TM2GP(6378137, 0.0033528106647474805, 600000, 400000, 0.9999, 38, 128);
  }

  void convertWCONG2WGS() {
    x /= 2.5;
    y /= 2.5;

    TM2GP(6378137, 0.0033528106647474805, 500000, 200000, 1, 38, 127);
  }

  List<double> WGP2GP(double a, double b, double d, double e, double h) {
    var rtn = WGP2WCTR(a, b, d);
    // if (m_imode == 1) {
    //   rtn = TransMolod(rtn[0], rtn[1], rtn[2]);
    // } else {
    // }
    rtn = TransBursa(rtn[0], rtn[1], rtn[2]);

    return CTR2GP(rtn[0], rtn[1], rtn[2], e, h);
  }

  List<double> WGP2WCTR(double a, double b, double d) {
    return GP2CTR(a, b, d, 6378137, 0.0033528106647474805);
  }

  List<double> GP2WGP(double a, double b, double d, double e, double h) {
    var rtn = GP2CTR(a, b, d, e, h);
    if (m_imode == 1) {
      rtn = InverseMolod(rtn[0], rtn[1], rtn[2]);
    } else {
      rtn = InverseBursa(rtn[0], rtn[1], rtn[2]);
    }
    return WCTR2WGP(rtn[0], rtn[1], rtn[2]);
  }

  List<double> GP2CTR(double a, double b, double d, double e, double h) {
    var m = h;
    if (m > 1) m = 1 / m;
    var c = atan(1) / 45;
    var l = a * c;
    c *= b;
    m = 1 / m;
    m = (e * (m - 1)) / m;
    var o = (pow(e, 2) - pow(m, 2)) / pow(e, 2);
    o = e / sqrt(1 - o * pow(sin(l), 2));

    return [
      (o + d) * cos(l) * cos(c),
      (o + d) * cos(l) * sin(c),
      ((pow(m, 2) / pow(e, 2)) * o + d) * sin(l),
    ];
  }

  List<double> InverseMolod(double a, double b, double d) {
    var e = (a - m_dx) * (1 + m_ds);
    var h = (b - m_dy) * (1 + m_ds);
    var c = (d - m_dz) * (1 + m_ds);
    return [
      (1 / (1 + m_ds)) * (e - m_kappa * h + m_phi * c),
      (1 / (1 + m_ds)) * (m_kappa * e + h - m_omega * c),
      (1 / (1 + m_ds)) * (-1 * m_phi * e + m_omega * h + c),
    ];
  }

  List<double> InverseBursa(double a, double b, double d) {
    var e = a - m_dx;
    var h = b - m_dy;
    var c = d - m_dz;
    return [
      (1 / (1 + m_ds)) * (e - m_kappa * h + m_phi * c),
      (1 / (1 + m_ds)) * (m_kappa * e + h - m_omega * c),
      (1 / (1 + m_ds)) * (-1 * m_phi * e + m_omega * h + c),
    ];
  }

  List<double> TransMolod(double a, double b, double d) {
    return [
      a + (1 + m_ds) * (m_kappa * b - m_phi * d) + m_dx,
      b + (1 + m_ds) * (-1 * m_kappa * a + m_omega * d) + m_dy,
      d + (1 + m_ds) * (m_phi * a - m_omega * b) + m_dz,
    ];
  }

  List<double> TransBursa(double a, double b, double d) {
    return [
      (1 + m_ds) * (a + m_kappa * b - m_phi * d) + m_dx,
      (1 + m_ds) * (-1 * m_kappa * a + b + m_omega * d) + m_dy,
      (1 + m_ds) * (m_phi * a - m_omega * b + d) + m_dz,
    ];
  }

  List<double> WCTR2WGP(double a, double b, double d) {
    return CTR2GP(a, b, d, 6378137, 0.0033528106647474805);
  }

  List<double> CTR2GP(double a, double b, double d, double e, double h) {
    var m = h;
    if (m > 1) m = 1 / m;
    var c = atan(1) / 45;
    m = 1 / m;
    var o = e * (m - 1) / m;
    var z = (pow(e, 2) - pow(o, 2)) / pow(e, 2);
    m = atan(b / a);
    var A = sqrt(pow(a, 2) + pow(b, 2));
    var u = e;
    var bb = 0;
    double w = 0.0;
    var l = 0.0;
    var f = 0.0;
    do {
      bb++;
      w = (pow((pow(o, 2) / pow(e, 2) * u) + w, 2) - pow(d, 2)).toDouble();
      w = d / sqrt(w);
      l = atan(w);
      if ((l - f).abs() < 1.0E-18) {
        break;
      }
      u = e / sqrt(1 - z * pow(sin(l), 2));
      w = A / cos(l) - u;
      f = l;
    } while (bb <= 30);
    var rtn = [l / c, m / c];
    if (a < 0) rtn[1] += 180;
    if (rtn[1] < 0) rtn[1] += 360;
    return rtn;
  }

  void GP2TM(
      double d, double e, double h, double f, double c, double l, double m) {
    var a = y;
    var b = x;
    var B = f;
    var w = e;
    if (w > 1) w = 1 / w;
    var A = atan(1) / 45;
    var o = a * A;
    var D = b * A;
    var u = l * A;

    A *= m;
    w = 1 / w;
    var z = (d * (w - 1)) / w;
    var G = (pow(d, 2) - pow(z, 2)) / pow(d, 2);
    w = (pow(d, 2) - pow(z, 2)) / pow(z, 2);
    z = (d - z) / (d + z);
    var E = d *
        (1 -
            z +
            (5 * (pow(z, 2) - pow(z, 3))) / 4 +
            (81 * (pow(z, 4) - pow(z, 5))) / 64);
    var I = 3 *
        d *
        ((z -
            pow(z, 2) +
            (7 * (pow(z, 3) - pow(z, 4))) / 8 +
            (55 * pow(z, 5)) / 64)) /
        2;
    var J =
        (15 * d * (pow(z, 2) - pow(z, 3) + (3 * (pow(z, 4) - pow(z, 5))) / 4)) /
            16;
    var L = (35 * d * (pow(z, 3) - pow(z, 4) + (11 * pow(z, 5)) / 16)) / 48;
    var M = (315 * d * (pow(z, 4) - pow(z, 5))) / 512;
    D -= A;

    u = E * u -
        I * sin(2 * u) +
        J * sin(4 * u) -
        L * sin(6 * u) +
        M * sin(8 * u);
    z = u * c;
    var H = sin(o);
    u = cos(o);
    A = H / u;
    w *= pow(u, 2);
    G = d / sqrt(1 - G * pow(sin(o), 2));
    o = E * o -
        I * sin(2 * o) +
        J * sin(4 * o) -
        L * sin(6 * o) +
        M * sin(8 * o);
    o *= c;
    E = (G * H * u * c) / 2;
    I = (G * H * pow(u, 3) * c * (5 - pow(A, 2) + 9 * w + 4 * pow(w, 2))) / 24;
    J = (G *
            H *
            pow(u, 5) *
            c *
            (61 -
                58 * pow(A, 2) +
                pow(A, 4) +
                270 * w -
                330 * pow(A, 2) * w +
                445 * pow(w, 2) +
                324 * pow(w, 3) -
                680 * pow(A, 2) * pow(w, 2) +
                88 * pow(w, 4) -
                600 * pow(A, 2) * pow(w, 3) -
                192 * pow(A, 2) * pow(w, 4))) /
        720;
    H = (G *
            H *
            pow(u, 7) *
            c *
            (1385 - 3111 * pow(A, 2) + 543 * pow(A, 4) - pow(A, 6))) /
        40320;
    o = o + pow(D, 2) * E + pow(D, 4) * I + pow(D, 6) * J + pow(D, 8) * H;
    y = o - z + h;
    o = G * u * c;
    z = (G * pow(u, 3) * c * (1 - pow(A, 2) + w)) / 6;
    w = (G *
            pow(u, 5) *
            c *
            (5 -
                18 * pow(A, 2) +
                pow(A, 4) +
                14 * w -
                58 * pow(A, 2) * w +
                13 * pow(w, 2) +
                4 * pow(w, 3) -
                64 * pow(A, 2) * pow(w, 2) -
                25 * pow(A, 2) * pow(w, 3))) /
        120;
    u = (G *
            pow(u, 7) *
            c *
            (61 - 479 * pow(A, 2) + 179 * pow(A, 4) - pow(A, 6))) /
        5040;
    x = B + D * o + pow(D, 3) * z + pow(D, 5) * w + pow(D, 7) * u;
  }

  void TM2GP(
      double d, double e, double h, double f, double c, double l, double m) {
    var u = e;
    var a = y;
    var b = x;
    if (u > 1) u = 1 / u;
    var A = f;
    var w = atan(1) / 45;
    var o = l * w;
    var D = m * w;
    u = 1 / u;
    var B = (d * (u - 1)) / u;
    var z = (pow(d, 2) - pow(B, 2)) / pow(d, 2);
    u = (pow(d, 2) - pow(B, 2)) / pow(B, 2);
    B = (d - B) / (d + B);
    var G = d *
        (1 -
            B +
            5 * (pow(B, 2) - pow(B, 3)) / 4 +
            81 * (pow(B, 4) - pow(B, 5)) / 64);
    var E = 3 *
        d *
        (B -
            pow(B, 2) +
            7 * (pow(B, 3) - pow(B, 4)) / 8 +
            55 * pow(B, 5) / 64) /
        2;
    var I =
        15 * d * (pow(B, 2) - pow(B, 3) + 3 * (pow(B, 4) - pow(B, 5)) / 4) / 16;
    var J = 35 * d * (pow(B, 3) - pow(B, 4) + (11 * pow(B, 5) / 16)) / 48;
    var L = 315 * d * (pow(B, 4) - pow(B, 5)) / 512;
    o = G * o -
        E * sin(2 * o) +
        I * sin(4 * o) -
        J * sin(6 * o) +
        L * sin(8 * o);
    o *= c;
    o = a + o - h;
    var M = o / c;
    var H = d * (1 - z) / pow(sqrt(1 - z * pow(sin(o), 2)), 3);
    o = M / H;
    for (var i = 1; i <= 5; ++i) {
      B = G * o -
          E * sin(2 * o) +
          I * sin(4 * o) -
          J * sin(6 * o) +
          L * sin(8 * o);
      H = (d * (1 - z)) / pow(sqrt(1 - z * pow(sin(o), 2)), 3);
      o += (M - B) / H;
    }
    H = d * (1 - z) / pow(sqrt(1 - z * pow(sin(o), 2)), 3);
    G = d / sqrt(1 - z * pow(sin(o), 2));
    B = sin(o);
    z = cos(o);
    E = B / z;
    u *= pow(z, 2);
    A = b - A;
    B = E / (2 * H * G * pow(c, 2));
    I = (E * (5 + 3 * pow(E, 2) + u - 4 * pow(u, 2) - 9 * pow(E, 2) * u)) /
        (24 * H * pow(G, 3) * pow(c, 4));
    J = (E *
            (61 +
                90 * pow(E, 2) +
                46 * u +
                45 * pow(E, 4) -
                252 * pow(E, 2) * u -
                3 * pow(u, 2) +
                100 * pow(u, 3) -
                66 * pow(E, 2) * pow(u, 2) -
                90 * pow(E, 4) * u +
                88 * pow(u, 4) +
                225 * pow(E, 4) * pow(u, 2) +
                84 * pow(E, 2) * pow(u, 3) -
                192 * pow(E, 2) * pow(u, 4))) /
        (720 * H * pow(G, 5) * pow(c, 6));
    H = (E * (1385 + 3633 * pow(E, 2) + 4095 * pow(E, 4) + 1575 * pow(E, 6))) /
        (40320 * H * pow(G, 7) * pow(c, 8));
    o = o - pow(A, 2) * B + pow(A, 4) * I - pow(A, 6) * J + pow(A, 8) * H;
    B = 1 / (G * z * c);
    H = (1 + 2 * pow(E, 2) + u) / (6 * pow(G, 3) * z * pow(c, 3));
    u = (5 +
            6 * u +
            28 * pow(E, 2) -
            3 * pow(u, 2) +
            8 * pow(E, 2) * u +
            24 * pow(E, 4) -
            4 * pow(u, 3) +
            4 * pow(E, 2) * pow(u, 2) +
            24 * pow(E, 2) * pow(u, 3)) /
        (120 * pow(G, 5) * z * pow(c, 5));
    z = (61 + 662 * pow(E, 2) + 1320 * pow(E, 4) + 720 * pow(E, 6)) /
        (5040 * pow(G, 7) * z * pow(c, 7));
    A = A * B - pow(A, 3) * H + pow(A, 5) * u - pow(A, 7) * z;
    D += A;
    x = D / w;
    y = o / w;
  }

  void setParameter(double a, double b, double d, double e, double h, double x,
      double y, int l) {
    m_dx = a;
    m_dy = b;
    m_dz = d;
    m_omega = e / 3600 * A;
    m_phi = h / 3600 * A;
    m_kappa = x / 3600 * A;
    m_ds = y * 1.0E-6;
    m_imode = l;
  }

  void shiftIsland(bool pTF) {
    double x, y;
    List<Map<String, dynamic>> rectArray1 = [
      {'x': 112500, 'y': -50000, 'w': 33500, 'h': 53000},
      {'x': 146000, 'y': -50000, 'w': 54000, 'h': 58600},
      {'x': 130000, 'y': 44000, 'w': 15000, 'h': 14000},
      {'x': 532500, 'y': 437500, 'w': 25000, 'h': 25000},
      {'x': 625000, 'y': 412500, 'w': 25000, 'h': 25000},
      {'x': -12500, 'y': 462500, 'w': 17500, 'h': 50000},
    ];
    if (pTF) {
      double e = 0, h = 0;
      List<List<double>> deltaValue1 = [
        [0, 50000],
        [0, 50000],
        [0, 10000],
        [-70378, -136],
        [-144738, -2161],
        [23510, -111],
      ];
      for (int i = 0; i < rectArray1.length; ++i) {
        if (this.x - rectArray1[i]['x'] >= 0 &&
            this.x - rectArray1[i]['x'] <= rectArray1[i]['w'] &&
            this.y - rectArray1[i]['y'] >= 0 &&
            this.y - rectArray1[i]['y'] <= rectArray1[i]['h']) {
          e += deltaValue1[i][0];
          h += deltaValue1[i][1];
          break;
        }
      }
      x = (this.x + e) * 2.5 + 0.5;
      y = (this.y + h) * 2.5 + 0.5;
    } else {
      x = this.x / 2.5;
      y = this.y / 2.5;
      List<List<double>> deltaValue2 = [
        [0, -50000],
        [0, -50000],
        [0, -10000],
        [70378, 136],
        [144738, 2161],
        [-23510, 111],
      ];
      for (int i = 0; i < rectArray1.length; ++i) {
        if (x - rectArray1[i]['x'] >= 0 &&
            x - rectArray1[i]['x'] <= rectArray1[i]['w'] &&
            y - rectArray1[i]['y'] >= 0 &&
            y - rectArray1[i]['y'] <= rectArray1[i]['h']) {
          x += deltaValue2[i][0];
          y += deltaValue2[i][1];
          break;
        }
      }
    }
    this.x = x;
    this.y = y;
  }
}

Document coordconvWGS84ToWCONGNAMUL(
  double x,
  double y,
) {
  CoordConv vCoordConv = CoordConv();
  return vCoordConv.getTransCoord(x, y, 7, 3);
}

Document coordconvWCONGNAMULToWGS84(
  double x,
  double y,
) {
  CoordConv vCoordConv = CoordConv();
  return vCoordConv.getTransCoord(x, y, 3, 7);
}
