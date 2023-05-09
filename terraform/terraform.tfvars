appImage="ghcr.io/tesstea/blockchain-api-client:latest"
appName="blockchain-api"
appPort=80
containerCpu=512
containerMempry=2048
environment= [
  {
    name  = "POLYGON_URL"
    value = "https://polygon-rpc.com/"
  },
  {
    name  = "APP_HOST"
    value = "0.0.0.0"
  },
  {
    name  = "APP_PORT"
    value = 80
  }
]
env="dev"
replicaCount=2
aws_region="eu-central-1"