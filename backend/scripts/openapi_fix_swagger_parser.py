
import json
import os

print("Starting Swagger OpenAPI client Spec update...")
base_path = os.path.abspath(os.path.dirname(__file__)).split('backend')[0]
replacer_path = os.path.join(base_path, 'backend', 'replacer.json')
openapi_client_path = os.path.join(base_path, 'frontend', 'ibdm', 'lib', 'api', 'openapi.spec.json')

print(f"openapi client loaded: {os.path.exists(openapi_client_path)}")

with open(openapi_client_path, 'r') as f:
    openapi_client : dict = json.load(f)

with open(replacer_path, 'r') as f:
    replacer : dict = json.load(f)

for key in replacer:
    json_schema_path = key.split(".")
    element = openapi_client[json_schema_path[0]]
    first_element = json_schema_path.pop(0)
    _replacer = {
        json_schema_path[-1]: replacer[key] 
    }
    replacer_content = []
    for k in json_schema_path:
        replacer_content.append(element[k])
        element = element[k]
    replacer_content.pop()
    replacer_content.append(replacer[key])
    reversed_json_schema_path = list(reversed(json_schema_path))
    reversed_replacer_content = list(reversed(replacer_content))
    d = {}
    for i in range(len(json_schema_path)):
        content = reversed_replacer_content[i]
        if (len(d.keys()) >= 1):
            content[list(d.keys())[0]] = d[list(d.keys())[0]]
        d = {
            reversed_json_schema_path[i]: content
        }

    openapi_client[first_element] = d
    print(f"updated '{key}' ")


with open(openapi_client_path, 'w') as f:
    json.dump(openapi_client, f, indent=4)
    f.write('\n')

print("Swagger OpenAPI client Spec updated successfully!")