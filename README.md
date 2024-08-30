# Example: Integrating Apache APISIX with Microsoft Azure AD and Open Policy Agent

This repository demonstrates how to integrate Apache APISIX with Microsoft Entra ID and Open Policy Agent (OPA) for secure API management. It showcases the use of the openid-connect plugin to validate JWT tokens and the opa plugin to enforce custom authorization policies. Ideal for developers looking to implement robust access control in their microservices architecture.

Please note that this is a proof of concept and should not be used in production without further testing and hardening. It is also work in progress and may contain bugs.

## Prerequisites

Follow https://dev.to/apisix/api-security-with-oidc-by-using-apache-apisix-and-microsoft-azure-ad-50h3 to create the `client_id`, `client_secret` and `tenant_id`.

## Usage

1. Copy `.env.example` to `.env` and fill in the values.

1. Load the .env file:
    ```bash
    source .env
    ```

1. Start the services:
    ```bash
    docker compose up
    ```

1. Obtain a JWT. The value will be in the `access_token` field:
    ```bash
    curl -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
    --data scope="$CLIENT_ID/.default" \
    --data grant_type="client_credentials" \
    --data client_id="$CLIENT_ID" \
    --data client_secret="$CLIENT_SECRET" 
    ```

1. Store the JWT in an environment variable:
    ```bash
    export JWT='<paste your access token here>'
    ```

1. Test the service:
    ```bash
    curl -i -X GET -H "Authorization: Bearer $JWT" http://127.0.0.1:9080/anything
    ```

## Configuration

Any edits to [apisix.yaml](./config/apisix.yaml) will be automatically reloaded by APISIX.

Any edits to [policy.rego](./opa_policies/policy.rego) will be automatically reloaded by OPA.

The docker compose logs will show file syntax and runtime errors as well as runtime logs.

Also ensure that you change the `admin_key` `key`value in the [config.yaml](./config/config.yaml) file.