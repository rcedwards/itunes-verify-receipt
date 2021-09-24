# iTunes Verify Receipt

Simple BASH script for [validating receipts with Apple](https://developer.apple.com/documentation/storekit/original_api_for_in-app_purchase/validating_receipts_with_the_app_store) from the command line.

## How to Use

### Install Dependencies

This script uses [`curl`](https://github.com/curl/curl) and [`jq`](https://stedolan.github.io/jq/) to form the request, send the request and parse the response.

They can be installed using the accompanying `Brewfile`.

```bash
brew bundle
``` 

### Create a `.env` File

This is a config file that will hold your [App's shared secret value](https://help.apple.com/app-store-connect/#/devf341c0f01) that is sent to the app store with the receipt for validation.

Add this value to a new `.env` file in the same directory as the script.

```bash
touch .env && echo "SECRET=YOUR_PASSWORD" > .env
```

Add a config value for specifying either the production or sandbox iTunes environment.

```bash
echo "#ItunesEnvironment=sandbox\nItunesEnvironment=production" >> .env
```

#### Example

```bash
SECRET=YOUR_PASSWORD
#ItunesEnvironment=sandbox
ItunesEnvironment=production
```

### Create a Receipt File

Create a new file within the same directory named `receipt` and populate it with your base64 encoded receipt.

```bash
touch receipt && echo "cmVjZWlwdA==" > receipt
```

### Verify

```bash
./validate.sh
```

#### Fake Example Response

```javascript
{
  "environment": "Sandbox",
  "receipt": {
    "receipt_type": "ProductionSandbox",
    "adam_id": 0,
    "app_item_id": 0,
    "bundle_id": "com.super.fun.app",
    "application_version": "1000",
    "download_id": 0,
    "version_external_identifier": 0,
    "receipt_creation_date": "2021-07-08 19:07:58 Etc/GMT",
    "receipt_creation_date_ms": "1625771278000",
    "receipt_creation_date_pst": "2021-07-08 12:07:58 America/Los_Angeles",
    "request_date": "2021-09-24 20:19:24 Etc/GMT",
    "request_date_ms": "1632514764100",
    "request_date_pst": "2021-09-24 13:19:24 America/Los_Angeles",
    "original_purchase_date": "2013-08-01 07:00:00 Etc/GMT",
    "original_purchase_date_ms": "1375340400000",
    "original_purchase_date_pst": "2013-08-01 00:00:00 America/Los_Angeles",
    "original_application_version": "1.0",
    "in_app": [
      {
        "quantity": "1",
        "product_id": "com.super.fun.product",
        "transaction_id": "1000000829104395",
        "original_transaction_id": "1000000829104395",
        "purchase_date": "2021-06-18 14:14:51 Etc/GMT",
        "purchase_date_ms": "1624025691000",
        "purchase_date_pst": "2021-06-18 07:14:51 America/Los_Angeles",
        "original_purchase_date": "2021-06-18 14:14:54 Etc/GMT",
        "original_purchase_date_ms": "1624025694000",
        "original_purchase_date_pst": "2021-06-18 07:14:54 America/Los_Angeles",
        "expires_date": "2021-06-18 14:19:51 Etc/GMT",
        "expires_date_ms": "1624025991000",
        "expires_date_pst": "2021-06-18 07:19:51 America/Los_Angeles",
        "web_order_line_item_id": "1000000063449146",
        "is_trial_period": "false",
        "is_in_intro_offer_period": "true",
        "in_app_ownership_type": "PURCHASED"
      }
    ]
  },
  "latest_receipt_info": [
    {
      "quantity": "1",
      "product_id": "com.super.fun.product",
      "transaction_id": "1000000875091810",
      "original_transaction_id": "1000000875091810",
      "purchase_date": "2021-09-09 18:32:03 Etc/GMT",
      "purchase_date_ms": "1631212323000",
      "purchase_date_pst": "2021-09-09 11:32:03 America/Los_Angeles",
      "original_purchase_date": "2021-09-09 18:32:06 Etc/GMT",
      "original_purchase_date_ms": "1631212326000",
      "original_purchase_date_pst": "2021-09-09 11:32:06 America/Los_Angeles",
      "expires_date": "2021-09-09 18:37:03 Etc/GMT",
      "expires_date_ms": "1631212623000",
      "expires_date_pst": "2021-09-09 11:37:03 America/Los_Angeles",
      "web_order_line_item_id": "1000000065701660",
      "is_trial_period": "false",
      "is_in_intro_offer_period": "false",
      "promotional_offer_id": "com.super.fun.product.promo.offer",
      "in_app_ownership_type": "PURCHASED",
      "subscription_group_identifier": "8675309",
      "app_account_token": "933c613d-2a7e-4bb0-97ba-131105a06399"
    }
  ],
  "latest_receipt": "cmVjZWlwdA==",
  "pending_renewal_info": [
    {
      "expiration_intent": "1",
      "auto_renew_product_id": "com.super.fun.product",
      "is_in_billing_retry_period": "0",
      "product_id": "com.super.fun.product",
      "original_transaction_id": "1000000875091810",
      "auto_renew_status": "0",
      "promotional_offer_id": "com.super.fun.product.promo.offer"
    }
  ],
  "status": 0
}
```

## Links

* [Status Codes](https://developer.apple.com/documentation/appstorereceipts/status)
* [RevenueCat App Store receipt checker](https://www.revenuecat.com/apple-receipt-checker)
* [Verify Request Body Format](https://developer.apple.com/documentation/appstorereceipts/requestbody)