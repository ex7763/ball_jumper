import argparse

from godot_rl.wrappers.stable_baselines_wrapper import StableBaselinesGodotEnv
from stable_baselines3 import PPO
from stable_baselines3.common.callbacks import EvalCallback

# To download the env source and binary:
# 1.  gdrl.env_from_hub -r edbeeching/godot_rl_BallChase
# 2.  chmod +x examples/godot_rl_BallChase/bin/BallChase.x86_64


parser = argparse.ArgumentParser(allow_abbrev=False)
parser.add_argument(
    "--env_path",
    default=None,
    type=str,
    help="The Godot binary to use, do not include for in editor training",
)

parser.add_argument("--speedup", default=1, type=int, help="whether to speed up the physics in the env")

args, extras = parser.parse_known_args()


env = StableBaselinesGodotEnv(env_path=args.env_path, show_window=False, speedup=args.speedup)

# eval_env = StableBaselinesGodotEnv(env_path=args.env_path, show_window=True, speedup=args.speedup)
# eval_callback = EvalCallback(eval_env, best_model_save_path="./logs/log",
#                              log_path="./logs/log", eval_freq=50,
#                              deterministic=True, render=False)

model = PPO("MultiInputPolicy", env, ent_coef=0.0001, verbose=2, n_steps=32, tensorboard_log="logs/log")
model.learn(200000)

print("closing env")
env.close()