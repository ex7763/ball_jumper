ENV_PATH = ".\bin\ball_jumper.console.exe"

install:
	pip install godot-rl

train:
	python .\rl\clean_rl.py --env_path $(ENV_PATH)

train_gdrl:
	gdrl --env=gdrl --viz --env_path=.\bin\ball_jumper.console.exe