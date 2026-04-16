# AWS Bedrock LiteLLM Gateway

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

## AWS Credentials

AWS Bedrock lets you generate long-term API keys directly from the Bedrock console — no IAM user setup required.

### 1. Generate a Bedrock API key

1. Open the [Amazon Bedrock console](https://console.aws.amazon.com/bedrock/) and select your region.
2. In the left sidebar, go to **API keys** (under *Settings*).
3. Click **Create API key**, give it a name, and confirm.
4. Copy the key immediately — it is only shown once.

### 2. Enable model access

AWS requires explicit opt-in per model:

1. In the Bedrock console, go to **Model access** (left sidebar).
2. Enable the Claude model you want (e.g. *Claude Opus 4.6*).

### 3. Put the key in the config

Open `litellm-config.yaml` and paste the key into the `api_key` field:

```yaml
litellm_params:
  model: bedrock/global.anthropic.claude-opus-4-6-v1
  api_key: "xxxxxxxxxxxxxxxxxxxxx="   # ← your Bedrock API key
  aws_region_name: us-east-1         # ← region where model access is enabled
```

> **Security note:** never commit `litellm-config.yaml` to version control. Only `litellm-config-example.yaml` (with placeholder values) should be committed.

## Setup

1. Copy the example config and fill in your credentials:

   ```bash
   cp litellm-config-example.yaml litellm-config.yaml
   ```

2. Edit `litellm-config.yaml` following the [AWS Credentials](#aws-credentials) section above:
   - Set `api_key` to your Bedrock API key
   - Set `aws_region_name` to the region where you enabled model access
   - Set a strong `master_key` (this is the Bearer token clients must send)

## Running

```bash
./run-gateway.sh
```

The script will:
1. Start the LiteLLM proxy in the background
2. Start localtunnel and print the public URL to stdout
3. Shut both down cleanly on `Ctrl+C`

## Localtunnel landing page

When a localtunnel URL is opened in a **browser** for the first time, it shows a warning page asking you to enter your public IP address before it lets you through. API clients (e.g. PowerPoint add-ins) cannot do this interactively and will appear to hang.

**Fix:** add the following header to every request:

```
bypass-tunnel-reminder: true
```

Most HTTP clients and add-in configuration dialogs have a "custom headers" field where you can set this. Once the header is present, the landing page is skipped and requests go straight to the LiteLLM proxy.

For a quick browser test you can also visit:

```
https://<your-tunnel-url>/?bypass-tunnel-reminder=true
```

## Configuration

| Field | Description |
|---|---|
| `model_name` | The model alias clients use in their requests |
| `litellm_params.model` | The actual Bedrock model ID |
| `litellm_params.api_key` | Your Bedrock API key (generated in the Bedrock console) |
| `litellm_params.aws_region_name` | AWS region for Bedrock |
| `general_settings.master_key` | Bearer token clients must send as `Authorization` |

## License

MIT — see [LICENSE](LICENSE)
