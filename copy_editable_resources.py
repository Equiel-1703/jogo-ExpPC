import shutil
import os

# Copy the levels_json to the bin folder
shutil.copytree('levels_json', 'bin/Windows/levels_json', dirs_exist_ok=True)
shutil.copytree('levels_json', 'bin/Linux/levels_json', dirs_exist_ok=True)

# Remove 'levels.json' from the output folder (this file should not be edited!)
try:
	os.remove('bin/Windows/levels_json/levels.json')
	os.remove('bin/Linux/levels_json/levels.json')
except FileNotFoundError:
	print('levels.json not found in the output folder. OK.')

print('Copied levels_json to the output folder.')

