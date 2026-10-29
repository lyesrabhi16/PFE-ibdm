"""Realistic value profiles for the demo sensor tables.

Each field gets a profile (tank level, flow, counter, pressure, ...). `next_value` advances a field by
`step` minutes, so the same logic generates the 30-day history (seed_data.py) and the live readings
(simulate.py). Everything stays inside the healthy ranges used by the app's dashboards.
"""
import math
import random
import zlib
from datetime import timedelta

# Tank capacities (the Flutter app computes fill % = value * 100 / capacity)
CAP_SUCRE = {"t_s21": 60000, "t_s22": 60000, "t_s23": 60000, "t_s24": 60000, "t_s25": 60000,
             "a_t02": 140000, "a_t03": 140000, "a_t04": 140000, "a_t05": 60000, "a_t06": 60000}
CAP_NIVEAU = {"niv_f1": 450, "niv_f2": 450, "niv_uf1": 520, "niv_uf2": 520, "niv_os1": 60, "niv_os2": 60,
              "niv_os3": 60, "niv_os4": 180, "niv_os5": 45, "niv_os6": 45, "niv_os7": 10}
CAP_CO2 = {"ut_co2_vc1": 36000, "ut_co2_vc2": 60000, "ut_n2_vn2": 10000}

# (base, spread) tuned to the thresholds hard-coded in the Flutter Utilité page (blue/orange = ok, red = danger)
UTILITE_BASE = {"p7": (7.5, 0.25), "pn2": (8.2, 0.3), "p40": (37.5, 0.8), "pv": (8.0, 0.3),
                "pg": (280.0, 6.0), "tt": (3.8, 0.4), "tc": (27.0, 1.5)}


def _params(table, field):
    """Stable per-field random parameters."""
    return random.Random(zlib.crc32(f"{table}.{field}".encode()))


def activity(ts):
    """0.3 (night) .. 1.0 (production hours), lower on weekends."""
    h = ts.hour + ts.minute / 60
    day = 0.3 + 0.7 / (1 + math.exp(-(h - 6) * 1.2)) / (1 + math.exp((h - 22) * 1.2))
    return day * (0.8 if ts.weekday() >= 5 else 1.0)


def spec(table, field):
    r = _params(table, field)
    t = table.lower()
    if t == "sucre":
        return dict(kind="tank", cap=CAP_SUCRE[field], lo=0.22, hi=0.92, daily=r.uniform(0.12, 0.2))
    if t == "niveau":
        return dict(kind="smooth", cap=CAP_NIVEAU[field], mid=0.74, amp=r.uniform(0.07, 0.12),
                    period=r.uniform(300, 1100), phase=r.uniform(0, 6.28), noise=0.012)
    if t == "debit":
        base = r.uniform(18, 62) if not field.startswith("d_f") else r.uniform(38, 56)
        return dict(kind="flow", base=base)
    if t == "volume":
        feeds = {"vol_for": ("d_f1", "d_f2"), "vol_con_lav": ()}
        feed = feeds.get(field, ("d_" + field[4:],))
        # the app sums these per day (calculate_consommation_filtration), so they restart at 00:00:30 every day
        return dict(kind="counter", feed=feed, start=r.uniform(100, 400), table_feed="debit", daily=True,
                    const=2.5 if field == "vol_con_lav" else 0)
    if t == "prescond":
        if field.startswith("p"):
            return dict(kind="wave", base=r.uniform(2.8, 6.8), rel=0.07, period=r.uniform(200, 900), phase=r.uniform(0, 6.28))
        return dict(kind="wave", base=r.uniform(180, 620), rel=0.05, period=r.uniform(300, 900), phase=r.uniform(0, 6.28))
    if t == "co2ifruit":
        if field in CAP_CO2:
            return dict(kind="tank", cap=CAP_CO2[field], lo=0.35, hi=0.9, daily=r.uniform(0.1, 0.16))
        n = field[len("ut_co2_"):] if field.startswith("ut_co2_") else field
        if field in ("ut_co2_pc1", "ut_co2_pc2", "ut_n2_pn2", "ut_co2_pn", "ut_co2_de", "ut_co2_ve", "ut_soude"):
            return dict(kind="wave", base=r.uniform(10.5, 14.5), rel=0.04, period=r.uniform(240, 700), phase=r.uniform(0, 6.28))
        if n.startswith("d"):
            return dict(kind="flow", base=r.uniform(6, 34))
        if n.startswith("v"):
            return dict(kind="counter", feed=("ut_co2_d" + n[1:],), start=r.uniform(500, 6000), table_feed="co2ifruit", const=0)
        if n.startswith("p"):
            return dict(kind="wave", base=r.uniform(5.0, 9.0), rel=0.06, period=r.uniform(200, 800), phase=r.uniform(0, 6.28))
    if t == "utilite":
        base, spread = UTILITE_BASE[field.split("_")[-1]]
        return dict(kind="wave", base=base, rel=spread / base, period=r.uniform(200, 900), phase=r.uniform(0, 6.28))
    return dict(kind="wave", base=r.uniform(5, 10), rel=0.05, period=500, phase=0)


