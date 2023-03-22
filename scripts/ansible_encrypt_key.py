#!/usr/bin/env python


import argparse
import subprocess
import sys

import yaml


def parse_args(args=None):
    parser = argparse.ArgumentParser(description='Encrypt an inline secret with ansible-vault')
    parser.add_argument("stdin", nargs='?', type=argparse.FileType('r'), default=sys.stdin)
    parser.add_argument("yaml_key", help="YAML key like .telegram.token")
    parser.add_argument('-f', '--file', help='The file that contains the secret', default="inventory.yml")
    return parser.parse_args(args)


def find_value(file, yaml_key) -> str:
    # Load the yaml file
    with open(file, 'r') as f:
        yaml_data = yaml.load(f, Loader=yaml.FullLoader)
        # Find key in yaml data
        for key, value in yaml_data.items():
    


def encrypt(secret: str) -> str:
    # Encrypt the secret using ansible-vault
    subprocess.check_output(['ansible-vault', 'encrypt', '--vault-id', 'ansible', '--vault-password-file', '-', secret])




def main():
    pass


if __name__ == "__main__":
    main()
