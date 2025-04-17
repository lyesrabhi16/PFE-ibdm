import re
import hashlib
import base64
from cryptography.fernet import Fernet
from copy import deepcopy


def encrypt(value):
    from api_v1.env import Env
    if str(value).startswith("gAAAAAB"):
        #print("value is encrypted")
        return value
    #print("ENCRYPT", value)
    crypto = Fernet(get_fernet_key_from_django_secret(Env.SECRET_KEY))
    return crypto.encrypt(value.encode("utf-8")).decode("utf-8")
def decrypt(token):
    from api_v1.env import Env
    # If token is a string, encode it to bytes
    if isinstance(token, str):
        # Check if it's an encoded string that needs to be decoded
        if token.startswith("gAAAAAB"):  # Fernet tokens typically start with this prefix
            try:
                #print("DECRYPT")
                token_bytes = token.encode('utf-8')
                crypto = Fernet(get_fernet_key_from_django_secret(Env.SECRET_KEY))
                decrypted = crypto.decrypt(token_bytes)
                decrypted_str = decrypted.decode("utf-8")
                return decrypted_str
            except Exception as e:
                print(f"Failed to decrypt: {e}")
                return token
        else:
            # Not an encrypted token, return as is
            #print("Token doesn't appear to be encrypted")
            return token
    return token


def get_nested_dict_values(data, path):
    """
    Update values in a nested dictionary based on a path pattern, 
    using a function to transform old values to new values.
    
    Args:
        data (dict): The dictionary to update
        path (str): Path pattern (e.g. 'key1.key2')
        
    Returns:
        list: The list of values (path, value)
    """
    def _process(data, keys, index, results, path=None):
                    if len(keys) == index + 1:
                        if keys[index] == "*":
                                for key in data:
                                        _path = deepcopy(path)
                                        _key = keys[index]
                                        if "." in _key:
                                            _key = f"<{_key.count(".") + 1}>.{_key}"
                                        if _path is None:
                                            _path = _key
                                        else:
                                            _path += f".{_key}"
                                        #print(f"append nested value: path({_path}) key({key}) value({data[key]})")
                                        results.append((_path,data[key]))
                                return
                        
                        _key = keys[index]
                        if "." in _key:
                            _key = f"<{_key.count(".") + 1}>.{_key}"

                        if path is None:
                            path = _key
                        else:
                            path += f".{_key}"
                        _path = path
                        #print(f"append nested value: path({path}) key({keys[index]}) value({data[keys[index]]})")
                        results.append((_path,data[keys[index]]))
                        return
                    if keys[index] != "*":
                        _key = keys[index]
                        if "." in _key:
                            _key = f"<{_key.count(".") + 1}>.{_key}"
                        if path is None:
                            path = _key
                        else:
                            path += f".{_key}" 
                        data_key, next_index= key_modifier(keys[index], keys, index)
                        _process(data[data_key], keys, next_index, results, path)
                        return
                    for key in data:
                        _path = deepcopy(path)
                        _key = key
                        if "." in _key:
                            _key = f"<{_key.count(".") + 1}>.{_key}"

                        if _path is None:
                            _path = _key
                        else:
                            _path += f".{_key}"
                        
                        data_key, next_index= key_modifier(key, keys, index)
                        _process(data[data_key], keys, next_index, results, _path)
                    return

    # Process the path pattern
    path_parts = path.split('.')
    results = []
    _process(data, path_parts, 0, results)

    return results

def key_modifier(key_pattern, path_parts, index):
    _key_pattern = key_pattern
    modifier_regex = re.compile("^<([0-9]+)>$")
    if m := modifier_regex.match(key_pattern):
        nbr_of_keys = int(m.group().strip("<>"))
        start_index = index + 1
        end_index = start_index + nbr_of_keys - 1
        if end_index >= len(path_parts):
            raise ValueError("key_modifier: The number of keys exceeds the available keys in the path.")
        _key_pattern = path_parts[start_index:end_index+1]
        _key_pattern = ".".join(_key_pattern)
        
        return (_key_pattern, end_index + 1)
    return (_key_pattern, index + 1)

def update_nested_dict(data, path, value_transformer):
    """
    Update values in a nested dictionary based on a path pattern, 
    using a function to transform old values to new values.
    
    Args:
        data (dict): The dictionary to update
        path (str): Path pattern (e.g. 'key1.*.key2')
        value_transformer (callable): Function that takes the old value and returns the new value
        
    Returns:
        dict: The updated dictionary
    """
    def _process_path(current_data, path_parts, index, transformer):
        #print("processing path part:", path_parts[index])
        # Base case - we've reached the end of the path
        if index >= len(path_parts):
            return
            
        # Get the current key pattern
        key_pattern = path_parts[index]
        
        # If we're at the last part of the path, transform the value
        if index == len(path_parts) - 1:
            if key_pattern == '*':
                # Update all keys at this level
                if isinstance(current_data, dict):
                    for k in current_data.keys():
                        current_data[k] = transformer(current_data[k])
            else:
                # Update specific key
                if isinstance(current_data, dict) and key_pattern in current_data:
                    current_data[key_pattern] = transformer(current_data[key_pattern])
            return
            
        # Handle wildcards for intermediate parts
        if key_pattern == '*':
            # Process all keys at this level
            if isinstance(current_data, dict):
                for k in current_data.keys():
                    _process_path(current_data[k], path_parts, index + 1, transformer)
        else:
            # Process specific key
            if isinstance(current_data, dict):
                _key_pattern = key_pattern
                next_index = index + 1
                if _key_pattern not in current_data:
                    _key_pattern, next_index = key_modifier(_key_pattern, path_parts, index)
                #print(f"next index: {next_index} for {_key_pattern} in {path_parts}")
                _process_path(current_data[_key_pattern], path_parts, next_index, transformer)
    
    #print("processing path:",  path)
    # Process the path pattern
    path_parts = path.split('.')
    _process_path(data, path_parts, 0, value_transformer)
    
    return data
def get_fernet_key_from_django_secret(secret_key):
    """
    Create a Fernet instance using Django's secret key.
    
    Args:
        secret_key (str): The Django SECRET_KEY
        
    Returns:
        Fernet: A Fernet instance initialized with a key derived from the Django secret key
    """
    # Django's secret key can be any string, but Fernet needs a 32-byte URL-safe base64-encoded key
    # Use SHA-256 to get exactly 32 bytes
    key_bytes = hashlib.sha256(secret_key.encode()).digest()
    
    # Encode to URL-safe base64 format as required by Fernet
    encoded_key = base64.urlsafe_b64encode(key_bytes)
    
    # Create and return the Fernet instance
    return encoded_key

