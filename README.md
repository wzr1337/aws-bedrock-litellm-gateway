# LiteLLM Gateway

A lightweight LiteLLM proxy gateway that exposes AWS Bedrock models (Claude) via an OpenAI-compatible API, with optional public access via [Localtunnel](https://localtunnel.github.io/www/).

## What it does

- Starts a [LiteLLM](https://docs.litellm.ai/) proxy on port `4000`
- Routes requests to AWS Bedrock (Claude models)
- Exposes the proxy publicly using `localtunnel` so external clients (e.g. PowerPoint AI add-ins) can reach it

## Prerequisites

- Python 3.x with `pip`
- Node.js / `npx` (for localtunnel)
- AWS credentials with Bedrock access
- LiteLLM installed: `pip install -r requirements.txt`

## Setup

1. Copy the example config and fill in your credentials:

   ```bash
   cp litellm-config-example.yaml litellm-config.yaml
   ```

2. Edit `litellm-config.yaml`:
   - Replace `api_key` with your Bedrock API key
   - Set `aws_region_name` to your Bedrock region
   - Set a strong `master_key` (this is the API token clients must use)

## Running

```bash
./run-gateway.sh
```

The script will:
1. Start the LiteLLM proxy in the background
2. Start localtunnel and print the public URL to stdout
3. Shut both down cleanly on `Ctrl+C`

## Configuration

| Field | Description |
|---|---|
| `model_name` | The model alias clients use in their requests |
| `litellm_params.model` | The actual Bedrock model ID |
| `litellm_params.api_key` | Your Bedrock API key |
| `litellm_params.aws_region_name` | AWS region for Bedrock |
| `general_settings.master_key` | Bearer token clients must send as `Authorization` |

## License

MIT — see [LICENSE](LICENSE)
