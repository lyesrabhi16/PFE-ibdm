from typing import Any
from django.core.management.base import BaseCommand, CommandParser
from api_v1.env import Env
import json

class Command(BaseCommand):
    help = "Generate the default environment file for the IBDM API."
    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument(
            "--json",
            action="store_true",
            help="Generate the environment file in JSON format.",
        )
    
    def handle(self, *args: Any, **options: Any) -> str | None:
        """
        Generate the environment file for the IBDM API.
        """
        generate_json = options.get("json", False)
        self.stdout.write(f"Generating default environment file ({'json' if generate_json else 'env'})...")

        env_content = Env.ENV_DEFAULT_TEMPLATE
        generate_to = "settings.default.json" if generate_json else "../default.env"
        # if default.env file already exists ask user to overwrite it
        try:
            with open(generate_to, "r") as env_file:
                self.stderr.write(f"{generate_to} file already exists. Please remove it before generating a new one.")
                return None
        except FileNotFoundError:
            pass
        with open(generate_to, "w") as env_file:
            if generate_json:
                # Write the content as JSON
                json.dump(env_content, env_file, indent=4, default=str)
            else:
                output = ""
                for key, value in env_content.items():
                    if isinstance(value, list):
                        value = json.dumps(value)
                    
                    output += f"{key}={value}\n"
                env_file.write(output)
        self.stdout.write(f"Default environment file '{generate_to}' generated successfully.\nYou should now edit it to match your needs and rename it to '{'settings.json' if generate_json else '.env'}'")