def next_value(sp, ts, prev, step, row, rng):
    """Advance one field. `step` is in minutes; `row` holds the current row's already-computed fields."""
    k = sp["kind"]
    minutes = ts.timestamp() / 60
    if k == "tank":
        cap = sp["cap"]
        if prev is None:
            return round(cap * rng.uniform(0.55, 0.85), 2)
        drain = cap * sp["daily"] / 1440 * step * activity(ts) * rng.uniform(0.7, 1.3)
        value = prev - drain
        if value < cap * sp["lo"]:  # a delivery tops the tank up
            value = cap * rng.uniform(0.8, sp["hi"])
        return round(min(value, cap * sp["hi"]), 2)
    if k == "smooth":
        frac = sp["mid"] + sp["amp"] * math.sin(2 * math.pi * minutes / sp["period"] + sp["phase"]) + rng.gauss(0, sp["noise"])
        return round(sp["cap"] * min(max(frac, 0.58), 0.9), 2)
    if k == "flow":
        return round(max(0.0, sp["base"] * (0.45 + 0.55 * activity(ts)) * (1 + rng.gauss(0, 0.03))), 2)
    if k == "wave":
        v = sp["base"] * (1 + sp["rel"] * math.sin(2 * math.pi * minutes / sp["period"] + sp["phase"]) + rng.gauss(0, sp["rel"] / 6))
        return round(v, 2)
    if k == "counter":
        flow = sp["const"] * activity(ts)
        for f in sp["feed"]:
            if f in row:
                flow += row[f]
            else:  # feeding flow lives in another table: evaluate its (stateless) profile
                flow += next_value(spec(sp["table_feed"], f), ts, None, step, row, rng)
        base = sp["start"] if prev is None else prev
        # Daily totals: the app reads each day's value at 00:00:00 (get_value_at), i.e. the final total of the day that
        # just ended; the counter restarts at 00:00:30. So a "consumption on day D" figure is the total of the previous day.
        if sp.get("daily") and prev is not None:
            cut = timedelta(seconds=30)
            if (ts - cut).date() != (ts - timedelta(minutes=step) - cut).date():
                base = 0.0
        return round(base + flow * step / 60, 2)
    raise ValueError(k)


def table_fields(model):
    return [f.name for f in model._meta.concrete_fields if f.get_internal_type() == "FloatField"]


def compute_row(model, ts, prev_row, step, rng):
    """Return {field: value} for one timestamp (flows/tanks first, counters after)."""
    table = model.__name__
    fields = table_fields(model)
    specs = {f: spec(table, f) for f in fields}
    row = {}
    for f in fields:
        if specs[f]["kind"] != "counter":
            row[f] = next_value(specs[f], ts, (prev_row or {}).get(f), step, row, rng)
    for f in fields:
        if specs[f]["kind"] == "counter":
            row[f] = next_value(specs[f], ts, (prev_row or {}).get(f), step, row, rng)
    return row
