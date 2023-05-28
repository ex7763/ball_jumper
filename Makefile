# ENV_PATH = ".\bin\ball_jumper.console.exe"
ENV_PATH = "./bin/ball_jumper.app/Contents/MacOS/ball_jumper"
ENV_PATH = "./bin/ball_jumper.app"
ENV_PATH = "./bin/ball_jumper.x86_64"

# SPEEDUP = 1
# SPEEDUP = 2
SPEEDUP = 8

VIZ = True
# VIZ = False

GPU = True

NUM_ENVS = 64

install:
	pip install godot-rl

train:
	python ./rl/clean_rl.py --env_path $(ENV_PATH) \
			--speedup $(SPEEDUP) \
			--cuda $(GPU) \
			--viz $(VIZ) \
			--num-minibatches 256 \
			--update-epochs 5 \
			--num-envs $(NUM_ENVS) \
			--num-steps 1024

c51:
	python ./rl/clean_rl_c51.py --env_path $(ENV_PATH) --speedup $(SPEEDUP)

sac:
	python ./rl/clean_rl_sac.py --env_path $(ENV_PATH) --speedup $(SPEEDUP)

train_sb3:
	python ./rl/sb3.py --speedup $(SPEEDUP) --env_path $(ENV_PATH) --viz $(VIZ)

# train_sb3:
#     gdrl --trainer sb3 --env gdrl --viz --env_path $(ENV_PATH)

train_rllib:
	gdrl --trainer=rllib --env=gdrl --viz --env_path=$(ENV_PATH)

train_sf:
	gdrl --trainer=sf --env=gdrl --viz --env_path=$(ENV_PATH)
