import argparse
from distutils.util import strtobool

import wandb
from wandb.integration.sb3 import WandbCallback

from godot_rl.wrappers.stable_baselines_wrapper import StableBaselinesGodotEnv
from stable_baselines3.common.monitor import Monitor
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

parser.add_argument(
    "--speedup", default=1, type=int, help="whether to speed up the physics in the env"
)
parser.add_argument(
    "--viz",
    type=lambda x: bool(strtobool(x)),
    default=True,
    nargs="?",
    const=True,
    help="viz environments",
)

args, extras = parser.parse_known_args()


log_dir = "./logs/log"
env = StableBaselinesGodotEnv(
    env_path=args.env_path, show_window=args.viz, speedup=args.speedup
)
# env.spec = {"id": "213123"}
# env = Monitor(env, log_dir)

# eval_env = StableBaselinesGodotEnv(env_path=args.env_path, show_window=True, speedup=args.speedup)
# eval_callback = EvalCallback(eval_env, best_model_save_path="./logs/log",
#                              log_path="./logs/log", eval_freq=50,
#                              deterministic=True, render=False)

config = {
    "policy_type": "MlpPolicy",
    # "total_timesteps": 25000,
    "env_name": "ball_jumper",
}

run = wandb.init(
    project="ball_jumper",
    config=config,
    sync_tensorboard=True,  # auto-upload sb3's tensorboard metrics
    monitor_gym=False,  # auto-upload the videos of agents playing the game
    save_code=True,  # optional
)

model = PPO(
    "MultiInputPolicy",
    env,
    ent_coef=0.0001,
    verbose=2,
    n_steps=1024,
    batch_size=128,
    n_epochs=5,
    tensorboard_log="logs/log",
)
model.learn(
    200000,
    callback=WandbCallback(
        verbose=2,
        model_save_freq=0,
        model_save_path=None,
        gradient_save_freq=0,
    ),
)

print("closing env")
env.close()

run.finish()
