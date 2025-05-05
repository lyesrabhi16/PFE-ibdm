from .models import Co2Ifruit
from api_v1.utils import get_value_at
from .serializers import Co2IfruitSerializer

def get_co2_consommation(from_date, to_date):
    #print("from_date", from_date)
    #print("to_date", to_date)
    from_record = Co2IfruitSerializer(get_value_at(Co2Ifruit, from_date)).data
    to_record = Co2IfruitSerializer(get_value_at(Co2Ifruit, to_date)).data
    record = {}
    for key in from_record:
        try:
            record[key] = float(to_record[key]) - float(from_record[key])
        except Exception as e:
            record[key] = None
    record["from_date"] = from_date
    record["to_date"] = to_date
    record["from_value"] = from_record
    record["to_value"] = to_record
    record["date"] = to_date
    return record
