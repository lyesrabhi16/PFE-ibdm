import 'package:ibdm/services/api/api_client.dart';
import '../services/api_django/api_client/export.dart';

class Graphs {
  static Future<Map> getSucreTotalGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "Tetra": [],
      "Adue": [],
    };
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getSucresBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (Sucre e in res.data) {
      data["Tetra"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": (e.tS21 ?? 0) +
            (e.tS22 ?? 0) +
            (e.tS23 ?? 0) +
            (e.tS24 ?? 0) +
            (e.tS25 ?? 0),
      });
      data["Adue"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": (e.aT02 ?? 0) +
            (e.aT03 ?? 0) +
            (e.aT04 ?? 0) +
            (e.aT05 ?? 0) +
            (e.aT06 ?? 0),
      });
    }
    return data;
  }

  static Future<Map> getSucreTetraGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "TS21": [],
      "TS22": [],
      "TS23": [],
      "TS24": [],
      "TS25": [],
    };
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getSucresBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (Sucre e in res.data) {
      data["TS21"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.tS21 ?? 0,
      });
      data["TS22"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.tS22 ?? 0,
      });
      data["TS23"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.tS23 ?? 0,
      });
      data["TS24"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.tS24 ?? 0,
      });
      data["TS25"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.tS25 ?? 0,
      });
    }
    return data;
  }

  static Future<Map> getSucreAdueGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "T02": [],
      "T03": [],
      "T04": [],
      "T05": [],
      "T06": [],
    };
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getSucresBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (Sucre e in res.data) {
      data["T02"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.aT02 ?? 0,
      });
      data["T03"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.aT03 ?? 0,
      });
      data["T04"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.aT04 ?? 0,
      });
      data["T05"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.aT05 ?? 0,
      });
      data["T06"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.aT06 ?? 0,
      });
    }
    return data;
  }

  static Future<Map> getFiltrationConsommationGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "forage": [],
      "eau_brute": [],
      "hytec": [],
      "osmotec": [],
      "osmosee": [],
      "contre_lavage": [],
    };

    final api = await ApiClientInstance.getApiClient();
    final res = await api.getFiltrationConsommationBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
    );
    for (var e in res.consommations) {
      if (data.containsKey("forage")) {
        data["forage"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.forage ?? 0,
        });
      }
      if (data.containsKey("eau_brute")) {
        data["eau_brute"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.eauBrute ?? 0,
        });
      }
      if (data.containsKey("hytec")) {
        data["hytec"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.hytec ?? 0,
        });
      }
      if (data.containsKey("osmotec")) {
        data["osmotec"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.osmotec ?? 0,
        });
      }
      if (data.containsKey("osmosee")) {
        data["osmosee"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.osmosee ?? 0,
        });
      }
      if (data.containsKey("contre_lavage")) {
        data["contre_lavage"].add({
          "x": e.fromDate.millisecondsSinceEpoch,
          "y": e.consommation.contreLavage ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getFiltrationNiveauGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includeEauBrute = true,
    bool includeEauFiltre = true,
    bool includeEauOsmosee = true,
    bool includeHytec = false,
    bool includeOsmotec = false,
    bool includeDoubleOsmose = true,
    bool detailEauBrute = false,
    bool detailEauFiltre = false,
    bool detailEauOsmosee = false,
    bool detailHytec = false,
    bool detailOsmotec = false,
  }) async {
    Map data = {};
    if (includeEauBrute) {
      if (detailEauBrute) {
        data["F1"] = [];
        data["F2"] = [];
      } else {
        data["Eau Brute"] = [];
      }
    }
    if (includeEauFiltre) {
      if (detailEauFiltre) {
        data["UF1"] = [];
        data["UF2"] = [];
      } else {
        data["Eau Filtrée"] = [];
      }
    }
    if (includeEauOsmosee) {
      if (detailEauOsmosee) {
        data["OS1"] = [];
        data["OS2"] = [];
        data["OS3"] = [];
        data["OS4"] = [];
        data["OS5"] = [];
        data["OS6"] = [];
      } else {
        data["Eau Osmosée"] = [];
      }
    }
    if (includeHytec) {
      if (detailHytec) {
        data["OS1"] = [];
        data["OS2"] = [];
        data["OS3"] = [];
        data["OS4"] = [];
      } else {
        data["Hytec"] = [];
      }
    }
    if (includeOsmotec) {
      if (detailOsmotec) {
        data["OS5"] = [];
        data["OS6"] = [];
      } else {
        data["Osmotec"] = [];
      }
    }
    if (includeDoubleOsmose) {
      data["Double Osmose Utilité"] = [];
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getNiveauxBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (includeEauBrute) {
        if (detailEauBrute) {
          data["F1"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivF1 ?? 0,
          });
          data["F2"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivF2 ?? 0,
          });
        } else {
          data["Eau Brute"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": (e.nivF1 ?? 0) + (e.nivF2 ?? 0),
          });
        }
      }
      if (includeEauFiltre) {
        if (detailEauFiltre) {
          data["UF1"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivUf1 ?? 0,
          });
          data["UF2"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivUf2 ?? 0,
          });
        } else {
          data["Eau Filtrée"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": (e.nivUf1 ?? 0) + (e.nivUf2 ?? 0),
          });
        }
      }
      if (includeEauOsmosee) {
        if (detailEauOsmosee) {
          data["OS1"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs1 ?? 0,
          });
          data["OS2"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs2 ?? 0,
          });
          data["OS3"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs3 ?? 0,
          });
          data["OS4"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs4 ?? 0,
          });
          data["OS5"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs5 ?? 0,
          });
          data["OS6"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs6 ?? 0,
          });
        } else {
          data["Eau Osmosée"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": (e.nivOs1 ?? 0) +
                (e.nivOs2 ?? 0) +
                (e.nivOs3 ?? 0) +
                (e.nivOs4 ?? 0) +
                ((e.nivOs5 ?? 0) + (e.nivOs6 ?? 0)) / 2 * 7,
          });
        }
      }
      if (includeHytec) {
        if (detailHytec) {
          data["OS1"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs1 ?? 0,
          });
          data["OS2"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs2 ?? 0,
          });
          data["OS3"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs3 ?? 0,
          });
          data["OS4"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs4 ?? 0,
          });
        } else {
          data["Hytec"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": (e.nivOs1 ?? 0) +
                (e.nivOs2 ?? 0) +
                (e.nivOs3 ?? 0) +
                (e.nivOs4 ?? 0),
          });
        }
      }
      if (includeOsmotec) {
        if (detailOsmotec) {
          data["OS5"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs5 ?? 0,
          });
          data["OS6"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": e.nivOs6 ?? 0,
          });
        } else {
          data["Osmotec"].add({
            "x": e.date.millisecondsSinceEpoch,
            "y": (e.nivOs5 ?? 0) + (e.nivOs6 ?? 0),
          });
        }
      }
      if (includeDoubleOsmose) {
        data["Double Osmose Utilité"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.nivOs7 ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getFiltrationVolumeGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includeContreLavage = true,
    bool includeForage = true,
    bool includeUF = true,
    bool includeOS = true,
    bool detailUF = false,
    bool detailOS = false,
  }) async {
    Map data = {};
    if (includeContreLavage) {
      data["contre lavage"] = [];
    }
    if (includeForage) {
      data["forage"] = [];
    }
    if (includeUF) {
      if (detailUF) {
        data["UF1"] = [];
        data["UF2"] = [];
        data["UF3"] = [];
        data["UF4"] = [];
        data["UF5"] = [];
        data["UF6"] = [];
      } else {
        data["UF"] = [];
      }
    }
    if (includeOS) {
      if (detailOS) {
        data["OS1"] = [];
        data["OS2"] = [];
        data["OS3"] = [];
        data["OS4"] = [];
        data["OS5"] = [];
        data["OS6"] = [];
        data["OS7"] = [];
        data["OS8"] = [];
        data["OS9"] = [];
      } else {
        data["OS"] = [];
      }
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getVolumesBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (data.containsKey("contre lavage")) {
        data["contre lavage"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volConLav ?? 0,
        });
      }
      if (data.containsKey("forage")) {
        data["forage"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volFor ?? 0,
        });
      }
      if (data.containsKey("UF1")) {
        data["UF1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf1 ?? 0,
        });
      }
      if (data.containsKey("UF2")) {
        data["UF2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf2 ?? 0,
        });
      }
      if (data.containsKey("UF3")) {
        data["UF3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf3 ?? 0,
        });
      }
      if (data.containsKey("UF4")) {
        data["UF4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf4 ?? 0,
        });
      }
      if (data.containsKey("UF5")) {
        data["UF5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf5 ?? 0,
        });
      }
      if (data.containsKey("UF6")) {
        data["UF6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volUf6 ?? 0,
        });
      }
      if (data.containsKey("UF")) {
        data["UF"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.volUf1 ?? 0) +
              (e.volUf2 ?? 0) +
              (e.volUf3 ?? 0) +
              (e.volUf4 ?? 0) +
              (e.volUf5 ?? 0) +
              (e.volUf6 ?? 0),
        });
      }
      if (data.containsKey("OS1")) {
        data["OS1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs1 ?? 0,
        });
      }
      if (data.containsKey("OS2")) {
        data["OS2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs2 ?? 0,
        });
      }
      if (data.containsKey("OS3")) {
        data["OS3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs3 ?? 0,
        });
      }
      if (data.containsKey("OS4")) {
        data["OS4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs4 ?? 0,
        });
      }
      if (data.containsKey("OS5")) {
        data["OS5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs5 ?? 0,
        });
      }
      if (data.containsKey("OS6")) {
        data["OS6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs6 ?? 0,
        });
      }
      if (data.containsKey("OS7")) {
        data["OS7"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs7 ?? 0,
        });
      }
      if (data.containsKey("OS8")) {
        data["OS8"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs8 ?? 0,
        });
      }
      if (data.containsKey("OS9")) {
        data["OS9"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.volOs9 ?? 0,
        });
      }
      if (data.containsKey("OS")) {
        data["OS"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.volOs1 ?? 0) +
              (e.volOs2 ?? 0) +
              (e.volOs3 ?? 0) +
              (e.volOs4 ?? 0) +
              (e.volOs5 ?? 0) +
              (e.volOs6 ?? 0),
        });
      }
    }
    return data;
  }

  static Future<Map> getFiltrationPressionGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includeOS = true,
    bool includeUF = true,
    bool includeOSE = false,
    bool includeHytec = false,
    bool includeOsmotec = false,
    bool includeUtilite = false,
  }) async {
    Map data = {};

    if (includeOS) {
      data["os1"] = [];
      data["os2"] = [];
      data["os3"] = [];
      data["os4"] = [];
      data["os5"] = [];
      data["os6"] = [];
      data["os8"] = [];
      data["os9"] = [];
      data["os7"] = [];
      data["os71"] = [];
      data["conc"] = [];
      data["ose1"] = [];
      data["ose2"] = [];
    }

    if (includeHytec) {
      data["os1"] = [];
      data["os2"] = [];
      data["os3"] = [];
    }
    if (includeOsmotec) {
      data["os4"] = [];
      data["os5"] = [];
      data["os6"] = [];
      data["os8"] = [];
      data["os9"] = [];
    }
    if (includeUtilite) {
      data["os7"] = [];
      data["os71"] = [];
    }
    if (includeOSE) {
      data["conc"] = [];
      data["ose1"] = [];
      data["ose2"] = [];
    }
    if (includeUF) {
      data["uf"] = [];
      data["uf4"] = [];
      data["uf6"] = [];
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getPresCondsBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (data.containsKey("conc")) {
        data["conc"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pConc ?? 0,
        });
      }
      if (data.containsKey("os1")) {
        data["os1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs1 ?? 0,
        });
      }
      if (data.containsKey("os2")) {
        data["os2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs2 ?? 0,
        });
      }
      if (data.containsKey("os3")) {
        data["os3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs3 ?? 0,
        });
      }
      if (data.containsKey("os4")) {
        data["os4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs4 ?? 0,
        });
      }
      if (data.containsKey("os5")) {
        data["os5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs5 ?? 0,
        });
      }
      if (data.containsKey("os6")) {
        data["os6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs6 ?? 0,
        });
      }
      if (data.containsKey("os7")) {
        data["os7"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs7 ?? 0,
        });
      }
      if (data.containsKey("os8")) {
        data["os8"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs8 ?? 0,
        });
      }
      if (data.containsKey("os9")) {
        data["os9"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs9 ?? 0,
        });
      }
      if (data.containsKey("os71")) {
        data["os71"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOs71 ?? 0,
        });
      }
      if (data.containsKey("ose1")) {
        data["ose1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOse1 ?? 0,
        });
      }
      if (data.containsKey("ose2")) {
        data["ose2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pOse2 ?? 0,
        });
      }

      if (data.containsKey("uf")) {
        data["uf"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pUf ?? 0,
        });
      }
      if (data.containsKey("uf4")) {
        data["uf4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pUf4 ?? 0,
        });
      }
      if (data.containsKey("uf6")) {
        data["uf6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.pUf6 ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getFiltrationDebitGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includeForage = true,
    bool includeUF = true,
    bool includeOS = true,
    bool includeHytec = false,
    bool includeOsmotec = false,
    bool detailForage = false,
    bool detailUF = false,
    bool detailOS = false,
    bool detailHytec = false,
    bool detailOsmotec = false,
  }) async {
    Map data = {};
    if (includeForage) {
      if (detailForage) {
        data["F1"] = [];
        data["F2"] = [];
      } else {
        data["Forage"] = [];
      }
    }
    if (includeUF) {
      if (detailUF) {
        data["UF1"] = [];
        data["UF2"] = [];
        data["UF3"] = [];
        data["UF4"] = [];
        data["UF5"] = [];
        data["UF6"] = [];
      } else {
        data["UF"] = [];
      }
    }
    if (includeOS) {
      if (detailOS) {
        data["OS1"] = [];
        data["OS2"] = [];
        data["OS3"] = [];
        data["OS4"] = [];
        data["OS5"] = [];
        data["OS6"] = [];
        data["OS7"] = [];
        data["OS8"] = [];
        data["OS9"] = [];
      } else {
        data["OS"] = [];
      }
    }
    if (includeHytec) {
      if (detailHytec) {
        data["OS1"] = [];
        data["OS2"] = [];
        data["OS3"] = [];
        data["OS4"] = [];
      } else {
        data["Hytec"] = [];
      }
    }
    if (includeOsmotec) {
      if (detailOsmotec) {
        data["OS5"] = [];
        data["OS6"] = [];
      } else {
        data["Osmotec"] = [];
      }
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getDebitsBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (data.containsKey("F1")) {
        data["F1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dF1 ?? 0,
        });
      }
      if (data.containsKey("F2")) {
        data["F2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dF2 ?? 0,
        });
      }
      if (data.containsKey("Forage")) {
        data["Forage"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.dF1 ?? 0) + (e.dF2 ?? 0),
        });
      }
      if (data.containsKey("UF1")) {
        data["UF1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf1 ?? 0,
        });
      }
      if (data.containsKey("UF2")) {
        data["UF2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf2 ?? 0,
        });
      }
      if (data.containsKey("UF3")) {
        data["UF3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf3 ?? 0,
        });
      }
      if (data.containsKey("UF4")) {
        data["UF4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf4 ?? 0,
        });
      }
      if (data.containsKey("UF5")) {
        data["UF5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf5 ?? 0,
        });
      }
      if (data.containsKey("UF6")) {
        data["UF6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dUf6 ?? 0,
        });
      }
      if (data.containsKey("UF")) {
        data["UF"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.dUf1 ?? 0) +
              (e.dUf2 ?? 0) +
              (e.dUf3 ?? 0) +
              (e.dUf4 ?? 0) +
              (e.dUf5 ?? 0) +
              (e.dUf6 ?? 0),
        });
      }
      if (data.containsKey("OS1")) {
        data["OS1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs1 ?? 0,
        });
      }
      if (data.containsKey("OS2")) {
        data["OS2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs2 ?? 0,
        });
      }
      if (data.containsKey("OS3")) {
        data["OS3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs3 ?? 0,
        });
      }
      if (data.containsKey("OS4")) {
        data["OS4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs4 ?? 0,
        });
      }
      if (data.containsKey("OS5")) {
        data["OS5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs5 ?? 0,
        });
      }
      if (data.containsKey("OS6")) {
        data["OS6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs6 ?? 0,
        });
      }
      if (data.containsKey("OS7")) {
        data["OS7"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs7 ?? 0,
        });
      }
      if (data.containsKey("OS8")) {
        data["OS8"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs8 ?? 0,
        });
      }
      if (data.containsKey("OS9")) {
        data["OS9"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.dOs9 ?? 0,
        });
      }
      if (data.containsKey("Hytec")) {
        data["Hytec"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.dOs1 ?? 0) + (e.dOs2 ?? 0) + (e.dOs3 ?? 0) + (e.dOs4 ?? 0),
        });
      }
      if (data.containsKey("Osmotec")) {
        data["Osmotec"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.dOs5 ?? 0) + (e.dOs6 ?? 0),
        });
      }
      if (data.containsKey("OS")) {
        data["OS"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": (e.dOs1 ?? 0) +
              (e.dOs2 ?? 0) +
              (e.dOs3 ?? 0) +
              (e.dOs4 ?? 0) +
              (e.dOs5 ?? 0) +
              (e.dOs6 ?? 0),
        });
      }
    }
    return data;
  }

  static Future<Map> getFiltrationConductiviteGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includeOS = true,
    bool includeUF = true,
  }) async {
    Map data = {};
    if (includeOS) {
      data["OS1"] = [];
      data["OS2"] = [];
      data["OS3"] = [];
      data["OS4"] = [];
      data["OS5"] = [];
      data["OS6"] = [];
      data["OS7"] = [];
      data["OS8"] = [];
      data["OS9"] = [];
      data["OSE"] = [];
    }
    if (includeUF) {
      data["UF"] = [];
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getPresCondsBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (data.containsKey("OS1")) {
        data["OS1"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs1 ?? 0,
        });
        data["OS2"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs2 ?? 0,
        });
        data["OS3"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs3 ?? 0,
        });
        data["OS4"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs4 ?? 0,
        });
        data["OS5"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs5 ?? 0,
        });
        data["OS6"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs6 ?? 0,
        });
        data["OS7"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs7 ?? 0,
        });
        data["OS8"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs8 ?? 0,
        });
        data["OS9"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOs9 ?? 0,
        });
        data["OSE"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cOse ?? 0,
        });
      }
      if (data.containsKey("UF")) {
        data["UF"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.cUf ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getUtiliteTempGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool inludeTrane = true,
    bool includeCompresseur = true,
  }) async {
    Map data = {};
    if (inludeTrane) {
      data["Temp Trane Krones"] = [];
      data["Temp Trane Sidel"] = [];
    }
    if (includeCompresseur) {
      data["Temp Compresseur Krones"] = [];
      data["Temp Compresseur Sidel"] = [];
    }
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getUtiliteBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (inludeTrane) {
        data["Temp Trane Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrTt ?? 0,
        });
        data["Temp Trane Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidTt ?? 0,
        });
      }
      if (includeCompresseur) {
        data["Temp Compresseur Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrTc ?? 0,
        });
        data["Temp Compresseur Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidTc ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getUtilitePressionGraphData(
    DateTime startDate,
    DateTime endDate,
    FetchType? fetchType, {
    bool includePression7 = true,
    bool includePression40 = true,
    bool includePressionAzote = true,
    bool includePressionChaudiere = true,
    bool includePressionGaz = true,
  }) async {
    Map data = {};
    if (includePression7) {
      data["Pression 7 Krones"] = [];
      data["Pression 7 Sidel"] = [];
    }
    if (includePression40) {
      data["Pression 40 Krones"] = [];
      data["Pression 40 Sidel"] = [];
    }
    if (includePressionAzote) {
      data["Pression Azote Krones"] = [];
      data["Pression Azote Sidel"] = [];
    }
    if (includePressionChaudiere) {
      data["Pression Chaudiere Krones"] = [];
      data["Pression Chaudiere Sidel"] = [];
    }
    if (includePressionGaz) {
      data["Pression Gaz Krones"] = [];
      data["Pression Gaz Sidel"] = [];
    }

    final api = await ApiClientInstance.getApiClient();
    final res = await api.getUtiliteBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      if (includePression7) {
        data["Pression 7 Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrP7 ?? 0,
        });
        data["Pression 7 Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidP7 ?? 0,
        });
      }
      if (includePression40) {
        data["Pression 40 Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrP40 ?? 0,
        });
        data["Pression 40 Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidP40 ?? 0,
        });
      }
      if (includePressionAzote) {
        data["Pression Azote Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrPn2 ?? 0,
        });
        data["Pression Azote Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidPn2 ?? 0,
        });
      }
      if (includePressionChaudiere) {
        data["Pression Chaudiere Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrPv ?? 0,
        });
        data["Pression Chaudiere Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidPv ?? 0,
        });
      }
      if (includePressionGaz) {
        data["Pression Gaz Krones"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utKrPg ?? 0,
        });
        data["Pression Gaz Sidel"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utSidPg ?? 0,
        });
      }
    }
    return data;
  }

  static Future<Map> getCO2NiveauGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "MGI": [],
      "CEVITAL": [],
      "N2": [],
    };
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getCo2BetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      data["MGI"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utCo2Vc1 ?? 0,
      });
      data["CEVITAL"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utCo2Vc2 ?? 0,
      });
      data["N2"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utN2Vn2 ?? 0,
      });
    }
    return data;
  }

  static Future<Map> getCO2PressionGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    Map data = {
      "MGI": [],
      "CEVITAL": [],
      "N2": [],
      "NOURISSE": [],
      "SOUDE": [],
    };
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getCo2BetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      enablePagination: false,
      fetchType: fetchType,
    );
    for (var e in res.data) {
      data["MGI"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utCo2Pc1 ?? 0,
      });
      data["CEVITAL"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utCo2Pc2 ?? 0,
      });
      data["N2"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utN2Pn2 ?? 0,
      });
      data["NOURISSE"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utCo2Pn ?? 0,
      });
      data["SOUDE"].add({
        "x": e.date.millisecondsSinceEpoch,
        "y": e.utSoude ?? 0,
      });
    }
    return data;
  }
}
