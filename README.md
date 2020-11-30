# Terraform-Lambda

Quick module for spinning up a terraform and scheduling it to run periodically.

Due to limitations I couldn't figure out how to fix, if you don't set an environment variable it'll set a default one of `"supersecretenvironmentvariable" = "thisisadefaultsetting"`.